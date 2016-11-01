//
//  ViewController.m
//  LCTools
//
//  Created by 王陕 on 16/10/12.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import "ViewController.h"
#import "LCBLEManager.h"

#import "NSString+AES256.h"

#import "DataBase.h"
#import <FMDB.h>

@interface ViewController ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    
    
    
    
    
}

- (IBAction)dropTable:(UIButton *)sender {
    DataBase *dbManager = [DataBase sharedManager];
    [dbManager clearTable];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        DataBase *dbManager = [DataBase sharedManager];
//        
//        for (int i = 0; i < 1000; i++) {
//            Person *person = [[Person alloc] init];
//            person.ID = @1;
//            person.name = @"Alice";
//            person.image = [UIImage imageNamed:@"newImage"];
//            [dbManager insertPerson:person];
//        }
//    });
    
    //创建数据库
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *fileName = [documentPath stringByAppendingPathComponent:@"sql.sqlite"]; //此处需要传入存在的确定的路径
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:fileName];
//    [queue inDatabase:^(FMDatabase *db) {
//        
//        
//        NSLog(@"创建一个队列");
//        DataBase *dbManager = [DataBase sharedManager];
//        
//        for (int i = 0; i < 1000; i++) {
//            Person *person = [[Person alloc] init];
//            person.ID = [NSNumber numberWithInt:i];
//            person.name = @"Alice";
//            person.image = [UIImage imageNamed:@"newImage"];
//            [dbManager insertPerson:person];
//        }
//    }];
    
    NSMutableArray *array = [NSMutableArray array];
    DataBase *dbManager = [DataBase sharedManager];
    
    for (int i = 0; i < 10; i++) {
        Person *person = [[Person alloc] init];
        person.ID = [NSNumber numberWithInt:i];
        person.name = @"Alice";
        person.image = [UIImage imageNamed:@"newImage"];
        [array addObject:person];
    }
    
    [dbManager insertPersonArray:array];
    
    
}



- (void)AES {
    
    //4d5237686126d7209e224d02c8e38c644d5237686126d7209e224d02c8e38c64
    
    NSString *source = @"4d5237686126d7209e224d02c8e38c644d5237686126d7209e224d02c8e38c64";
    NSString *key = @"15319728628";
    
    NSString *secret = [source aes256_encrypt:key];
    NSLog(@"密文: %@", secret);
    
    NSString *deSecret = [secret aes256_decrypt:key];
    NSLog(@"明文: %@", deSecret);
    
    
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

#pragma mark - BlueTooth
- (void)blueTooth {
    
    LCBLEManager *manager = [LCBLEManager sharedManager];
    
    NSLog(@"%@", manager);
    
}

#pragma mark - C 语言内存操作函数
- (void)malloc {
    // malloc
    // malloc 和 calloc 都可以分配内存区, 但malloc一次只能申请一个内存区, calloc 一次可以申请多个内存区. 另外calloc会把分配来的内存区初始化为0, malloc 不会进行初始化.
    int *p = NULL;
    p = (int*)malloc(sizeof(int));
    if (p == NULL) {
        printf("malloc error \n");
    }else{
        printf("p = %p \n", p);
    }
    
    *p = 3;
    printf("*p = %d \n", *p);
    free(p);
}

- (void)memset {
    
    //memset
    //memset 把buffer所指内存区域的前lenth 个字节设置成某个字符的ASCII值. 一般用于给数组,字符串等类型赋值
    int *p = NULL;
    //    int i;
    char *q = NULL;
    
    p = (int *)malloc(sizeof(int) * 10);
    if (p == NULL) {
        return;
    }
    
    //  '!' 对应的ASCII码是33
    // 把p所指内存区域的前 10个字节长度的内存区 设置成33(! 对应的ASCII值)
    memset(p, 33, sizeof(int)*10);
    q = (char *)p;
    for (int i = 0; i < 10; i ++) {
        printf("%c \n", *(q++));
    }
    
    free(p);
    
}

//有问题, 程序在释放时会崩溃
- (void)memcpy {
    
    //memcpy
    //memcpy
    int *p1 = NULL;
    int *p2 = NULL;
    //    int *q = NULL;
    int q;
    
    
    p1 = malloc(sizeof(int) * 10);
    if (p1 == NULL) {
        return;
    }
    
    p2 = malloc(sizeof(int) * 10);
    if (p2 == NULL) {
        return;
    }
    
    memset(p1, 10, sizeof(int)*10);
    
    //p2 是目标区域
    //p1 是将被复制的原内存区域
    memcpy(p2, p1, sizeof(int)*5);
    
    
    //    q = p2;
    for (int i = 0; i < 5; i ++) {
        printf("%d \n", *(p2++));
    }
    
    free(p1);
    free(p2);
    
}




@end
