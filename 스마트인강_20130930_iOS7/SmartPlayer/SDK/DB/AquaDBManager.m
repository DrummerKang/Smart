//
//  AquaDBManager.m
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 29..
//

#import "AquaDBManager.h"

@implementation AquaDBManager

- (void)onOpenDatabase:(sqlite3 *)db{
    NSArray *arr = [NSArray arrayWithObjects:CREATE_TABLE_CONTENT, CREATE_TABLE_DOWNLOAD, CREATE_TABLE_CP, nil];
    
    for (NSString *sql in arr) {
        char *errMsg;
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
            
        }else {
            
        }
    }
}

+ (sqlite3 *)openDB{
    [self setDbName:DB_NAME];
    return [super openDB];
}

#pragma mark -
#pragma mark DOWNLOAD CRUD

- (NSArray *) selectDownloadContentWithCustomerId:(NSString *)custId cid:(NSString *)cid{
    sqlite3 *DB = [AquaDBManager openDB];
    
	NSMutableArray *list = nil;
    
	sqlite3_stmt *statement;
    
    NSString *where = nil;
    if (custId && cid) {
        where = [NSString stringWithFormat:@" WHERE customerid='%@' AND cid='%@'", custId, cid];
    }
    
    NSMutableString *query = [NSMutableString stringWithFormat:@"SELECT _id, cId, userId, customerId, downloadListUrl, path, downloadContext, filePath, totalSize, lecCD, moveQuality, chr_nm, subject, teacher, imgPath, finish, pos, offlinePeriod, lastOfflinePlayDate FROM %@", TABLE_DOWNLOAD];
    if (where) {
        [query appendString:where];
    }
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        list = [[[NSMutableArray alloc] init] autorelease];
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:sqlite3_column_int(statement, 0)],@"_id",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)],@"cId",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)],@"userId",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)],@"customerId",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)],@"downloadListUrl",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)],@"path",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)],@"downloadContext",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)],@"filePath",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)],@"totalSize",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)],@"lecCD",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)],@"moveQuality",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)],@"chr_nm",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)],@"subject",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)],@"teacher",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)],@"imgPath",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)],@"finish",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)],@"pos",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)],@"offlinePeriod",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)],@"lastOfflinePlayDate",
                                        nil];
            [list addObject:dic];
        }
    }
    
	sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return list;
}

- (NSDictionary *)getDownloadDictionaryWithCid:(NSString *)cId userId:(NSString *)userId customerId:(NSString *)customerId downloadListUrl:(NSString *)downloadListUrl path:(NSString *)path downloadContext:(NSString *)downloadContext filePath:(NSString *)filePath lecCD:(NSString *)lecCD moveQuality:(NSString *)moveQuality chr_nm:(NSString *)chr_nm subject:(NSString *)subject teacher:(NSString *)teacher imgPath:(NSString *)imgPath finish:(NSString *)finish pos:(NSString *)pos offlinePeriod:(NSString *)offlinePeriod lastOfflinePlayDate:(NSString *)lastOfflinePlayDate{
    return [[[NSDictionary alloc] initWithObjectsAndKeys:cId, @"cId",userId,@"userId",customerId,@"customerId",downloadListUrl, @"downloadListUrl", path, @"path", downloadContext, @"downloadContext", filePath, @"filePath", lecCD, @"lecCD", moveQuality, @"moveQuality", chr_nm, @"chr_nm", subject, @"subject", teacher, @"teacher", imgPath, @"imgPath", finish, @"finish", pos, @"pos", offlinePeriod , @"offlinePeriod", lastOfflinePlayDate, @"lastOfflinePlayDate", nil] autorelease];
}

- (BOOL) insertDownloadContentWithDictionary:(NSDictionary *) params{
    BOOL ret = NO;
    if (params == nil)
        return ret;
    
    sqlite3_stmt *statement;
	
	sqlite3 *DB = [AquaDBManager openDB];
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ ( cId, userId, customerId, downloadListUrl, path, downloadContext, filePath, totalSize, lecCD, moveQuality, chr_nm, subject, teacher, imgPath, finish, pos, offlinePeriod, lastOfflinePlayDate) values ( '%@', '%@', '%@', '%@', '%@', '%@', '%@', '0', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", TABLE_DOWNLOAD,
                       [params objectForKey:@"cId"],
                       [params objectForKey:@"userId"],
                       [params objectForKey:@"customerId"],
                       [params objectForKey:@"downloadListUrl"],
                       [params objectForKey:@"path"],
                       [params objectForKey:@"downloadContext"],
                       [params objectForKey:@"filePath"],
                       [params objectForKey:@"lecCD"],
                       [params objectForKey:@"moveQuality"],
                       [params objectForKey:@"chr_nm"],
                       [params objectForKey:@"subject"],
                       [params objectForKey:@"teacher"],
                       [params objectForKey:@"imgPath"],
                       [params objectForKey:@"finish"],
                       [params objectForKey:@"pos"],
                       [params objectForKey:@"offlinePeriod"],
                       [params objectForKey:@"lastOfflinePlayDate"]];
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE)
            ret = YES;
        
        else {
            
        }
        
    }else{
        
    }
    
    sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return  ret;
}

