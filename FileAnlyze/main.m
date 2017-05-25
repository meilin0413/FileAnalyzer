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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
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
        
        /////////////////////////////////////////////////////////////////////////////////////
        NSDate *date = [NSDate date];
        NSFileManager *filemgr = [[NSFileManager alloc] init];
        NSString *currentPath = [filemgr currentDirectoryPath];
        NSLog(@"curretPath is %@",currentPath);
         
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        NSString *commitFilePath = arguments.lastObject;
        NSLog(@"input is :%@",commitFilePath);
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:commitFilePath] || ![[commitFilePath lastPathComponent] containsString:@"."])
        {
            NSLog(@"error : input is wrong");
        }
        
        else
        {
            NSMutableString *sqlitePath = [[NSMutableString alloc] initWithString:currentPath];
            [sqlitePath appendString:@"/analyzer.sqlite"];
            //NSLog(@"sqlitePath %@",sqlitePath);
            
            TableController *control = [[TableController alloc] initTableWith:sqlitePath];
           // [control dropAllTable];
            [control creatAllTable];
            
            CommitFile *commitFile = [[CommitFile alloc] initWithPath:commitFilePath andSqlitePath:sqlitePath];
            [commitFile addCommitInfoIntoCommitTable];
            
            if ([control isCommitTableEmpty])
            {
                NSLog(@"the commit file is empty!");
            }
            else
            {
                NSMutableString *repoPath = [currentPath deletePathComponentBeforeMeet:@"build"];
                [repoPath appendString:@"/src"];
                NSLog(@"repo path %@",repoPath);
                
                FileList *file = [[FileList alloc] initWithPath:repoPath andsqlitePath:sqlitePath];
                [file addFileToFileTable];
            
                NSLog(@"Begin analyze ...");
                ReportProjChange *change = [[ReportProjChange alloc] initWithSqlitePath:sqlitePath];
                [change AuthorChangeForProjs];
                NSLog(@"End analyze.");
                
                NSMutableString *resultSavedPath = [currentPath deletePathComponentBeforeMeet:@"build"];
                [resultSavedPath appendString:@"/output/analyze"];
                
                [fm createDirectoryAtPath:resultSavedPath withIntermediateDirectories:YES attributes:nil error:nil];
                [resultSavedPath appendString:@"/analyze_package_version.json"];
                [control outputResultTableIntoText:resultSavedPath];
                
                // NSFileManager *fm = [NSFileManager defaultManager];

            }
            if ([fm fileExistsAtPath:sqlitePath])
            {
                [fm removeItemAtPath:sqlitePath error:NULL];
            }

        }
        
        double time = [[NSDate date] timeIntervalSinceDate:date];
        NSLog(@"run time is：%f",time);
        
        
        /////////////////////////////////////////////////////////////////////////////////////////
        
        //        NSData *data = [[NSData alloc]initWithContentsOfFile:@"/Volumes/Data/webex-mac-client/src/classic_client/as/as.xcodeproj/project.pbxproj"];
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
//        
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
        
        
        //
        //        CommitFile *commit = [[CommitFile alloc] initWithPath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/datasourece/commitFile.txt"];
        //        NSLog(@"author is %@",[commit author]);
        //
        
        //        TableController *controller = [[TableController alloc] initTableWith:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/fileAnalyzer.sqlite"];
        //       [controller dropCommitTable];
        //       [controller creatCommitTable];
        ////
        //        CommitFile *cm = [[CommitFile alloc] initWithPath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/datasourece/commitFile.txt" andSqlitePath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/fileAnalyzer.sqlite"];
        //        //[controller creatResultTable];
        //        
        //        ReportProjChange *change = [[ReportProjChange alloc] initWithSqlitePath:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/fileAnalyzer.sqlite"];
        //        [change AuthorChangeForProjs];
        
        
        
        //        NSData *data = [[NSData alloc] initWithContentsOfFile:@"/Volumes/Data/myproject/PROJCommitFile/FileAnalyzer/datasourece/commitFile2.txt"];
        //        const void* bytes = [data bytes];
        //        if (((char*)bytes)[1] == (char)9)
        //        {
        //            NSLog(@"YES");
        //        }
        //            
        //            
        //        NSLog(@"char is %i",(int)((char*)bytes)[1]);
        //        
        //        NSLog(@"data :%@",data);
        //   
    }
    return 0;
}
