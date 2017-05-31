//
//  main.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleAnalyzer.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FileList.h"
#import "ReportProjChange.h"
#import "CommitFile.h"
#import "TableController.h"
#import "CommitFile.h"
#import "NSString+pathAnlyze.h"
#import "ProjectsAndLibs.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        ProjectsAndLibs *a = [[ProjectsAndLibs alloc] initWithDependenciesPath:@"/Volumes/Data/webex-mac-client/dependencies"];
        [a updateTableLibsAndProjsWithSqlitePath:@"/Volumes/Data/webex-mac-client/output/objs/analyze/analyzer.sqlite"];
        
//        NSString *str = @"1234.56";
//        NSString *str1 = @"2344.780";
//        NSString *str2 = @"123.56";
//        //double a = [str doubleValue];
//        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//        formatter.usesSignificantDigits = YES;
//        NSNumber *re1 = [formatter numberFromString:str];
//        NSNumber *re2 = [formatter numberFromString:str1];
//        NSNumber *re3 = [formatter numberFromString:str2];
//        NSNumber *re4 = [formatter numberFromString:str];
//        NSComparisonResult result = [re1 compare:re2];
//        if (result == NSOrderedAscending)
//        {
//            NSLog(@"nnnnnn");
//        }
//        NSLog(@"%@",re1);
        
        //TableController *controller = [[TableController alloc] initTableWith:]
        //        SampleAnalyzer* analyzer = [[SampleAnalyzer alloc] initWithFile:@"/Volumes/Data/webex-mac-client/src/classic_client/commonservice/commonservice.xcodeproj/project.pbxproj"];
        //        NSLog(@"file content is %@",[analyzer fileContent]);
        //        NSLog(@"count is %lu",[[analyzer fileContent] count]);
        //        NSLog(@"the file name is %@",[analyzer fileName]);
        //
        //
        //        TableController *control = [[TableController alloc]initTableWith:@"/Volumes/Data/webex-mac-client/build/mac/analyzers/version/fileAnalyzer.sqlite"];
        
        //        CommitFile *cm = [[CommitFile alloc] initWithPath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/datasourece/commitFile.txt" andSqlitePath:@"/Volumes/Data/webex-mac-client/build/mac/analyzers/version/fileAnalyzer.sqlite"];
        //
        
