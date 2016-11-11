//
//  NSString+AES256.m
//  LCTools
//
//  Created by 王陕 on 16/10/24.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import "NSString+AES256.h"

@implementation NSString (AES256)


/** AES加密,编码方式:base64 */
-(NSString *) aes256_encrypt_base64:(NSString *)key {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data aes256_encrypt:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        
        NSData *data = [NSData dataWithBytes:datas length:result.length];
        NSString *base64String = [data base64EncodedStringWithOptions:0];
        
        return base64String;
        
    }
    return nil;
}

/** AES解密,编码方式:base64 */
-(NSString *) aes256_decrypt_base64:(NSString *)key
{
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    //对数据进行解密
    NSData* result = [data aes256_decrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}





/** AES加密,编码方式:十六进制 */
-(NSString *) aes256_encrypt_16:(NSString *)key
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data aes256_encrypt:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        
        return output;
    }
    return nil;
}
/** AES解密,编码方式:十六进制 */
-(NSString *) aes256_decrypt_16:(NSString *)key
{
    
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data aes256_decrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}


#pragma mark - base64编解码
//base64 编码
- (NSString *)base64StringFromText:(NSString *)text {
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    
    return base64String;
}

//base64 反编码
- (NSString *)textFromBase64String:(NSString *)base64 {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return text;
}



@end
