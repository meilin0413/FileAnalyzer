//
//  TableController.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "TableController.h"
#import "NSString+pathAnlyze.h"

@implementation TableController

@synthesize sqlitePath;
@synthesize db;

+ (NSString *)dateForNow
{
    NSDate *now = [NSDate date];
    
    NSTimeZone *zone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyMM.dd";
    formatter.timeZone = zone;
    NSString *dateNow = [formatter stringFromDate:now];
    return dateNow;
    
}

- (id)initTableWith:(NSString *)path
{
    self = [super init];
    if (self)
    {
        sqlitePath = path;
        self.db = [FMDatabase databaseWithPath:sqlitePath];
        
        
    }
    return self;
}
- (void)open {
    [self.db open];
    [self.db beginTransaction];
    
}
- (void)close
{
    [self.db commit];
    [self.db close];
}
- (void)creatAllTable
{
    if ([self.db open])
    {
        // [self creatFilePathTable];
        [self creatProjTable];
        [self creatPlistTable];
        [self creatRelationshipTable];
        [self creatLibraryTable];
        [self creatResultTable];
        [self creatCommitTable];
    }
    [self.db close];
    
    
}
//update all table, the .a table hasn't update
- (void)updateAllTable:(SampleAnalyzer *)sample
{
    //    FMResultSet *result;
//    if ([self.db open])
//    {
      //  [self.db beginTransaction];
        
        [self.db executeUpdate:@"insert into projTable(projName) values(?)",sample.projName];
        
        
        //relationship table
        for (NSString *filepath in sample.projContent)
        {
            [self.db executeUpdate:@"insert into relationshipTable(projName,filePath) values(?,?)",sample.projName,filepath];
            
        }
        //plist table
        for (NSString *key in sample.plistList)
        {
            [self.db executeUpdate:@"insert into plistTable(plistPath,projName,plistDate) values(?,?,?)",key,sample.projName,[sample.plistList objectForKey:key]];
        }
        if (sample.libraryName)
        {
            [self.db executeUpdate:@"insert into libraryTable(libraryName,belongToProj) values(?,?)",sample.libraryName,sample.projName];
        }
  //      [self.db commit];
//    }
//    [self.db close];

}
//drop all table
- (void)dropAllTable
{
    if ([self.db open])
    {
        [self dropPlistTable];
        [self dropLibraryTable];
        [self dropRelationshipTable];
        [self dropCommitTable];
        [self dropResultTable];
        [self dropProjTable];
    }
    [self.db close];
}

