//
//  MSKDBManager.h
//  MSK_Include
//
//  Created by CDNetworks on 12. 3. 28..
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface MSKDBManager : NSObject
+ (id)sharedManager;
+(void)setDbName:(NSString *)name;
+ (sqlite3 *) openDB;
+ (void) closeDB;
-(void)onOpenDatabase:(sqlite3 *)db;

-(BOOL) deleteTableAllDataWithTableName:(NSString *)tableName;
-(BOOL) deleteTableDataWithTableName:(NSString *)tableName uid:(int)uid;
-(BOOL) deleteTableDataWithTableName:(NSString *)tableName where:(NSString *)where;
@end
