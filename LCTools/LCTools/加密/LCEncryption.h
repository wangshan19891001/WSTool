//
//  LCEncryption.h
//  Test
//
//  Created by 王陕 on 16/10/19.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCEncryption : NSObject

/** 单例 */
+ (instancetype)sharedManager;
/** 对称加密解密 */
- (NSString *)encryptionWithSourceString:(NSString *)string key:(NSString *)key;



@end
