//
//  Person.h
//  LCTools
//
//  Created by 王陕 on 2016/11/21.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

/** *  复杂对象最持久化 需要遵守一个协议<NSCoding>
 */
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, retain) NSData *data;
@end
