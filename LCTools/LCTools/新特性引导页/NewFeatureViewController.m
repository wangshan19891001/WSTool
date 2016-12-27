//
//  NewFeatureViewController.m
//  
//
//  Created by 王陕 on 2016/12/12.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import "NewFeatureViewController.h"

@interface NewFeatureViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation NewFeatureViewController

#pragma mark - 是否显示引导页
/** 是否显示引导页, YES:显示 NO:不显示 */
+ (BOOL)isShowNewFeature {
    
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
        return NO;
    } else { // 这次打开的版本和上一次不一样，显示新特性
        
        return YES; //显示新特性
    }
}




#pragma mark - 引导页加载

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.frame.size.width;
    CGFloat scrollH = scrollView.frame.size.height;
    
    NSUInteger NewfeatureCount = self.images.count;
    
    for (int i = 0; i<NewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i * scrollW, 0, scrollW, scrollH);
        
        // 显示图片
        imageView.image = [UIImage imageNamed:self.images[i]];
        
        
        // 如果是最后一个imageView，就往里面添加其他内容
        if (i == NewfeatureCount - 1) {
            [self setupLastImageView:imageView];
        }
        
        [scrollView addSubview:imageView];
    }
    
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(NewfeatureCount * scrollW, 0);
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    // 4.添加pageControl：分页，展示目前看的是第几页
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = NewfeatureCount;
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:223 blue:255 alpha:1];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:100 green:113 blue:130 alpha:1];
    pageControl.center = CGPointMake(scrollW * 0.5, scrollH - 50);
//    pageControl.centerX = scrollW * 0.5;
//    pageControl.centerY = scrollH - 50;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = (int)(page + 0.5);
}

/**
 *  初始化最后一个imageView
 *
 *  @param imageView 最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    
    
    //开始btn
    UIButton *beginBtn = [[UIButton alloc] init];
    UIImage *image = [UIImage imageNamed:@"开启智能之旅"];
    [beginBtn setBackgroundImage:image forState:UIControlStateNormal];
    CGRect frame = beginBtn.frame;
    frame.size = beginBtn.currentBackgroundImage.size;
    beginBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height - 75 - 139*0.5);
//    beginBtn.size = beginBtn.currentBackgroundImage.size;
//    beginBtn.centerX = [UIScreen mainScreen].bounds.size.width*0.5;
//    beginBtn.centerY = [UIScreen mainScreen].bounds.size.height - 75 - 139*0.5;
    [beginBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:beginBtn];

}


/** 启动 */
- (void)startClick
{
    // 将当前的版本号存进沙盒
    NSString *key = @"CFBundleVersion";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];// 当前软件的版本号（从Info.plist中获得）
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //跳转到app主页
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = self.windowRootViewController;
}


#pragma mark - 引导页页面释放
- (void)dealloc
{
    NSLog(@"NewfeatureViewController-dealloc");
}



@end