- (void)creatFilePathTable
{
    
    BOOL success = [self.db executeStatements:@"create table filePathTable(id integer primary key autoincrement,filePath text UNIQUE,fileName text)"];
    if (success)
        NSLog(@"creat filePathTable is succesed");
}
- (void)creatProjTable
{
    BOOL success = [self.db executeStatements:@"create table projTable(id integer primary key autoincrement,projName text)"];
    if (success)
        NSLog(@"creat projTable is succesed");
}
- (void)creatRelationshipTable{
    
    BOOL success = [self.db executeStatements:@"create table relationshipTable(id integer primary key autoincrement,projName text,filePath text)"];
    if (success)
        NSLog(@"creat relationship table is succesed");
}
- (void)creatPlistTable{
    
    BOOL success = [self.db executeStatements:@"create table plistTable(id integer primary key autoincrement,plistPath text,projName text,plistDate text)"];
    
    if (success)
        NSLog(@"creat plist table is succesed");
    
    
    
}
- (void)creatLibraryTable{
    
    BOOL success = [self.db executeStatements:@"create table libraryTable(id integer primary key autoincrement,libraryName text,belongToProj text)"];
    if (success)
        NSLog(@"creat library table is succesed");
}
- (void)creatCommitTable{
    
    BOOL success = [self.db executeStatements:@"create table commitTable(id integer primary key autoincrement,authorName text,commitFileName text)"];
    if (success)
        NSLog(@"creat commitTable table is succesed");
    
}
- (void)updateCommitTable:(NSString *)author andCommitFiles:(NSMutableArray *)commitFiles
{
    if ([self.db open])
    {
        [self.db beginTransaction];
        FMResultSet *result;
        for (NSString *string in commitFiles)
        {
            NSString *stringa = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            //obtain full path ...
            
             NSString *mutString = [[NSString alloc] initWithString:[self rootPath]];
            //NSString *mutString = @"/Volumes/Data/webex-mac-client/";//for Test
            //NSLog(@"root path %@",[self rootPath]);
            
            mutString = [mutString stringByAppendingString:stringa];
           // NSLog(@"changed file name is %@",mutString);
            //NSLog(@"changed file name is %@",stringa);
            
            result = [self.db executeQuery:@"select id from commitTable where authorName=? and commitFileName=?",author,mutString];
            
            if (![result next])
            {
                [self.db executeUpdate:@"insert into commitTable(authorName,commitFileName) values(?,?)",author,mutString];
            }
            
        }
        [self.db commit];
    }
    [self.db close];
    
}
- (BOOL)isCommitTableEmpty
{
    if ([self.db open])
    {
        FMResultSet *result = [self.db executeQuery:@"select * from commitTable"];
        if ([result next])
        {
            [self.db close];
            return NO;
        }
        
        else
        {
            [self.db close];
            return YES;
        }
        
    }
    [self.db close];
    return YES;
}
- (void)dropFilePathTable{
    
    BOOL succese = [self.db executeStatements:@"drop table filePathTable;"];
    if (succese)
    {
        NSLog(@"drop table is succesed");
    }
}
- (void)dropProjTable{
    
    BOOL succese = [self.db executeStatements:@"drop table projTable;"];
    if (succese)
    {
        NSLog(@"drop table is succesed");
    }
    
}
- (void)dropRelationshipTable{
    
    BOOL succese = [self.db executeStatements:@"drop table relationshipTable;"];
    if (succese)
    {
        NSLog(@"drop table is succesed");
    }
}
- (void)dropPlistTable{
    
    BOOL succese = [self.db executeStatements:@"drop table plistTable;"];
    if (succese)
    {
        NSLog(@"drop table is succesed");
    }
}
- (void)dropLibraryTable{
    
    BOOL succese = [self.db executeStatements:@"drop table libraryTable"];
    if (succese)
    {
        NSLog(@"drop table is succesed");
    }
    
}
- (void)dropCommitTable{
    
    BOOL succese = [self.db executeStatements:@"drop table commitTable"];
    if (succese)
    {
        NSLog(@"drop table is succesed");
    }
    
}

- (void)creatResultTable
{
    BOOL success = [self.db executeStatements:@"create table resultTable(id integer primary key autoincrement,authorName text,fileChanged text,projChanged text,plistNotChanged text)"];
    if (success)
        NSLog(@"creat commitTable table is succesed");
    
}
- (void)dropResultTable
{
    BOOL succese = [self.db executeStatements:@"drop table resultTable"];
    if (succese)
    {
        NSLog(@"drop table is succesed");
    }
    
}
//obtain /Volumes/Data/webex-mac-client/ from sqlitePath
- (NSString *)rootPath
{
    NSArray *pathComponent = [sqlitePath componentsSeparatedByString:@"/"];
    NSMutableString *rootpath = [NSMutableString string];
    NSInteger tmpCount = 0;
    for (NSString *string in pathComponent)
    {
        if ([string isEqualToString:@"src"] || [string isEqualToString:@"build"] || [string isEqualToString:@"output"])
        {
            break;
        }
        else
            tmpCount++;
    }
    
    if ([[pathComponent objectAtIndex:0] isEqualToString:@""])
    {
        for (NSInteger index = 1;index < tmpCount;index++)
        {
            [rootpath appendString:@"/"];
            [rootpath appendString:[pathComponent objectAtIndex:index]];
        }
        [rootpath appendString:@"/"];
    }
    else
    {
        for (NSInteger index = 0;index < tmpCount;index++)
        {
            [rootpath appendString:@"/"];
            [rootpath appendString:[pathComponent objectAtIndex:index]];
        }
        [rootpath appendString:@"/"];
    }
    return rootpath;
}
//return repo name
- (NSString *)repoName
{
    NSArray *arr = [sqlitePath componentsSeparatedByString:@"/"];
    NSUInteger searchIndex = 0;
    for (NSString *string in arr)
    {
        
        if (![string isEqualToString:@"build"])
        {
            searchIndex++;
            
        }
        else
            break;
    }
    return [arr objectAtIndex:searchIndex-1];
    
}

