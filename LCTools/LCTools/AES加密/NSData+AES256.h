//
//  NSData+AES256.h
//  LCTools
//
//  Created by 王陕 on 16/10/24.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@interface NSData (AES256)

-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;

@end
