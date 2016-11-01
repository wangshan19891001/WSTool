//
//  DataBase.h
//  LCTools
//
//  Created by 王陕 on 16/10/31.
//  Copyright © 2016年 王陕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface DataBase : NSObject

/** 数据库单例 */
+ (instancetype)sharedManager;
/** 批量增加 */
- (void)insertPersonArray:(NSArray *)personArray;
/** 增 */
- (void)insertPerson:(Person *)person;
/** 删 */
- (void)deletePerson:(Person *)person;
/** 改 */
- (void)updatePerson:(Person *)person;
/** 删除数据库表 */
- (void)dropTable;
/** 清空数据库表 */
- (void)clearTable;


@end
