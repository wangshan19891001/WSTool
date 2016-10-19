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


#pragma mark - CBCentralManagerDelegate
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
- (void)scan
{
//    BXCFunctionLog();
    [_discoveredPeripherals removeAllObjects];
    if (self.isReady) {
        NSArray *serviceUUIDs = nil;
//        if ([_delegate respondsToSelector:@selector(serviceUUIDsOfDevice)]) {
//            serviceUUIDs = [_delegate serviceUUIDsOfDevice];
//        }
        // 将options 项加了@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES } 键值对，这样会扫描之前扫描到的。
        [_centralManager scanForPeripheralsWithServices:serviceUUIDs options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    }
}

- (void)stopScan
{
//    BXCFunctionLog();
    [_centralManager stopScan];
}

// disconnect before connect, otherwise, it will do nothing.
- (void)connect:(CBPeripheral *)peripheral
{
//    BXCFunctionLog();
    NSLog(@"%@", peripheral);
    if (self.isReady && !self.isConnected && peripheral && peripheral.state == CBPeripheralStateDisconnected) {
        [_centralManager connectPeripheral:peripheral options:nil];
    }
}

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












@end
