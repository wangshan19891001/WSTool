//
//  DataBase.m
//  LCTools
//
//  Created by 王陕 on 16/10/31.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"

@interface DataBase ()

@property (nonatomic, strong) FMDatabase *dataBase;
@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;

@end

@implementation DataBase
/** 数据库单例 */
+ (instancetype)sharedManager {
    static DataBase *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataBase alloc] init];
        [manager createDataBase];
    });
    return manager;
}

- (void)createDataBase {
    
    //创建数据库
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"park.sqlite"]; //此处需要传入存在的确定的路径
    self.dataBase = [FMDatabase databaseWithPath:fileName];
    self.dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    NSLog(@"数据库路径: %@", fileName);
    
    if ([self.dataBase open]) {
        NSLog(@"数据库打开成功");
        
        //创建数据库表
        BOOL result = [self.dataBase executeUpdate:@"create table if not exists Message(ID integer primary key AUTOINCREMENT, userId integer not null, FunctionId integer, MessageBody text, constraint uk_userId_FunctionId unique (userId,FunctionId));"]; //Title text, Msg text
        if (result) {
            NSLog(@"Message表打开成功");
        }else{
            NSLog(@"Message表打开失败");
        }
        
        
    }else{
        NSLog(@"数据库打开失败");
    }
}

/** 批量增加 */
- (void)insertMsgArray:(NSArray *)msgArray {
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        for (Message *msg in msgArray) {
            [self insertMsg:msg];
        }
    }];
}


/** 增 */
- (void)insertMsg:(Message *)msg {
    
    self.dataBase.logsErrors = NO; //关闭日志输出
    
//    NSString *msgJsonString = [msg jsonStringRepresentation];
    
    NSArray *msgArray = [NSArray arrayWithObject:msg];
    NSString *msgJsonString = [Message jsonStringWithObjectArray:msgArray];
    
//    NSArray *array = [NSArray arrayWithObject:msgJsonString];
//    NSString *json = [array ]
    
    
//    + (NSString *)jsonStringWithObjectArray:(NSArray *)objectArray;
    
    
    
    
    
    
    //归档
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:msg forKey:@"msg"]; // Message 的encodeWithCoder方法被调用
//    [archiver finishEncoding];
    
    BOOL result = [self.dataBase executeUpdate:@"insert into Message(userId,FunctionId,MessageBody) values (?,?,?);", msg.userId, msg.FunctionId, msgJsonString];
    if (result) {
        NSLog(@"增加一条数据成功");
    }else{
        [self updateMessage:msg];
    }
}

/** 删 */
- (void)deleteMsg:(Message *)msg {
    self.dataBase.logsErrors = YES;
    
    //从数据库中查找该会话
    NSMutableArray *conversationArray = [self selectMsgArrayWithUserId:msg.userId functionId:msg.FunctionId];
    [conversationArray removeObject:msg];
    NSString *converssationJsonString = [Message jsonStringWithObjectArray:conversationArray];
    
//    NSData *conversatonData = [NSKeyedArchiver archivedDataWithRootObject:conversationArray];
    
    BOOL result = [self.dataBase executeUpdate:@"update Message set MessageBody=? where userId=? and FunctionId=?", converssationJsonString, msg.userId, msg.FunctionId];
    if (result) {
        NSLog(@"删除一条数据成功");
    }else{
        NSLog(@"删除一条数据失败");
    }
    
    
//    BOOL result = [self.dataBase executeUpdate:@"delete from Message where userId=?", msg.userId];
//    if (result) {
//        NSLog(@"删除一条数据成功");
//    }else{
//        NSLog(@"删除一条数据失败");
//    }
}

/** 根据userId清空消息 */
- (void)deleteMsgByUserId:(NSNumber *)userId {
    
    self.dataBase.logsErrors = YES;
    BOOL result = [self.dataBase executeUpdate:@"delete from Message where userId=?", userId];
    if (result) {
        NSLog(@"删除一条数据成功");
    }else{
        NSLog(@"删除一条数据失败");
    }
}

