//
//  NewFeatureViewController.h
//
//
//  Created by 王陕 on 2016/12/12.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeatureViewController : UIViewController

/** 是否显示引导页, YES:显示 NO:不显示 */
+ (BOOL)isShowNewFeature;


@property (nonatomic, strong) UIViewController* windowRootViewController;

/** 保存图片名称的数组 */
@property (nonatomic, strong) NSArray* images;




@end
