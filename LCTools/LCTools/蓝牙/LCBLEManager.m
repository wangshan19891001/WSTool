//
//  LCBLEManager.m
//  LCTools
//
//  Created by 王陕 on 16/10/19.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import "LCBLEManager.h"

@implementation LCBLEManager

+ (instancetype)sharedManager {
    static LCBLEManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LCBLEManager alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        //这句代码触发后, 会自动检测手机的蓝牙状态
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        
        _connectedPeripheral = nil;
        _discoveredPeripherals = [[NSMutableArray alloc] init];
    }
    return self;
}



#pragma mark - getters and setters

- (CBCentralManagerState)stateOfCentralManager
{
    return [_centralManager state];
}

- (BOOL)isReady
{
    return (_centralManager.state == CBCentralManagerStatePoweredOn);
}

- (BOOL)isConnected
{
    return (_connectedPeripheral.state == CBPeripheralStateConnected);
}


#pragma mark - LCBLEManager operation
//开始扫描
- (void)scan
{
//    BXCFunctionLog();
    [_discoveredPeripherals removeAllObjects];
    if (self.isReady) {
        NSArray *serviceUUIDs = nil;
        if ([_delegate respondsToSelector:@selector(serviceUUIDsOfDevice)]) {
            serviceUUIDs = [_delegate serviceUUIDsOfDevice];
        }
        // 将options 项加了@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES } 键值对，这样会扫描之前扫描到的。
        [_centralManager scanForPeripheralsWithServices:serviceUUIDs options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    }
}

//停止扫描
- (void)stopScan
{
//    BXCFunctionLog();
    [_centralManager stopScan];
}

//发起连接
// disconnect before connect, otherwise, it will do nothing.
- (void)connect:(CBPeripheral *)peripheral
{
//    BXCFunctionLog();
    NSLog(@"%@", peripheral);
    if (self.isReady && !self.isConnected && peripheral && peripheral.state == CBPeripheralStateDisconnected) {
        [_centralManager connectPeripheral:peripheral options:nil];
    }
}

//断开连接
- (void)cancelConnection
{
//    BXCFunctionLog();
    if (self.isReady && self.isConnected) {
        [_centralManager cancelPeripheralConnection:_connectedPeripheral];
    }
}

- (void)cancelConnectionAnyWay:(CBPeripheral*) peripheral{
    if (_connectedPeripheral == nil) {
        return;
    }
    [_centralManager cancelPeripheralConnection:peripheral];
    
}





#pragma mark - CBCentralManagerDelegate
//中心设备代理方法, 监听中心设备(手机)蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    //iOS 10+
    //CBManagerState
    //    CBManagerStateUnknown = 0,
    //    CBManagerStateResetting,
    //    CBManagerStateUnsupported,
    //    CBManagerStateUnauthorized,
    //    CBManagerStatePoweredOff,
    //    CBManagerStatePoweredOn,
    
    //iOS 10-
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            break;
        default:
            break;
    }
    
    if ([_delegate respondsToSelector:@selector(centralManagerDidUpdateState:)]) {
        [_delegate centralManagerDidUpdateState:central];
    }
    
}


/*!
 *  @method centralManager:willRestoreState:
 *
 *  @param central      The central manager providing this information.
 *  @param dict			A dictionary containing information about <i>central</i> that was preserved by the system at the time the app was terminated.
 *
 *  @discussion			For apps that opt-in to state preservation and restoration, this is the first method invoked when your app is relaunched into
 *						the background to complete some Bluetooth-related task. Use this method to synchronize your app's state with the state of the
 *						Bluetooth system.
 *
 *  @seealso            CBCentralManagerRestoredStatePeripheralsKey;
 *  @seealso            CBCentralManagerRestoredStateScanServicesKey;
 *  @seealso            CBCentralManagerRestoredStateScanOptionsKey;
 *
 */
//- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
//    
//}