//다운로드 lec_cd
- (void *)downloadingAllLecCD:(NSMutableArray *)myList{
    sqlite3 *DB = [AquaDBManager openDB];
    
	NSMutableArray *list = nil;
    
	sqlite3_stmt *statement;
    
    NSString *query = @"SELECT lecCD, moveQuality FROM DOWNLOAD";
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        list = [[[NSMutableArray alloc] init] autorelease];
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)],@"lecCD",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)],@"moveQuality",
                                        nil];
            [myList addObject:dic];
        }
    }
    
	sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return list;
}

//다운로드 CID
- (void *)downloadingAllCID:(NSMutableArray *)myList{
    sqlite3 *DB = [AquaDBManager openDB];
    
	NSMutableArray *list = nil;
    
	sqlite3_stmt *statement;
    
    NSString *query = @"SELECT cId FROM DOWNLOAD";
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        list = [[[NSMutableArray alloc] init] autorelease];
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)],@"cId",
                                        nil];
            [myList addObject:dic];
        }
    }
    
	sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return list;
}

//업데이트 다운로드 id
- (BOOL) updateDownloadContentWithId:(int)_id totalSize:(unsigned long long)size{
    BOOL ret = NO;
    
    sqlite3_stmt *statement;
	
	sqlite3 *DB = [AquaDBManager openDB];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET totalSize='%@' WHERE _id=%d",TABLE_DOWNLOAD, [NSString stringWithFormat:@"%llu", size], _id];
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE)
            ret = YES;
        
        else {
        }
        
    }else{
        
    }
    
    sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return  ret;
}

-(BOOL) deleteTableAllDataWithTableName{
    return [self deleteTableAllDataWithTableName:TABLE_DOWNLOAD];
}

- (BOOL) deleteDownloadContentWithId:(int)uid{
    return [self deleteTableDataWithTableName:TABLE_DOWNLOAD uid:uid];
}

- (BOOL) deleteDownloadContentWithFilePath:(NSString *)filePath{
    return [self deleteTableDataWithTableName:TABLE_DOWNLOAD where:[NSString stringWithFormat:@"filePath='%@'", filePath]];
}

- (BOOL) deleteDownloadContentWithCID:(NSString *)cId{
    return [self deleteTableDataWithTableName:TABLE_DOWNLOAD where:[NSString stringWithFormat:@"cId= %@", cId]];
}

#pragma mark -
#pragma mark CONTENT CRUD

