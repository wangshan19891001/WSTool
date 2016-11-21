//
//  Message.h
//  xjpark
//
//  Created by 王陕 on 2016/11/18.
//  Copyright © 2016年 FeelingOnline. All rights reserved.
//

#import "CYZBaseModel.h"

@interface Message : CYZBaseModel<NSCoding>
@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) NSNumber* FunctionId;
@property (nonatomic, copy) NSString* Title;
@property (nonatomic, copy) NSString* Msg;
@end
