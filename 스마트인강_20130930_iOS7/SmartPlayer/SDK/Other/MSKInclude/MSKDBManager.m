//
//  MSKDBManager.m
//  MSK_Include
//
//  Created by CDNetworks on 12. 3. 28..
//

#import "MSKDBManager.h"

static id sharedManager;
static NSString *dbName;
static sqlite3 *db;

@implementation MSKDBManager

+ (id)sharedManager {
	@synchronized(self) {
		if (sharedManager == nil) {
			sharedManager = [[self alloc] init];
		}
	}
	return sharedManager;
}

+(void)setDbName:(NSString *)name
{
    dbName = name;
}

+ (sqlite3 *) openDB
{
    if (db == nil) {        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:dbName];
        if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            //		//NSLog(@"Open DB fail(%s) at %s:%d", sqlite3_errmsg(DB), __FUNCTION__, __LINE__);
            return nil;
        }
    }
    
    [[self sharedManager] onOpenDatabase:db];
    
	return db;
}

+ (void) closeDB
{
//    sqlite3_close(db);
}

-(void)onOpenDatabase:(sqlite3 *)db
{
    
}

#pragma mark -
#pragma mark common function

-(BOOL) deleteTableAllDataWithTableName:(NSString *)tableName
{
    return [self deleteTableDataWithTableName:tableName where:nil];
}

-(BOOL) deleteTableDataWithTableName:(NSString *)tableName uid:(int)uid
{
    return [self deleteTableDataWithTableName:tableName where:[NSString stringWithFormat:@"_id = %d", uid]];
}

-(BOOL) deleteTableDataWithTableName:(NSString *)tableName where:(NSString *)where
{
    sqlite3_stmt *statement;
    
    int ret = 0;
    sqlite3 *DB = [MSKDBManager openDB];
    
    
    NSString *deleteQuery = nil;
    if (where) {
        deleteQuery = [NSString stringWithFormat:@"delete from %@ where %@", tableName, where];
    }
    else {
        deleteQuery = [NSString stringWithFormat:@"delete from %@", tableName];
    }
    
    if (sqlite3_prepare_v2(DB, [deleteQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) { 
        if (sqlite3_step(statement) == SQLITE_DONE) {
            ret = 3;
        } else {
            //            //NSLog(@"1. %s, error:\"%s\"", __FUNCTION__, sqlite3_errmsg(DB));
        }
    }
    else // 쿼리문 실행이 실패했다면
    {
        //        //NSLog(@"2. %s, error:\"%s\"", __FUNCTION__, sqlite3_errmsg(DB));
    }
    
    sqlite3_finalize(statement);
    
    [MSKDBManager closeDB]; 
    
    return ret;
}

@end