/** 改 */
- (void)updateMessage:(Message *)msg {
    self.dataBase.logsErrors = YES;
    
    //归档
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:msg forKey:@"msg"]; // Message 的encodeWithCoder方法被调用
//    [archiver finishEncoding];
//    //插入新数据
//    [conversatonData appendData:data];

    
    //从数据库中查找该会话
    NSMutableArray *conversationArray = [self selectMsgArrayWithUserId:msg.userId functionId:msg.FunctionId];
    [conversationArray addObject:msg];
    NSString *conversation = [Message jsonStringWithObjectArray:conversationArray];
    
    
    BOOL result = [self.dataBase executeUpdate:@"update Message set MessageBody=? where userId=? and FunctionId=?", conversation, msg.userId, msg.FunctionId];
    if (result) {
        NSLog(@"更新一条数据成功");
    }else{
        NSLog(@"更新一条数据失败");
    }
}

/** 查 */
/** 返回数组中是Message对象 */
//- (NSArray *)selectMsgWithUserId:(NSNumber *)userId functionId:(NSNumber *)functionId {
//    self.dataBase.logsErrors = YES;
//    
//    NSMutableArray *msgArray = [NSMutableArray array];
//    FMResultSet *set = [self.dataBase executeQuery:@"select MessageBody from Message where userId=? and FunctionId=?;", userId, functionId];
//
//    
//    
////    //临时文件路径
////    NSString *dataPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MessageBody.da"];
////    //文件管理对象
////    NSFileManager * fileManager = [[NSFileManager alloc]init];
//    
//    
//    while (set.next) {
//        
//        NSString *messageBody = [set objectForColumnName:@"MessageBody"];
//        
//        
//        NSArray *array = [Message objectArrayWithJsonString:messageBody];
//        
//        [msgArray addObjectsFromArray:array];
//        
//        // 把messageBody 写到文件路径中
//        // 路径
////        NSString *dataPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MessageBody.da"];
////        [messageBody writeToFile:dataPath atomically:YES];
//        
//        
//        //反归档
//        //读取文件data
////        NSData *data = [NSData dataWithContentsOfFile:dataPath];
////        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
////        Message *msg = [unarchiver decodeObjectForKey:@"msg"]; // Message 的 initWithCoder方法被调用
////        [unarchiver finishDecoding];
////        
////        [msgArray addObject:msg];
////        
////        [fileManager removeItemAtPath:dataPath error:nil];
//    }
//    
//    return msgArray;;
//    
//}

/** 返回数组中是Message数组 */
- (NSMutableArray *)selectMsgArrayWithUserId:(NSNumber *)userId functionId:(NSNumber *)functionId {
    self.dataBase.logsErrors = YES;
    
    
    NSMutableArray *msgArray = [NSMutableArray array];
    FMResultSet *set = [self.dataBase executeQuery:@"select MessageBody from Message where userId=? and FunctionId=?;", userId, functionId];
    while (set.next) {
        
        NSString *messageBody = [set objectForColumnName:@"MessageBody"];
        NSArray* array = [Message objectArrayWithJsonString:messageBody];
        [msgArray addObjectsFromArray:array];
    }
    return msgArray; // msgArray中包含的是message对象
}


/** 删除数据库表 */
- (void)dropTable {
    BOOL result = [self.dataBase executeUpdate:@"drop table Message"];
    if (result) {
        NSLog(@"删除数据库表成功");
    }else{
        NSLog(@"删除数据库表失败");
    }
    //删除数据库表后, 由于dbManager是单例, 所以不会再执行创表操作, 所以后续无法插入表, 除非重新运行程序
}

/** 清空数据库表 */
- (void)clearTable {
    BOOL result = [self.dataBase executeUpdate:@"delete from Message"];
    if (result) {
        NSLog(@"清空表成功");
    }else{
        NSLog(@"清空表失败");
    }
}










@end