- (BOOL) insertContentWithCustomerId:(NSString *)customerId cId:(NSString *)cId userId:(NSString *)userId path:(NSString *)path parent:(NSString *)parent title:(NSString *)title contentPath:(NSString *)contentPath customer:(NSString *)customer category:(NSString *)category saveTime:(NSString *)saveTime lecCD:(NSString *)lecCD moveQuality:(NSString *)moveQuality chr_nm:(NSString *)chr_nm subject:(NSString *)subject teacher:(NSString *)teacher imgPath:(NSString *)imgPath finish:(NSString *)finish pos:(NSString *)pos offlinePeriod:(NSString *)offlinePeriod lastOfflinePlayDate:(NSString *)lastOfflinePlayDate{
    BOOL ret = NO;
    
    sqlite3_stmt *statement;
	
	sqlite3 *DB = [AquaDBManager openDB];
    
    if (contentPath == nil || contentPath.length < 1) {
        NSString *preCheck = [NSString stringWithFormat:@"SELECT _id FROM %@ WHERE customerId='%@' AND path='%@';", TABLE_CONTENT, customerId, path];
        if (sqlite3_prepare_v2(DB, [preCheck UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW){
                int count = sqlite3_data_count(statement);
                if (count > 0) {
                    int _id = sqlite3_column_int(statement, 0);
                    NSLog(@"id : %d", _id);
                    sqlite3_finalize(statement);
                    [AquaDBManager closeDB];
                    return NO;
                }
                
            }else {
                
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ ( customerId, cId, userId, customer, category, path, parent, title, contentPath, saveTime, lecCD, moveQuality, chr_nm, subject, teacher, imgPath, finish, pos, offlinePeriod, lastOfflinePlayDate) values ( '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", TABLE_CONTENT, customerId, cId, userId, customer, category, path, parent, title, contentPath, saveTime, lecCD, moveQuality, chr_nm, subject, teacher, imgPath, finish, pos, offlinePeriod, lastOfflinePlayDate];
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE)
            ret = YES;
        
        else {
            
        }
        
    }else{
        
    }
    
    sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return  ret;
}

//모든 컨텐츠 정보 얻기
- (NSArray *) selectAllContent{
    sqlite3 *DB = [AquaDBManager openDB];
    
	NSMutableArray *list = nil;
    
	sqlite3_stmt *statement;
    
    NSString *query = @"SELECT _id, customerId, cId, userId, customer, category, path, parent, title, position, contentPath, saveTime, lecCD, moveQuality, chr_nm, subject, teacher, imgPath, finish, pos, offlinePeriod, lastOfflinePlayDate FROM CONTENT where contentPath != ''";
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        list = [[[NSMutableArray alloc] init] autorelease];
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:sqlite3_column_int(statement, 0)],@"_id",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)],@"customerId",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)],@"cId",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)],@"userId",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)],@"customer",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)],@"category",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)],@"path",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)],@"parent",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)],@"title",
                                        [NSNumber numberWithInt:sqlite3_column_int(statement, 9)],@"position",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)],@"contentPath",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)],@"saveTime",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)],@"lecCD",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)],@"moveQuality",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)],@"chr_nm",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)],@"subject",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)],@"teacher",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)],@"imgPath",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)],@"finish",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)],@"pos",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)],@"offlinePeriod",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)],@"lastOfflinePlayDate",
                                        nil];
            [list addObject:dic];
        }
    }
    
	sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return list;
}

//ID로 모든 컨텐츠 정보 얻기
- (NSArray *) selectAllIDContent:(NSString *)userID{
    sqlite3 *DB = [AquaDBManager openDB];
    
	NSMutableArray *list = nil;
    
	sqlite3_stmt *statement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT _id, customerId, cId, userId, customer, category, path, parent, title, position, contentPath, saveTime, lecCD, moveQuality, chr_nm, subject, teacher, imgPath, finish, pos, offlinePeriod, lastOfflinePlayDate FROM CONTENT WHERE userId = '%@'", userID];
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        list = [[[NSMutableArray alloc] init] autorelease];
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:sqlite3_column_int(statement, 0)],@"_id",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)],@"customerId",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)],@"cId",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)],@"userId",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)],@"customer",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)],@"category",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)],@"path",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)],@"parent",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)],@"title",
                                        [NSNumber numberWithInt:sqlite3_column_int(statement, 9)],@"position",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)],@"contentPath",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)],@"saveTime",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)],@"lecCD",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)],@"moveQuality",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)],@"chr_nm",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)],@"subject",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)],@"teacher",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)],@"imgPath",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)],@"finish",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)],@"pos",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)],@"offlinePeriod",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)],@"lastOfflinePlayDate",
                                        nil];
            [list addObject:dic];
        }
    }
    
	sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return list;
}

//lec_cd 코드 얻기
- (void *)selectAllLecCD:(NSMutableArray *)myList{
    sqlite3 *DB = [AquaDBManager openDB];
    
	NSMutableArray *list = nil;
    
	sqlite3_stmt *statement;
    
    NSString *query = @"SELECT lecCD, moveQuality FROM CONTENT";
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        list = [[[NSMutableArray alloc] init] autorelease];
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)],@"lecCD",
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)],@"moveQuality",
                                        nil];
            [myList addObject:dic];
        }
    }
    
	sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return list;
}

#pragma mark -
#pragma mark CP CRUD

- (NSDictionary *) selectCPWithCustomerId:(NSString *)custId{
    sqlite3 *DB = [AquaDBManager openDB];
    
	sqlite3_stmt *statement;
    
    NSMutableString *query = [NSMutableString stringWithFormat:@"SELECT _id, customerId, type, data, options FROM %@ where customerId='%@'", TABLE_CP, custId];
    NSMutableDictionary *dic = nil;
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSUInteger blobLength1 = sqlite3_column_bytes(statement, 3);
            NSUInteger blobLength2 = sqlite3_column_bytes(statement, 4);
            dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithInt:sqlite3_column_int(statement, 0)],@"_id",
                   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)],@"customerId",
                   [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)],@"type",
                   [NSData dataWithBytes:sqlite3_column_blob(statement, 3) length:blobLength1],@"data",
                   [NSData dataWithBytes:sqlite3_column_blob(statement, 4) length:blobLength2],@"options",
                   nil];
        }
    }
    
	sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return dic;
}