- (void)outputResultTableIntoText:(NSString *)textPath
{
    if ([self.db open])
    {
        
        FMResultSet *resultFor = [self.db executeQuery:@"select * from resultTable"];
        if (![resultFor next])
        {
            NSLog(@"Great, no version is needed to be changed!");
            return;
        }
        else
        {
            NSLog(@"There are some versions needed to be changed! For detail, please see %@",textPath);
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *authorArr = [NSMutableArray array];
        
        FMResultSet *result = [self.db executeQuery:@"select * from resultTable"];
        while ([result next])
        {
            if (![authorArr containsObject:[result stringForColumn:@"authorName"]])
            {
                [authorArr addObject:[result stringForColumn:@"authorName"]];
            }
        }
        
        NSMutableArray *reports = [NSMutableArray array];
        
        for (NSString *author in authorArr)
        {
            NSMutableDictionary *dicAuthor = [NSMutableDictionary dictionary];
            NSMutableArray *version = [NSMutableArray array];
            NSMutableArray *changeList = [NSMutableArray array];
            FMResultSet *result = [self.db executeQuery:@"select * from resultTable where authorName=?",author];
            
            while ([result next])
            {
                 NSString *plistNotChanged = [[result stringForColumn:@"plistNotChanged"] stringByReplacingOccurrencesOfString:[self rootPath] withString:@""];
                if (![version containsObject:plistNotChanged])
                {
                    [version addObject:plistNotChanged];
                }
                
                NSString *fileChanged = [[result stringForColumn:@"fileChanged"] stringByReplacingOccurrencesOfString:[self rootPath] withString:@""];
                if (![changeList containsObject:fileChanged])
                {
                    [changeList addObject:fileChanged];
                }
                
                
                [dicAuthor setObject:version forKey:@"Version"];
                [dicAuthor setObject:changeList forKey:@"ChangList"];
                [dicAuthor setObject:author forKey:@"Author"];
            }
            [reports addObject:dicAuthor];
        }
        [dic setObject:reports forKey:@"Reports"];
        [dic setObject:[self repoName] forKey:@"Repository"];
        NSError *err = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
        [jsonData writeToFile:textPath atomically:YES];
        NSMutableString *jsonString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //replace "\/" into "/"
        NSString *ch = nil;
        for (NSInteger index = 0;index < jsonString.length;index++)
        {
            ch = [jsonString substringWithRange:NSMakeRange(index, 1)];
            if ([ch isEqualToString:@"\\"])
                [jsonString deleteCharactersInRange:NSMakeRange(index, 1)];
        }
        //delete root path, keep relative path
        
        
        //NSString *string = [jsonString stringByReplacingOccurrencesOfString:[self rootPath] withString:@""];
        //[string writeToFile:textPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        [jsonString writeToFile:textPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"%@",jsonString);
    }
    [self.db close];
    
}

- (void)creatFileTable
{
    if ([self.db open])
    {
        BOOL succes = [self.db executeStatements:@"create table fileAnalyze(id integer primary key autoincrement,path text, sourceTree text, groupId text,childrenId text)"];
//        if (succes)
//        {
//            //NSLog(@"creat table succesed");
//        }
        succes = [self.db executeStatements:@"create table file (id integer primary key autoincrement,fileName text, path text, sourceTree text, fileId text)"];
//        if (succes)
//        {
//            //NSLog(@"build succesed");
//        }
    }
    [self.db close];
}
- (void)dropFileTable
{
    if ([self.db open])
    {
        BOOL succese = [self.db executeStatements:@"drop table file"];
        succese = [self.db executeStatements:@"drop table fileAnalyze"];
//        if (succese)
//        {
//            NSLog(@"drop table is succesed");
//        }
    }
    [self.db close];
}
- (void)updateFileTable:(NSMutableArray *)arrForFiles and:(NSMutableArray *)arrForGroups
{
    if ([self.db open])
    {
       // [self creatFileTable];
        
        [self.db beginTransaction];
        for (NSArray *arr in arrForFiles)
        {
            [self.db executeUpdate:@"insert into file (fileName,path,sourceTree,fileId) values(?,?,?,?)",[arr objectAtIndex:0],[arr objectAtIndex:1],[arr objectAtIndex:2],[arr objectAtIndex:3]];
            
        }
        for (NSArray *arr in arrForGroups)
        {
            [self.db executeUpdate:@"insert into fileAnalyze(path,sourceTree,groupId,childrenId) values(?,?,?,?)",[arr objectAtIndex:0],[arr objectAtIndex:1],[arr objectAtIndex:2],[arr objectAtIndex:3]];
        }
        [self.db commit];
    }
    [self.db close];
    
}
- (void)findGroupPathFromMainPath:(NSString *)mainPath andMainGroupId:(NSString *)mainGroupId
{
    if ([self.db open])
    {
        NSMutableArray *arrForGroups = [NSMutableArray array];
        FMResultSet *set = [self.db executeQuery:@"select groupId from fileAnalyze"];
        while ([set next])
        {
            if (![arrForGroups containsObject:[set stringForColumn:@"groupId"]])
            {
                [arrForGroups addObject:[set stringForColumn:@"groupId"]];
            }
        }
        NSMutableDictionary *dicForGroup = [NSMutableDictionary dictionary];
        //NSInteger index = 0;
        [self.db beginTransaction];
        for (NSString *string in arrForGroups)
        {
            //index++;
            NSString *path = @"";
            FMResultSet *re = [db executeQuery:@"select * from fileAnalyze where groupId=?",string];
            if ([re next])
            {
                if (![[re stringForColumn:@"path"] isEqualToString:@""])
                {
                    path = [path stringByAppendingFormat:@"%@",[re stringForColumn:@"path"]];
                }
                
            }
            re = [self.db executeQuery:@"select * from fileAnalyze where groupId=?",string];
            
            if ([[re stringForColumn:@"sourceTree"] isEqualToString:@"SOURCE_ROOT"])
            {
                if (![[re stringForColumn:@"path"] isEqualToString:@""])
                    path = [mainPath stringByAppendingFormat:@"/%@",[re stringForColumn:@"path"]];
                else
                    path = mainPath;
                
                NSString *absolutePath = [path stringByStandardizingPath];
                path = absolutePath;
            }
            else
            {
                FMResultSet *set = [db executeQuery:@"select * from fileAnalyze where childrenId=?",string];
                if ([set next])
                {
                    NSString *groupId= [set stringForColumn:@"groupId"];
                    
                    while (![groupId isEqualToString:mainGroupId])
                    {
                        if (![[set stringForColumn:@"path"]isEqualToString:@""])
                        {
                            if (![path isEqualToString:@""])
                            {
                                path =[[set stringForColumn:@"path"] stringByAppendingFormat:@"/%@",path];
                            }
                            else
                                path = [path stringByAppendingFormat:@"%@",[set stringForColumn:@"path"]];
                        }
                        
                        set = [self.db executeQuery:@"select * from fileAnalyze where childrenId=?",groupId];
                        
                        if ([set next])
                        {
                            groupId = [set stringForColumn:@"groupId"];
                        }
                        else
                            break;
                    }
                    
                    if (![path isEqualToString:@""])
                    {
                        path = [mainPath stringByAppendingFormat:@"/%@",path];
                    }
                    else
                        path = mainPath;
                    
                    NSString *absoulutePath = [path stringByStandardizingPath];
                    path = absoulutePath;
                    
                    //NSLog(@"path %li %@",index,path);
                    [dicForGroup setObject:path forKey:string];
                    // NSLog(@"path %@",path);
                    
                }
                else
                {
                    if (![path isEqualToString:@""])
                    {
                        path = [mainPath stringByAppendingFormat:@"/%@",path];
                    }
                    else
                        path = mainPath;
                    NSString *absoulutePath = [path stringByStandardizingPath];
                    path = absoulutePath;
                    //NSLog(@"path %li %@",index,path);
                    [dicForGroup setObject:path forKey:string];
                    // NSLog(@"path %@",path);
                }
            }
        }
        
        for (NSString *key in dicForGroup)
        {
            [self.db executeUpdate:@"update fileAnalyze set path=? where groupId=?",[dicForGroup objectForKey:key],key];
        }
        [self.db commit];
    }
    
    [self.db close];
}

- (NSMutableArray *)findFilePathFromMainPath:(NSString *)mainPath andBuildPath:(NSString *)buildPath
{
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.db open])
    {
        FMResultSet *fileset = [db executeQuery:@"select * from file"];
        while([fileset next])
        {
            NSString *path = nil;
            if ([[fileset stringForColumn:@"sourceTree"]isEqualToString:@"SOURCE_ROOT"] && ![[fileset stringForColumn:@"sourceTree"]isEqualToString:@""] )
            {
                path = [ mainPath stringByAppendingFormat:@"/%@",[fileset stringForColumn:@"path"]];
            }
            
            else if ([[fileset stringForColumn:@"sourceTree"]isEqualToString:@"BUILT_PRODUCTS_DIR"])
            {
                path = [buildPath stringByAppendingFormat:@"/%@",[fileset stringForColumn:@"path"]];
            }
//            else if ([[fileset stringForColumn:@"fileName"] containsString:@".a"] || [[fileset stringForColumn:@"fileName"] containsString:@".framework"])
//            {
//                path = [fileset stringForColumn:@"fileName"];
//            }
            
            else
            {
                FMResultSet *fileGroup = [db executeQuery:@"select * from fileAnalyze where childrenId=?",[fileset stringForColumn:@"fileId"]];
                
                if ([fileGroup next])
                {
                    NSString *groupPath = [fileGroup stringForColumn:@"path"];
                    path = [groupPath stringByAppendingFormat:@"/%@",[fileset stringForColumn:@"path"]];
                }
            }
            path = [path stringByStandardizingPath];
            
            [arr addObject:path];
        }
    }
    [self.db close];
    
    return arr;
}

