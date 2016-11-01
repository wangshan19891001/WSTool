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
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"sql.sqlite"]; //此处需要传入存在的确定的路径
    self.dataBase = [FMDatabase databaseWithPath:fileName];
    self.dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    NSLog(@"数据库路径: %@", fileName);
    
    if ([self.dataBase open]) {
        NSLog(@"数据库打开成功");
        
        //创建数据库表
        BOOL result = [self.dataBase executeUpdate:@"create table if not exists Person(ID integer primary key, userID integer, name text, image blob);"];
        if (result) {
            NSLog(@"Person表打开成功");
        }else{
            NSLog(@"Person表打开失败");
        }
        
        
    }else{
        NSLog(@"数据库打开失败");
    }
}

/** 批量增加 */
- (void)insertPersonArray:(NSArray *)personArray {
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        for (Person *person in personArray) {
            [self insertPerson:person];
        }
    }];
}


/** 增 */
- (void)insertPerson:(Person *)person {
    
    self.dataBase.logsErrors = NO; //关闭日志输出
    BOOL result = [self.dataBase executeUpdate:@"insert into Person values (?,?,?,?);", person.ID, person.userID, person.name, UIImagePNGRepresentation(person.image)];
    if (result) {
        NSLog(@"增加一条数据成功");
    }else{
//        NSLog(@"增加一条数据失败");
        [self updatePerson:person];
//        [self.dataBase lastError];
    }
}

/** 删 */
- (void)deletePerson:(Person *)person {
    self.dataBase.logsErrors = YES;
    BOOL result = [self.dataBase executeUpdate:@"delete from Person where ID=?", person.ID];
    if (result) {
        NSLog(@"删除一条数据成功");
    }else{
        NSLog(@"删除一条数据失败");
    }
}

/** 改 */
- (void)updatePerson:(Person *)person {
    self.dataBase.logsErrors = YES;
    BOOL result = [self.dataBase executeUpdate:@"update Person set name=? where ID=?", person.name, person.ID];
    if (result) {
        NSLog(@"更新一条数据成功");
    }else{
        NSLog(@"更新一条数据失败");
    }
}

/** 查 */
- (void)selectPerson:(Person *)person {
    self.dataBase.logsErrors = YES;
    
}

/** 删除数据库表 */
- (void)dropTable {
    BOOL result = [self.dataBase executeUpdate:@"drop table Person"];
    if (result) {
        NSLog(@"删除数据库表成功");
    }else{
        NSLog(@"删除数据库表失败");
    }
    //删除数据库表后, 由于dbManager是单例, 所以不会再执行创表操作, 所以后续无法插入表, 除非重新运行程序
}

/** 清空数据库表 */
- (void)clearTable {
    BOOL result = [self.dataBase executeUpdate:@"delete from Person"];
    if (result) {
        NSLog(@"清空表成功");
    }else{
        NSLog(@"清空表失败");
    }
}










@end
