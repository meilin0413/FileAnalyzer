//
//  TableController.h
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleAnalyzer.h"
#import "FMDatabase.h"

@interface TableController : NSObject
@property NSString *sqlitePath;
@property FMDatabase *db;
@property NSString *dateNow;

+ (NSString *)dateForNow;
- (id)initTableWith:(NSString *)path;
- (void)close;
- (void)open;
- (void)creatFileTable;
- (void)dropFileTable;
- (void)creatLibAndProjsTable;
- (void)dropLibAndProjsTable;
- (void)updateLibAndProjsTable:(NSMutableArray *)libs;
- (void)outputLibAndProjsTableInto:(NSString *)path;
- (NSArray *)libAndProjsTable;
- (NSString *)changeDataToJsonData:(id)obj;

- (void)updateFileTable:(NSMutableArray *)arrForFiles and:(NSMutableArray *)arrForGroups;

- (void)findGroupPathFromMainPath:(NSString *)mainPath andMainGroupId:(NSString *)mainGroupId;

- (NSMutableArray *)findFilePathFromMainPath:(NSString *)mainPath andBuildPath:(NSString *)buildPath;
- (void)creatAllTable;
- (void)updateAllTable:(SampleAnalyzer *)sample;
- (void)dropAllTable;
- (void)creatFilePathTable;
- (void)creatProjTable;
- (void)creatRelationshipTable;
- (void)creatPlistTable;
- (void)creatLibraryTable;
- (void)dropFilePathTable;
- (void)dropProjTable;
- (void)dropRelationshipTable;
- (void)dropPlistTable;
- (void)dropLibraryTable;
- (void)dropCommitTable;
- (void)creatCommitTable;
- (void)creatResultTable;
- (void)dropResultTable;
- (void)updateResultTableByUseCommitTable;

- (BOOL)isCommitTableEmpty;
- (void)updateCommitTable:(NSString *)author andCommitFiles:(NSMutableArray *) commitFiles;
- (NSString *)rootPath;
- (void)outputResultTableIntoText:(NSString *)textPath;
@end
