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
#import "UIView+FrameExtension.h"
#import "NSString+Hash.h"
#import "Person.h"


#import "DOPDropDownMenu.h"


#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width

#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


@interface ViewController ()<UITextFieldDelegate, DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>

//@property (nonatomic, strong) FMDatabaseQueue *queue;

@property (nonatomic, weak) UITextField *textField;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottomConstraints;


@property (nonatomic, strong) DOPDropDownMenu* menu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //          \U79e6\U6811\U65b0
    
//    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
//    self.menu.dataSource = self;
//    self.menu.delegate = self;
//    
//    self.menu.frame = CGRectMake(0, 0, kScreenW, 50);
//    [self.view addSubview:self.menu];
    
}


#pragma mark - 归档与反归档

// 复杂对象归档
- (void)archiver
{
    // 初始化对象
    Person *model = [[Person alloc] init];
    // 赋值对象
    model.name = @"悟空";
    model.age = 500;
    // 将 图片转化成data
    // 把一个png格式的转化为data
    model.data = UIImagePNGRepresentation([UIImage imageNamed:@"pic2"]);
    
    // 创建一个可变data 初始化归档对象
    NSMutableData *data = [NSMutableData data];
    // 创建一个归档对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    // 进行归档编码
    [archiver encodeObject:model forKey:@"JJModel"]; //此时调用归档方法encodeWithCoder:
    
    // 编码完成
    [archiver finishEncoding];
    // 实际上归档 相当于把编码完的对象 保存到data中
    NSLog(@"%@", data);
    // 把存有复杂对象的data写入文件中进行持久化
    
    // 路径
    NSString *dataPath = [kDocumentPath stringByAppendingPathComponent:@"JJModel.da"];
    // 写入方法
    [data writeToFile:dataPath atomically:YES];
    
    NSLog(@"%@", dataPath);
    
}
// 反归档 解码的过程
- (void)unArchiver
{
    // 创建反归档对象
    // 获取刚才归档的data
    NSString *dataPath = [kDocumentPath stringByAppendingPathComponent:@"JJModel.da"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 解码返回一个对象
    Person *model = [unArchiver decodeObjectForKey:@"JJModel"]; // 此时调用反归档方法initWithCoder:
    // 反归档完成
    [unArchiver finishDecoding];
    
    
    
    UIImage *image = [UIImage imageWithData:model.data];
    NSLog(@"%@", model);
}



//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    
//    [self.view removeConstraint:_toolBarBottomConstraints];
//    NSLayoutConstraint *new = [NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-500.0];
//    
//    [self.view addConstraint:new];
//    
//}

#pragma mark - 监听键盘高度,使输入框贴这键盘移动

- (void)setKeyboardNotification {
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, kScreenH - 30, kScreenW, 30)];
    tf.text = @"test";
    [self.view addSubview:tf];
    self.textField = tf;
    self.textField.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)keyboardWillChangeFrame:(NSNotification*)notification {
    
    //获取键盘高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat keyboardY = keyboardRect.origin.y;
    
    //获取输入框的y值
    self.textField.y = keyboardY - self.textField.height;
    
}


#pragma mark - FMDB 数据库
- (void)message {
    
    DataBase *dbManager = [DataBase sharedManager];
    
    Message *message = [[Message alloc] init];
    message.userId = @1;
    message.FunctionId = @1;
    message.Title = @"标题3";
    message.Msg = @"我是消息3";
    [dbManager insertMsg:message];
    
    
    NSArray *msgArray = [dbManager selectMsgArrayWithUserId:@1 functionId:@1];
    for (Message *message in msgArray) {
        NSLog(@"%@", message.Msg);
    }
    
    NSLog(@"%@", msgArray);
    
}

//FMDB 多线程处理
- (void)FMDB_Queue {
    
    
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
    
//    NSMutableArray *array = [NSMutableArray array];
//    DataBase *dbManager = [DataBase sharedManager];
//    
//    for (int i = 0; i < 10; i++) {
//        Person *person = [[Person alloc] init];
//        person.ID = [NSNumber numberWithInt:i];
//        person.name = @"Alice";
//        person.image = [UIImage imageNamed:@"newImage"];
//        [array addObject:person];
//    }
//    
//    [dbManager insertPersonArray:array];
    
}

// 测试
- (IBAction)dropTable:(UIButton *)sender {
//    DataBase *dbManager = [DataBase sharedManager];
//    [dbManager clearTable];
    
}

#pragma mark - AES加密算法
- (void)AES {
    

    
    NSString *secret = @"5hQxKalvbcaE+dbObSPlNg==";
    
    NSString *key = @"30E93ECB5D1E3C14";
    
    NSString *source1 = [secret aes256_decrypt_base64:key];
    NSLog(@"%@", source1);
    
    
    
}

//base64 编码
- (NSString *)base64StringFromText:(NSString *)text {
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    
    return base64String;
}

//base64 反编码
- (NSString *)textFromBase64String:(NSString *)base64 {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return text;
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
