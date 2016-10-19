//
//  BLKLockSecretUtil.h
//  CRTest
//
//  Created by Andy on 16/7/22.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLKLockSecretUtil : NSObject

+ (void)getOutKey:(uint8_t*)outKey WithInKey:(uint8_t *)inkey andSecretKey:(uint8_t *)secretKey;


+ (uint16_t)get_checksumBuffer:(uint8_t*) buffer Size:(uint32_t)size;

@end
