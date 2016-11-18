//
//  Message.m
//  xjpark
//
//  Created by 王陕 on 2016/11/18.
//  Copyright © 2016年 FeelingOnline. All rights reserved.
//

#import "Message.h"

@implementation Message

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeObject:_FunctionId forKey:@"FunctionId"];
    [aCoder encodeObject:_Title forKey:@"Title"];
    [aCoder encodeObject:_Msg forKey:@"Msg"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _userId = [aDecoder decodeObjectForKey:@"userId"];
        _FunctionId = [aDecoder decodeObjectForKey:@"FunctionId"];
        _Title = [aDecoder decodeObjectForKey:@"Title"];
        _Msg = [aDecoder decodeObjectForKey:@"Msg"];
    }
    return self;
}



@end