- (void)updateResultTableByUseCommitTable
{
    if ([self.db open])
    {
        FMResultSet *result = [self.db executeQuery:@"select * from commitTable"];
        while ([result next])
        {
            NSString *author = [result stringForColumn:@"authorName"];
            
            //NSLog(@"author name is :%@",author);
            
            NSString *commitFileName = [result stringForColumn:@"commitFileName"];
            
            FMResultSet *changedInfo = [self.db executeQuery:@"select projName from relationshipTable where filePath=?",commitFileName];
            
            NSMutableArray *changedProjs = [NSMutableArray array];
            
            while ([changedInfo next])
            {
                NSString *proj = [changedInfo stringForColumn:@"projName"];
                
                [changedProjs addObject:proj];
                
                FMResultSet *libraryProjsChange = [self.db executeQuery:@"select * from libraryTable where belongToProj=?",proj];
                
                while ([libraryProjsChange next])
                {
                    NSString *libName = [libraryProjsChange stringForColumn:@"libraryName"];
                    
                    FMResultSet *projsRelatedToLibPath = [self.db executeQuery:@"select projName from relationshipTable where filePath=?",libName];
                    
                    while ([projsRelatedToLibPath next])
                    {
                        NSString *projRelatedToLib = [projsRelatedToLibPath stringForColumn:@"projName"];
                        
                        [changedProjs addObject:projRelatedToLib];
                        [changedProjs removeObject:proj];
                    }
                    // }
                }
            }
            [self.db beginTransaction];
            if ([changedProjs count] != 0)
            {
                for (NSString *proj in changedProjs)
                {
                    FMResultSet *plistsOfProj = [self.db executeQuery:@"select * from plistTable where projName=?",proj];
                    float max = 0;
                    max = [self findMaxModificationDateOfLibs:[self findLibs:proj]];
                    
                    while ([plistsOfProj next])
                    {
                        NSString *plistPath = [plistsOfProj stringForColumn:@"plistPath"];
                        NSString *plistVersion = [plistsOfProj stringForColumn:@"plistDate"];
                       
                        FMResultSet *isPlistInCommit = [self.db executeQuery:@"select id from commitTable where authorName=? and commitFileName=?",author,plistPath];
                        
                        if (![isPlistInCommit next] && ![plistVersion isEqualToString:[TableController dateForNow]])
                        {
                            
                            [self.db executeUpdate:@"insert into resultTable(authorName,fileChanged,projChanged,plistNotChanged) values(?,?,?,?)",author,commitFileName,proj,plistPath];
                        }
                    }
                }
            }
            [self.db commit];
        }
    }
    [self.db close];
}

- (NSMutableArray *)findLibs:(NSString *)proj
{
    NSMutableArray *libsInProjs = [NSMutableArray array];
    if ([self.db open])
    {
        FMResultSet *result = [self.db executeQuery:@"select * from relationshipTable where projName=?",proj];
        while ([result next])
        {
            NSString *file = [result stringForColumn:@"fileName"];
            if ([file containsString:@"dependencies"] && [file hasSuffix:@".a"])
            {
                [libsInProjs addObject:file];
            }
        }
    }
    return libsInProjs;
}

- (float)findMaxModificationDateOfLibs:(NSMutableArray *)libs
{
    float maxModificationDate = 0;
    NSTimeZone *zone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyMM.dd";
    formatter.timeZone = zone;
    for (NSString *libPath in libs)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:libPath];
        NSDate *date = [dic objectForKey:@"NSFileModificationDate"];
        NSString *dateString = [formatter stringFromDate:date];
        float tmp = [dateString floatValue];
        if (tmp > maxModificationDate)
        {
            maxModificationDate = tmp;
        }
        
    }
    return maxModificationDate;
}

@end

