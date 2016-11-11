//
//  NSString+AES256.h
//  LCTools
//
//  Created by 王陕 on 16/10/24.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "NSData+AES256.h"


@interface NSString (AES256)

/** AES加密,编码方式:base64 */
-(NSString *) aes256_encrypt_base64:(NSString *)key;
/** AES解密,编码方式:base64 */
-(NSString *) aes256_decrypt_base64:(NSString *)key;

/** AES加密,编码方式:十六进制 */
-(NSString *) aes256_encrypt_16:(NSString *)key;
/** AES解密,编码方式:十六进制 */
-(NSString *) aes256_decrypt_16:(NSString *)key;

@end
