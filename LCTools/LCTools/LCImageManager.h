//
//  LCImageManager.h
//  LCTools
//
//  Created by 王陕 on 16/10/12.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCImageManager : NSObject

/** LCImageManager 单例 */
+ (instancetype)sharedManager;
/** 图片压缩方法 */
- (NSData *)imageCompressForSize:(UIImage *)sourceImage targetPx:(NSInteger)targetPx;

@end
