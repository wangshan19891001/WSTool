//
//  ViewController.m
//  LCTools
//
//  Created by 王陕 on 16/10/12.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hano(3, 1, 2, 3);
    
}


#pragma mark - 递归算法

//阶乘
int recursive(int i)
{
    int sum = 0;
    if (0 == i)
        return (1);
    else
        sum = i * recursive(i-1);
    return sum;
}


void hano(int n, int p1, int p2, int p3)
{
    if (n == 1) {
        NSLog(@"%d -> %d", p1,p3);
    }else{
        
        hano(n-1, p1, p3, p2);
        NSLog(@"%d -> %d", p1,p3);
        hano(n-1, p2, p1, p3);
    }
    
}
    



@end