//////////////////////////////////////////////////////////////////////////////////////////////
//        NSDate *date = [NSDate date];
//        NSFileManager *filemgr = [[NSFileManager alloc] init];
//        NSString *currentPath = [filemgr currentDirectoryPath];
//        NSLog(@"curretPath is %@",currentPath);
//         
//        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
//        NSString *commitFilePath = arguments.lastObject;
//        NSLog(@"input is :%@",commitFilePath);
//        NSFileManager *fm = [NSFileManager defaultManager];
//        if (![fm fileExistsAtPath:commitFilePath] || ![[commitFilePath lastPathComponent] containsString:@"."])
//        {
//            NSLog(@"error : input is wrong");
//        }
//        
//        else
//        {
//            NSMutableString *sqlitePath = [currentPath deletePathComponentBeforeMeet:@"build"];
//            [sqlitePath appendString:@"/output/objs/analyze"];
//            [fm createDirectoryAtPath:sqlitePath withIntermediateDirectories:YES attributes:nil error:nil];
//            [sqlitePath appendString:@"/analyzer.sqlite"];
//            
//            //NSLog(@"sqlitePath %@",sqlitePath);
//            if ([fm fileExistsAtPath:sqlitePath])
//            {
//                TableController *control = [[TableController alloc] initTableWith:sqlitePath];
//                [control dropAllTable];
//                [control creatAllTable];
//            }
//            else
//            {
//                TableController *control = [[TableController alloc] initTableWith:sqlitePath];
//                [control creatAllTable];
//            }
//            
//            TableController *control = [[TableController alloc] initTableWith:sqlitePath];
//            
//            CommitFile *commitFile = [[CommitFile alloc] initWithPath:commitFilePath andSqlitePath:sqlitePath];
//            [commitFile addCommitInfoIntoCommitTable];
//            
//            if ([control isCommitTableEmpty])
//            {
//                NSLog(@"the commit file is empty!");
//            }
//            else
//            {
//                NSMutableString *repoPath = [currentPath deletePathComponentBeforeMeet:@"build"];
//                [repoPath appendString:@"/src"];
//                NSLog(@"repo path %@",repoPath);
//                
//                FileList *file = [[FileList alloc] initWithPath:repoPath andsqlitePath:sqlitePath];
//                [file addFileToFileTable];
//            
//                NSLog(@"Begin analyze ...");
//                ReportProjChange *change = [[ReportProjChange alloc] initWithSqlitePath:sqlitePath];
//                
//                [change AuthorChangeForProjs];
//                
//                NSLog(@"End analyze.");
//                
//                NSMutableString *resultSavedPath = [currentPath deletePathComponentBeforeMeet:@"build"];
//                [resultSavedPath appendString:@"/output/analyze"];
//                
//                [fm createDirectoryAtPath:resultSavedPath withIntermediateDirectories:YES attributes:nil error:nil];
//                [resultSavedPath appendString:@"/analyze_package_version.json"];
//                [control outputResultTableIntoText:resultSavedPath];
//            }
//        }
//        double time = [[NSDate date] timeIntervalSinceDate:date];
//        NSLog(@"run time is：%f",time);
        
        
/////////////////////////////////////////////////////////////////////////////////////////////
//        NSString *string = @"agea";
//        NSArray *arr = [string componentsSeparatedByString:@"/"];
//        NSLog(@"%@ ",arr);
//        NSMutableString *a = [string deletePathComponentBeforeMeet:@"e"];
//        NSLog(@" a %@",a);
//        //        NSData *data = [[NSData alloc]initWithContentsOfFile:@"/Volumes/Data/webex-mac-client/src/classic_client/as/as.xcodeproj/project.pbxproj"];
        //        NSString *a = @"/* Begin PBXGroup section */";
        //        NSData *pbx = [a dataUsingEncoding:NSUTF8StringEncoding];
        //
        //        NSRange r = [data rangeOfData:pbx afterIndex:0];
        //        NSLog(@"%lu  %lu",r.location,r.length);
        //
//        
//        TableController *control = [[TableController alloc] initTableWith:@"/Volumes/Data/myproject/FileAnlyze/fileAnalyzer.sqlite"];
//        [control dropAllTable];
//        
//        [control creatAllTable];
//        
//        FileList *file = [[FileList alloc] initWithPath:@"/Volumes/Data/webex-mac-client/src" andsqlitePath:@"/Volumes/Data/myproject/FileAnlyze/fileAnalyzer.sqlite"];
//        [file addFileToFileTable];
//
//        CommitFile *commitFile = [[CommitFile alloc] initWithPath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/datasourece/commitFile.txt" andSqlitePath:@"/Volumes/Data/myproject/FileAnlyze/fileAnalyzer.sqlite"];
////
//        [commitFile addCommitInfoIntoCommitTable];