/*!
 *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
 *
 *  @param central              The central manager providing this update.
 *  @param peripheral           A <code>CBPeripheral</code> object.
 *  @param advertisementData    A dictionary containing any advertisement and scan response data.
 *  @param RSSI                 The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
 *								was not available.
 *
 *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. A discovered peripheral must
 *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager. For
 *                              a list of <i>advertisementData</i> keys, see {@link CBAdvertisementDataLocalNameKey} and other similar constants.
 *
 *  @seealso                    CBAdvertisementData.h
 *
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"%@:RSSI = %@", peripheral,RSSI);
    
    // 根据信号强度来判断是否足够近，否则返回
    /*if (RSSI.intValue  < -60) {
     
     return;
     }*/
    
    int deleteIndex = 0xFFFF;
    
    if ([peripheral.name containsString:@"Smurfs"]) { //如果是锁设备则添加
        
        
        for (int i=0;i<_discoveredPeripherals.count;i++) {
            if (peripheral == _discoveredPeripherals[i]) {
                deleteIndex = i;
                break;
            }
        }//如果已经存在该设备则删除，并重新添加
        
        if(deleteIndex != 0xFFFF) //如果是0xffff表示没有找到重复的设备
        {
            [_discoveredPeripherals removeObjectAtIndex:deleteIndex];
        }
        
        
        [_discoveredPeripherals addObject:peripheral];
        if ([_delegate respondsToSelector:@selector(discoveredPeripheralsChanged)]) {
            [_delegate discoveredPeripheralsChanged];
        }
    }
    
}

/*!
 *  @method centralManager:didConnectPeripheral:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has connected.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
 *
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    peripheral.delegate = self;
    _connectedPeripheral = peripheral;
    NSArray *serviceUUIDs = nil;
    if ([_delegate respondsToSelector:@selector(serviceUUIDsOfDevice)]) {
        serviceUUIDs = [_delegate serviceUUIDsOfDevice];
    }
    [_connectedPeripheral discoverServices:serviceUUIDs];
    if ([_delegate respondsToSelector:@selector(didConnected:)]) {
        [_delegate didConnected:peripheral];
    }
    if ([_delegate respondsToSelector:@selector(statusChanged)]) {
        [_delegate statusChanged];
    }
    
}

/*!
 *  @method centralManager:didFailToConnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has failed to connect.
 *  @param error        The cause of the failure.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has failed to complete. As connection attempts do not
 *                      timeout, the failure of a connection is atypical and usually indicative of a transient issue.
 *
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    if ([_delegate respondsToSelector:@selector(didFailConnected:error:)]) {
        [_delegate didFailConnected:peripheral error:error];
    }
    
    
}

/*!
 *  @method centralManager:didDisconnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by {@link connectPeripheral:options:}. If the disconnection
 *                      was not initiated by {@link cancelPeripheralConnection}, the cause will be detailed in the <i>error</i> parameter. Once this method has been
 *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
 *
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"%@", error);
    }

    if ([_delegate respondsToSelector:@selector(didDisConnected:error:)]) {
        [_delegate didDisConnected:peripheral error:error];
    }
    if ([_delegate respondsToSelector:@selector(statusChanged)]) {
        [_delegate statusChanged];
    }
    _connectedPeripheral.delegate = nil;
    _connectedPeripheral = nil;
}


#pragma mark - CBPeripheralDelegate
/*!
 *  @method peripheralDidUpdateName:
 *
 *  @param peripheral	The peripheral providing this update.
 *
 *  @discussion			This method is invoked when the @link name @/link of <i>peripheral</i> changes.
 */
//- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(NA, 6_0) {
//    
//}

/*!
 *  @method peripheral:didModifyServices:
 *
 *  @param peripheral			The peripheral providing this update.
 *  @param invalidatedServices	The services that have been invalidated
 *
 *  @discussion			This method is invoked when the @link services @/link of <i>peripheral</i> have been changed.
 *						At this point, the designated <code>CBService</code> objects have been invalidated.
 *						Services can be re-discovered via @link discoverServices: @/link.
 */
//- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices NS_AVAILABLE(NA, 7_0) {
//    
//}

/*!
 *  @method peripheralDidUpdateRSSI:error:
 *
 *  @param peripheral	The peripheral providing this update.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link readRSSI: @/link call.
 *
 *  @deprecated			Use {@link peripheral:didReadRSSI:error:} instead.
 */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error NS_DEPRECATED(NA, NA, 5_0, 8_0) {
    
    if (error) {
        NSLog(@"%@", error);
    }
    if ([_delegate respondsToSelector:@selector(peripheral:didUpdateRSSI:error:)]) {
        [_delegate peripheral:peripheral didUpdateRSSI:peripheral.RSSI error:error];
    }
    
}

/*!
 *  @method peripheral:didReadRSSI:error:
 *
 *  @param peripheral	The peripheral providing this update.
 *  @param RSSI			The current RSSI of the link.
 *  @param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link readRSSI: @/link call.
 */
//- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error NS_AVAILABLE(NA, 8_0) {
//    
//}

/*!
 *  @method peripheral:didDiscoverServices:
 *
 *  @param peripheral	The peripheral providing this information.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverServices: @/link call. If the service(s) were read successfully, they can be retrieved via
 *						<i>peripheral</i>'s @link services @/link property.
 *
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"%@", error);
    }
    if ([_delegate respondsToSelector:@selector(peripheral:didDiscoverServices:error:)]) {
        [_delegate peripheral:peripheral didDiscoverServices:peripheral.services error:error];
    }
}

/*!
 *  @method peripheral:didDiscoverIncludedServicesForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the included services.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverIncludedServices:forService: @/link call. If the included service(s) were read successfully,
 *						they can be retrieved via <i>service</i>'s <code>includedServices</code> property.
 */
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
//    
//}

/*!
 *  @method peripheral:didDiscoverCharacteristicsForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the characteristic(s).
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverCharacteristics:forService: @/link call. If the characteristic(s) were read successfully,
 *						they can be retrieved via <i>service</i>'s <code>characteristics</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"%@", error);
    }
    if ([_delegate respondsToSelector:@selector(peripheral:didDiscoverCharacteristicsForService:error:)]) {
        [_delegate peripheral:peripheral didDiscoverCharacteristicsForService:service error:error];
    }
}

/*!
 *  @method peripheral:didUpdateValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"%@", error);
    }
    if ([_delegate respondsToSelector:@selector(peripheral:didUpdateValueForCharacteristic:error:)]) {
        [_delegate peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
    }
}

/*!
 *  @method peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a {@link writeValue:forCharacteristic:type:} call, when the <code>CBCharacteristicWriteWithResponse</code> type is used.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"%@", error);
    }
    if ([_delegate respondsToSelector:@selector(peripheral:didWriteValueForCharacteristic:error:)]) {
        [_delegate peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
    }
}

/*!
 *  @method peripheral:didUpdateNotificationStateForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    if (error) {
        NSLog(@"%@", error);
    }
    if ([_delegate respondsToSelector:@selector(peripheral:didUpdateNotificationStateForCharacteristic:error:)]) {
        [_delegate peripheral:peripheral didUpdateNotificationStateForCharacteristic:characteristic error:error];
    }
    
}

/*!
 *  @method peripheral:didDiscoverDescriptorsForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link discoverDescriptorsForCharacteristic: @/link call. If the descriptors were read successfully,
 *							they can be retrieved via <i>characteristic</i>'s <code>descriptors</code> property.
 */
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
//
//}

/*!
 *  @method peripheral:didUpdateValueForDescriptor:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param descriptor		A <code>CBDescriptor</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link readValueForDescriptor: @/link call.
 */
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
//
//}

/*!
 *  @method peripheral:didWriteValueForDescriptor:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param descriptor		A <code>CBDescriptor</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link writeValue:forDescriptor: @/link call.
 */
//- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
//    
//}




@end
