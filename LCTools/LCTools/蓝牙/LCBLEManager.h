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


@interface LCBLEManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>


+ (instancetype)sharedManager;


@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *connectedPeripheral;
@property (nonatomic, strong) NSMutableArray   *discoveredPeripherals;

//这样的话，要是需要直接引用变量就用_xxxx，当需要用get，set方法时，就用self.xxx。
// action flags
@property (readonly) BOOL isConnected;//readonly
@property (readonly) BOOL isReady;//readonly


@end