//        ReportProjChange *change = [[ReportProjChange alloc] initWithSqlitePath:@"/Volumes/Data/myproject/FileAnlyze/fileAnalyzer.sqlite"];
//        
//        [change AuthorChangeForProjs];
//        
//        [control outputResultTableIntoText:@"/Volumes/Data/myproject/FileAnlyze/a.json"];
        
       // [control close];
        
        //
        
        //        TableController *controller = [[TableController alloc] initTableWith:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/fileAnalyzer.sqlite"];
        //        [controller dropCommitTable];
        //        [controller creatCommitTable];
        //        [controller dropResultTable];
        //        [controller creatResultTable];
        //
        //        CommitFile *commitFile = [[CommitFile alloc] initWithPath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/datasourece/commitFile.txt" andSqlitePath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/fileAnalyzer.sqlite"];
        //        [commitFile addCommitInfoIntoCommitTable];
        //        ReportProjChange *change = [[ReportProjChange alloc] initWithSqlitePath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/fileAnalyzer.sqlite"];
        //        [change AuthorChangeForProjs];
        //        [controller outputResultTableIntoText:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/a.json"];
        
        //        [controller dropAllTable];
        //        [controller creatAllTable];
        //        FileList *file = [[FileList alloc] initWithPath:@"/Volumes/Data/webex-mac-client/src" andsqlitePath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/fileAnalyzer.sqlite"];
        //        [file addFileToFileTable];
        
        //
        //        [control dropResultTable];
        //        [control creatResultTable];
        //        ReportProjChange *change = [[ReportProjChange alloc] initWithSqlitePath:@"/Volumes/Data/webex-mac-client/build/mac/analyzers/version/analyzer.sqlite"];
        //        [change AuthorChangeForProjs];
        
        
        
        
        
        ////
        //        NSPipe* pipe =  [NSPipe pipe];
        //        NSFileHandle* file = pipe.fileHandleForReading;
        //        NSTask *task = [[NSTask alloc] init];
        //        [task setStandardInput:[NSPipe pipe]];
        //        [task setLaunchPath:@"/usr/bin/find"];
        //        [task setArguments:[NSArray arrayWithObjects:@"find",@"/Volumes/Data/webex-mac-client/src/classic_client",@"-name",@"*.pbxproj", nil]];
        //        task.standardOutput = pipe;
        //        [task setStandardInput:[NSPipe pipe]];
        //
        //        [task launch];
        //
        //        NSData *data = [file readDataToEndOfFile];
        //        [file closeFile];
        //
        //        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"the output is %@",output);
        //        NSArray *fileList = [output componentsSeparatedByString:@"\n"];
        //    NSLog(@"hello");
        //        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //        NSString *fileName = [doc stringByAppendingString:@"fileTable.sqlite"];
        //        FMDatabase *db = [FMDatabase databaseWithPath:@"/Volumes/Data/myproject/FileAnalyzer/fileTable.sqlite"];
        //        FMDatabase *dbproj = [FMDatabase databaseWithPath:@"/Volumes/Data/myproject/FileAnalyzer/projTable.sqlite"];
        //        FMDatabase *relationship = [FMDatabase databaseWithPath:@"/Volumes/Data/myproject/FileAnalyzer/relationshipTable.sqlite"];
        //        [db open];
        //        [dbproj open];
        //        [relationship open];
        //
        //       NSString *sql = @"create table fileTable (id integer primary key autoincrement,filename text UNIQUE);"
        //            "insert into fileTable (filename) values ('main.mm');";
        
        //        BOOL success = [db executeStatements:sql];
        //        if (success)
        //            NSLog(@"success0");
        //        success = [relationship executeUpdate:@"PRAGMA foreign_keys=ON;"];
        //        if (success)
        //            NSLog(@"success1");
        //        success = [dbproj executeStatements:@"create table projTable (id integer  primary key autoincrement,filename text UNIQUE)"];
        //        if (success)
        //            NSLog(@"success2");
        //        success = [relationship executeStatements:@"create table relationshipTable (id integer  primary key autoincrement,file_id integer,proj_id integer,FOREIGN KEY(file_id) REFERENCES fileTable(id),FOREIGN KEY(proj_id) REFERENCES projTable(id))"];
        //        if (success)
        //            NSLog(@"success3");
        //        BOOL success = [db executeStatements:@"insert into fileTable (filename) values ('main.mm')"];
        //        if (success)
        //            NSLog(@"success4");
        
        //
        //        [db close];
        //        [dbproj close];
        //        [relationship close];
        
        //        FMDatabase *db = [FMDatabase databaseWithPath:@"/Volumes/Data/myproject/FileAnalyzer/fileAnalyzer.sqlite"];
        //        [db open];
        //        NSString *sql = @"create table fileTable (id integer primary key autoincrement,filename text UNIQUE);";
        //        BOOL success = [db executeStatements:sql];
        //        if (success)
        //           NSLog(@"success0");
        //       // open foreign key
        //        success = [db executeUpdate:@"PRAGMA foreign_keys=ON;"];
        //        if (success)
        //            NSLog(@"success1");
        //        //create a table to storage the project list
        //        success = [db executeStatements:@"create table projTable (id integer primary key autoincrement,projname text UNIQUE)"];
        //        if (success)
        //           NSLog(@"success2");
        //
        //        //create a table to storage the relationship betwwen project list and file list
        //        FMDatabase *db = [FMDatabase databaseWithPath:@"/Volumes/Data/myproject/FileAnalyzer/fileAnalyzer.sqlite"];
        //        [db open];
        //        BOOL success = [db executeStatements:@"create table plistTable (id integer  primary key autoincrement,plistPath text,proj_name text,FOREIGN KEY(proj_name) REFERENCES projTable(projName))"];
        //        if (success)
        //            NSLog(@"success3");
        //        [db close];
        
        //        FMDatabase *db = [FMDatabase databaseWithPath:@"/Volumes/Data/myproject/FileAnalyzer/fileAnalyzer.sqlite"];
        //        [db open];
        //        if ([db open])
        //        {
        //             FMResultSet *resultset = [[FMResultSet alloc] init];
        //            NSString *main = @"main.m";
        //            resultset = [db executeQuery:@"select proj_name from relationshipTable where file_name =?",main];
        //            if ([resultset next])
        //            {
        //                NSLog(@"there is a ");
        //            }
        //            else
        //            {
        //                NSLog(@"no a");
        //            }
        //        }
        //        [db close];
        
        //        NSString *commit =@"/Volumes/Data/myproject/testData/FileList.m";
        //       // NSString *proj = @"/Volumes/Data/webex-mac-client/src/classic_client";
        //        NSString *sqlitePath = @" /Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/fileAnalyzer.sqlite";
        //        ReportProjChange *change = [[ReportProjChange alloc] initWithCommitfilePath:commit andsqlitePath:sqlitePath];
        //        [change changedInfo];
        //        NSLog(@"%@",[change projsChangeInfo]);
        
        //        NSData *data = [NSData dataWithContentsOfFile:@"/Volumes/Data/webex-mac-client/src/classic_client/commonservice/commonservice.xcodeproj/project.pbxproj"];
        //        NSString *string  = @"path = ";
        //        NSData *dataTofind  = [string dataUsingEncoding:NSUTF8StringEncoding];
        //        NSMutableArray *arr = [NSMutableArray array];
        //        arr = [data rangeOfData:dataTofind and:YES];
        //        NSData *productReference = [@"productReference" dataUsingEncoding:NSUTF8StringEncoding];
        //        NSString *string2 = [data afterProfuctreference:productReference];
        //        if(string2)
        //        {
        //            NSLog(@"string2,%@",string2);
        //        }
        //        else
        //            NSLog(@"no .a");
        //NSLog(@"arr %@",arr);
        
        //        NSPipe* pipe = [NSPipe pipe];
        //        NSFileHandle* file = pipe.fileHandleForReading;
        //        NSTask *task = [[NSTask alloc] init];
        //        [task setStandardInput:[NSPipe pipe]];
        //        [task setLaunchPath:@"/usr/bin/find"];
        //        [task setArguments:[NSArray arrayWithObjects:@"find",@"/Volumes/Data/webex-mac-client/src",@"-name",@"*.mm", nil]];
        //        task.standardOutput = pipe;
        //        // [task setStandardInput:[NSPipe pipe]];
        //
        //        [task launch];
        //
        //        NSData *data = [file readDataToEndOfFile];
        //        [file closeFile];
        //
        //        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        if (![output isEqualToString:@""])
        //        {
        //            NSArray *arr = [output componentsSeparatedByString:@"\n"];
        //            FMDatabase *db = [FMDatabase databaseWithPath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/fileAnalyzer.sqlite"];
        //            [db open];
        ////            BOOL success = [db executeStatements:@"create table filePathTable(id integer primary key autoincrement,filePath text UNIQUE,fileName text)"];
        ////            if (success)
        ////                NSLog(@"creat is succesed");
        //            if (arr )
        //            {
        //                for (NSString *string in arr)
        //                {
        //                    [db executeUpdate:@"insert into filePathTable(filePath,fileName) values (?,?);",string,[string lastPathComponent]];
        //                }
        //            }
        //            [db close];
        //        }
        //
        //        FMDatabase *db = [FMDatabase databaseWithPath:@"/Volumes/Data/myproject/TestPathFind/TestPathFind/sqlite.sqlite"];
        //        if ([db open])
        //        {
        //
        //            BOOL succese = [db executeStatements:@"create table filePathTable(id integer primary key autoincrement,filePath text UNIQUE,fileName text);" "create table PathTable(id integer primary key autoincrement,filePath text UNIQUE,fileName text)"];
        //            if (succese)
        //            {
        //                NSLog(@"creat is succesed");
        //            }
        //            succese = [db executeStatements:@"drop table filePathTable;""drop table PathTable"];
        //            if (succese)
        //            {
        //                NSLog(@"drop is succesed");
        //            }
        //        }
        //        [db close];
        
       