#pragma mark -
#pragma UPDATE Method

- (BOOL) updateOrInsertCPWithCustomerId:(NSString *)custId type:(NSString *)type data:(NSData *)data options:(NSData *)options{
    sqlite3 *DB = [AquaDBManager openDB];
    
	BOOL ret = NO;
    
	sqlite3_stmt *statement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ where customerId='%@'", TABLE_CP, custId];
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            query = [NSString stringWithFormat:@"UPDATE %@ SET type='%@', data=?, options=? where customerId='%@'", TABLE_CP, type, custId];
            
            if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_blob(statement, 1, [data bytes], data.length, SQLITE_STATIC);
                
                if (options) {
                    sqlite3_bind_blob(statement, 2, [options bytes], options.length, SQLITE_STATIC);
                    
                }else {
                    sqlite3_bind_blob(statement, 2, NULL, 0, SQLITE_STATIC);
                }
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                    ret = YES;
            }
            
        }else {
            query = [NSString stringWithFormat:@"INSERT INTO %@ ( customerId, type, data, options ) values ( '%@', '%@', ?, ?);", TABLE_CP,
                     custId, type];
            
            if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_blob(statement, 1, [data bytes], data.length, SQLITE_STATIC);
                
                if (options) {
                    sqlite3_bind_blob(statement, 2, [options bytes], options.length, SQLITE_STATIC);
                    
                }else {
                    sqlite3_bind_blob(statement, 2, NULL, 0, SQLITE_STATIC);
                }
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                    ret = YES;
            }
        }
    }
    
	sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return ret;
}

//chr_nm코드 얻기
- (NSArray *)selectChr_nm{
    sqlite3 *DB = [AquaDBManager openDB];
    
	NSMutableArray *list = nil;
    
	sqlite3_stmt *statement;
    
    NSString *query = @"SELECT chr_nm FROM CONTENT GROUP BY chr_nm";
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        list = [[[NSMutableArray alloc] init] autorelease];
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)],@"chr_nm",
                                        nil];
            [list addObject:dic];
        }
    }
    
	sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return list;
}

//CID 
- (BOOL) updatePos:(int)pos cId:(NSString *)cId{
    BOOL ret = NO;
    
    sqlite3_stmt *statement;
	
	sqlite3 *DB = [AquaDBManager openDB];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET pos='%@' WHERE cId = '%@'",TABLE_CONTENT, [NSString stringWithFormat:@"%d", pos], cId];
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE)
            ret = YES;
        
        else {
        }
        
    }else{
        
    }
    
    sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return  ret;
}

//최종수강일 
- (BOOL)updateFinishDay:(NSString *)finish cId:(NSString *)cId{
    BOOL ret = NO;
    
    sqlite3_stmt *statement;
	
	sqlite3 *DB = [AquaDBManager openDB];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET finish='%@' WHERE cId = '%@'",TABLE_CONTENT, finish, cId];
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE)
            ret = YES;
        
        else {
        }
        
    }else{
        
    }
    
    sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return  ret;
}

//최종 오프라인 플레이시간
- (BOOL)updateLastOfflinePlayDate:(NSString *)date cId:(NSString *)cId{
    BOOL ret = NO;
    
    sqlite3_stmt *statement;
	
	sqlite3 *DB = [AquaDBManager openDB];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET lastOfflinePlayDate='%@' WHERE cId = '%@'",TABLE_CONTENT, date, cId];
    
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE)
            ret = YES;
        
        else {
        }
        
    }else{
        
    }
    
    sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return  ret;
}

//삭제
- (BOOL)deleteContent:(NSString *)cId{
    BOOL ret = NO;
    
    sqlite3_stmt *statement;
	
	sqlite3 *DB = [AquaDBManager openDB];
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE cId = %@",TABLE_CONTENT, cId];
    //NSLog(@"%@", query);
    if (sqlite3_prepare_v2(DB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE)
            ret = YES;
        
        else {
        }
        
    }else{
        
    }
    
    sqlite3_finalize(statement);
    
    [AquaDBManager closeDB];
    
    return  ret;
}

@end
