//
//  LCBLEManager.h
//  LCTools
//
//  Created by 王陕 on 16/10/19.
//  Copyright © 2016年 王陕. All rights reserved.
//
// 中心设备centralManager 是手机
// 外围设备peripheral  是蓝牙设备


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol LCBLEManagerDelegate <NSObject>

- (NSArray *)serviceUUIDsOfDevice;// elements of type CBUUID
- (void)statusChanged;// syncing/connected/disconnected/matched (监听蓝牙状态改变)

// callback of central manager
- (void)centralManagerDidUpdateState:(CBCentralManager *)central;
- (void)discoveredPeripheralsChanged;// callback-function when a peripheral has been found when scanning. may calling multiple times.
- (void)didConnected:(CBPeripheral *)peripheral;
- (void)didFailConnected:(CBPeripheral *)peripheral error:(NSError *)error;
- (void)didDisConnected:(CBPeripheral *)peripheral error:(NSError *)error;
// end



// callback of connected peripheral
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSArray *)services error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didUpdateRSSI:(NSNumber *)RSSI error:(NSError *)error;// result of calling readRSSI

// end





@end



@interface LCBLEManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>


+ (instancetype)sharedManager;

@property (nonatomic, weak) id<LCBLEManagerDelegate> delegate;

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *connectedPeripheral;
@property (nonatomic, strong) NSMutableArray   *discoveredPeripherals;

//这样的话，要是需要直接引用变量就用_xxxx，当需要用get，set方法时，就用self.xxx。
// action flags
@property (readonly) BOOL isConnected;//readonly
@property (readonly) BOOL isReady;//readonly


- (void)scan;
- (void)stopScan;
- (void)connect:(CBPeripheral *)peripheral;
- (void)cancelConnection;
- (void)cancelConnectionAnyWay:(CBPeripheral*) peripheral;//不管状态直接断开


@end