//        NSFileManager *fm = [NSFileManager defaultManager];
//        NSDictionary *dic = [fm attributesOfItemAtPath:@"/Volumes/Data/webex-mac-client/dependencies/libs/libconfmgr.a" error:nil];
//        NSLog(@"dic %@",dic);
//        NSDate *modificationDate = [dic objectForKey:@"NSFileModificationDate"];
//        NSLog(@"modification date %@",modificationDate);
//        
//        NSTimeZone *zone = [NSTimeZone systemTimeZone];
//        NSInteger inter = [zone secondsFromGMT];
//        inter = -inter;
//        NSDate *nowForGMT = [modificationDate dateByAddingTimeInterval:inter];
//        NSDate *nowForChina = [nowForGMT dateByAddingTimeInterval:8*3600];
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyMM.dd";
//        NSString *dateNow = [formatter stringFromDate:nowForChina];
//        
//        NSLog(@"date now %@",dateNow);
        
//        NSDate *now = [NSDate date];
//        
//        NSTimeZone *zone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
//        //NSTimeZone *zone = [[NSTimeZone alloc]initWithName:@"America/New_York"];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyMM.dd.HH";
//        formatter.timeZone = zone;
//        NSString *dateNow = [formatter stringFromDate:now];
//        NSLog(@"date now %@",dateNow);
       
        
        
        
       // NSDate *d = [formatter dateFromString:[dic objectForKey:@"NSFileModificationDate"]];
        
       // NSLog(@"d %@",d);
//        NSString *strDate = @"Tue Mar 07 16:21:32 +0800 2017";
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"EEE MMM dd HH:mm:ss ZZZ yyyy";
//        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//        NSDate *date = [formatter dateFromString:strDate];
//        NSLog(@"date %@",date);
//        NSTimeZone *zone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyMM.dd";
//        formatter.timeZone = zone;
//        
//        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:@"/Volumes/Data/webex-mac-client/dependencies/libs/lib7zip_64.a"];
//        NSLog(@"dic %@",dic);
//        NSDate *date = [dic objectForKey:@"NSFileModificationDate"];
//        NSLog(@"date %@",date);
//        NSString *dateString = [NSString string];
//        dateString = [formatter stringFromDate:date];
//        NSLog(@"string %@",dateString);
////        self.libModificationDate = [dateString floatValue];
//       NSLog(@"%f",[dateString floatValue]);
    }
    return 0;
}
