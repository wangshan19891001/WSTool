//
//  LCEncryption.m
//  Test
//
//  Created by 王陕 on 16/10/19.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import "LCEncryption.h"
#import "BLKLockSecretUtil.h"
#import "NSString+Hash.h"

@implementation LCEncryption

//单例
+ (instancetype)sharedManager{
    static LCEncryption *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LCEncryption alloc] init];
    });
    return manager;
}

//对称加密解密
- (NSString *)encryptionWithSourceString:(NSString *)string key:(NSString *)key {
    
    NSData *contentData = [self dataWithString:string];
    
    NSString *str = [key.md5String stringByAppendingString:key.md5String];
    NSData *keyData = [self dataWithString:str];
    Byte* key1 = (Byte*)[keyData bytes];
    
    
    
    Byte *inKey = (Byte*)[contentData bytes];
    
    //outKey
    Byte outKey[32] = {0};
    
    [BLKLockSecretUtil getOutKey:outKey WithInKey:inKey andSecretKey:key1];
    
    //将outKey 转为字符串
    NSMutableString *secretString = [NSMutableString string];
    for (int i = 0; i < 32; i++) {
        [secretString appendFormat:@"%02X", outKey[i]];
    }
    
    return secretString;
}




//将字符串转为16进制整数
int strTohex(const char *ch)
{
    int i=0, tmp, result=0;
    
    for(i=0; i<strlen(ch); i++) /* 把字符一个一个转成16进制数 */
    {
        if((ch[i]>='0')&&(ch[i]<='9'))
            tmp = ch[i]-'0';
        else if((ch[i]>='A')&&(ch[i]<='F'))
            tmp = ch[i]-'A'+10;
        else if((ch[i]>='a')&&(ch[i]<='f'))
            tmp = ch[i]-'a'+10;
        else
            return -1;  /* 出错了 */
        
        result = result*16+tmp;  /* 转成16进制数后加起来 */
    }
    return result;
}

//将32字节字符串,转为data类型数据
- (NSData *)dataWithString:(NSString *)string {
    
    NSMutableData *data = [NSMutableData data];
    for (int i = 0; i < 63; i += 2) {
        NSString *subString = [string substringWithRange:NSMakeRange(i, 2)];
        const char* subCString = [subString UTF8String];
        int n = strTohex(subCString);
        [data appendBytes:&n length:1];
        //        NSLog(@"n = %02x", n);
    }
    return data;
}




@end
