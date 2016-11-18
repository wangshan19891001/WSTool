//
//  DataBase.h
//  LCTools
//
//  Created by 王陕 on 16/10/31.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface DataBase : NSObject

/** 数据库单例 */
+ (instancetype)sharedManager;
/** 批量增加 */
- (void)insertMsgArray:(NSArray *)msgArray;
/** 增 */
- (void)insertMsg:(Message *)msg;
/** 删 */
- (void)deleteMsg:(Message *)msg;
/** 改 */
- (void)updateMessage:(Message *)msg;

/** 查 */
/** 返回数组中是Message对象 */
- (NSMutableArray *)selectMsgWithUserId:(NSNumber *)userId functionId:(NSNumber *)functionId;
/** 返回数组中是Message归档后的Data对象 */
- (NSMutableData *)selectMsgDataWithUserId:(NSNumber *)userId functionId:(NSNumber *)functionId;

/** 删除数据库表 */
- (void)dropTable;
/** 清空数据库表 */
- (void)clearTable;


@end
