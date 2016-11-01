//
//  Person.h
//  LCTools
//
//  Created by 王陕 on 16/10/31.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImage *image;

@end
