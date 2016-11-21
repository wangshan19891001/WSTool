//
//  Person.m
//  LCTools
//
//  Created by 王陕 on 2016/11/21.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import "Person.h"

@implementation Person


// 对复杂对象持久化叫做归档与反归档(编码与解码)

// 归档方法 编码成可以持久化的格式(归档时调用)
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // 对每一个属性都要进行重新编码
    // 注意:属性的类型
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeObject:self.data forKey:@"data"];
    
    
}
// 反归档方法 解码的过程(反归档时调用)
-(id)initWithCoder:(NSCoder *)aDecoder
{
    //
    self = [super init];
    if (self) {
        
        // 解码的过程
        // 和编码一样 除了对象类型外也是有特殊解码方法
        // 注意:编码时候给的key要和解码key一样
        self.name = [aDecoder decodeObjectForKey:@"name"];
        //注意类型
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        self.data = [aDecoder decodeObjectForKey:@"data"];
        
    }
    return self;
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // KVC赋值保护方法
}


@end
