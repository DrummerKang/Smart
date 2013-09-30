//
//  AquaDBManager.h
//  AquaPlayer
//
//  Created by CDNetworks on 12. 6. 29..
//

#import <UIKit/UIKit.h>
#import "MSKDBManager.h"

#define DB_NAME @"MEGA.db"

//  Download할 컨텐츠의 목록을 관리
#define TABLE_DOWNLOAD @"DOWNLOAD"
//  Download된 컨텐츠의 목록을 관리
#define TABLE_CONTENT @"CONTENT"
//  Watermark 정보를 관리
#define TABLE_CP @"CP"

#define CREATE_TABLE_CONTENT @"CREATE TABLE IF NOT EXISTS CONTENT (_id integer primary key autoincrement, customerId text not null, cId text not null, userId text not null, customer text not null, category text not null, path text not null, parent text not null, title text not null, position integer, contentPath text not null, saveTime text not null, lecCD text not null, moveQuality text not null, chr_nm text not null, subject text not null, teacher text not null, imgPath text not null, finish text not null, pos text not null, offlinePeriod text not null, lastOfflinePlayDate text not null);"

#define CREATE_TABLE_DOWNLOAD @"CREATE TABLE IF NOT EXISTS DOWNLOAD (_id integer primary key autoincrement, cId text not null, userId text not null, customerId text not null, downloadListUrl text not null, path text not null, downloadContext text not null, filePath text not null, totalSize text, lecCD text not null, moveQuality text not null, chr_nm text not null, subject text not null, teacher text not null, imgPath text not null, finish text not null, pos text not null, offlinePeriod text not null, lastOfflinePlayDate text not null, modified text); "

#define CREATE_TABLE_CP @"create table if not exists CP (_id integer primary key autoincrement, customerId text not null, type text not null, data BLOB, options BLOB);"

#define DROP_TABLE_CONTENT @"DROP TABLE IF EXISTS CONTENT"
#define DROP_TABLE_DOWNLOAD @"DROP TABLE IF EXISTS DOWNLOAD"
#define DROP_TABLE_CP @"DROP TABLE IF EXISTS CP"

@interface AquaDBManager : MSKDBManager

#pragma mark -
#pragma mark DOWNLOAD DML

- (NSArray *) selectDownloadContentWithCustomerId:(NSString *)custId cid:(NSString *)cid;
- (NSDictionary *)getDownloadDictionaryWithCid:(NSString *)cId userId:(NSString *)userId customerId:(NSString *)customerId downloadListUrl:(NSString *)downloadListUrl path:(NSString *)path downloadContext:(NSString *)downloadContext filePath:(NSString *)filePath lecCD:(NSString *)lecCD moveQuality:(NSString *)moveQuality chr_nm:(NSString *)chr_nm subject:(NSString *)subject teacher:(NSString *)teacher imgPath:(NSString *)imgPath finish:(NSString *)finish pos:(NSString *)pos offlinePeriod:(NSString *)offlinePeriod lastOfflinePlayDate:(NSString *)lastOfflinePlayDate;
- (BOOL) insertDownloadContentWithDictionary:(NSDictionary *) params;
- (void *)downloadingAllLecCD:(NSMutableArray *)myList;
- (void *)downloadingAllCID:(NSMutableArray *)myList;
- (BOOL) updateDownloadContentWithId:(int)_id totalSize:(unsigned long long)size;
- (BOOL) deleteDownloadContentWithId:(int)uid;
- (BOOL) deleteDownloadContentWithFilePath:(NSString *)filePath;
- (BOOL) deleteDownloadContentWithCID:(NSString *)cId;
- (BOOL) deleteContent:(NSString *)cId;
- (BOOL) updatePos:(int)pos cId:(NSString *)cId;
- (BOOL) updateFinishDay:(NSString *)finish cId:(NSString *)cId;
- (BOOL) deleteTableAllDataWithTableName;

#pragma mark -
#pragma mark CONTENT DML

- (NSArray *)selectAllContent;
- (NSArray *)selectAllIDContent:(NSString *)userID;
- (NSArray *)selectChr_nm;
- (void *)selectAllLecCD:(NSMutableArray *)myList;
- (BOOL) insertContentWithCustomerId:(NSString *)customerId cId:(NSString *)cId userId:(NSString *)userId path:(NSString *)path parent:(NSString *)parent title:(NSString *)title contentPath:(NSString *)contentPath customer:(NSString *)customer category:(NSString *)category saveTime:(NSString *)saveTime lecCD:(NSString *)lecCD moveQuality:(NSString *)moveQuality chr_nm:(NSString *)chr_nm subject:(NSString *)subject teacher:(NSString *)teacher imgPath:(NSString *)imgPath finish:(NSString *)finish pos:(NSString *)pos offlinePeriod:(NSString *)offlinePeriod lastOfflinePlayDate:(NSString *)lastOfflinePlayDate;
//최종 오프라인 플레이시간
- (BOOL)updateLastOfflinePlayDate:(NSString *)date cId:(NSString *)cId;

#pragma mark -
#pragma mark CP DML

- (NSDictionary *) selectCPWithCustomerId:(NSString *)custId;
- (BOOL) updateOrInsertCPWithCustomerId:(NSString *)custId type:(NSString *)type data:(NSData *)data options:(NSData *)options;

@end
