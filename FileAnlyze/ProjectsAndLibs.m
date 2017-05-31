//
//  ProjectsAndLibs.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/27.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "ProjectsAndLibs.h"
#import "TableController.h"
#import "FMDatabase.h"
@implementation ProjectsAndLibs

@synthesize libs;


- (id)initWithDependenciesPath:(NSString *)dependencesPath
{
    self = [super init];
    if (self)
    {
        NSPipe* pipe = [NSPipe pipe];
        NSFileHandle* file = pipe.fileHandleForReading;
        NSTask *task = [[NSTask alloc] init];
        [task setStandardInput:[NSPipe pipe]];
        [task setLaunchPath:@"/usr/bin/find"];
        [task setArguments:[NSArray arrayWithObjects:dependencesPath, @"-name", @"*.a", nil]];
        task.standardOutput = pipe;
        
        [task launch];
        
        NSData *data = [file readDataToEndOfFile];
        [file closeFile];
        
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *arrForLibPaths = [output componentsSeparatedByString:@"\n"];
        NSLog(@"lib paths %@",arrForLibPaths);
        
        libs = [[NSMutableArray alloc] init];
        for (NSString *path in arrForLibPaths)
        {
            if ([path isEqualToString:@""])
            {
                break;
            }
            LibsInfo *lib = [[LibsInfo alloc] initWithLibPath:path];
            [libs addObject:lib];
            NSLog(@"lib path %@",lib.libPath);
            
        }
       
    }
    
    return self;
}

- (void)updateTableLibsAndProjsWithSqlitePath:(NSString *)sqlitePath
{
    FMDatabase *db = [FMDatabase databaseWithPath:sqlitePath];
    if ([db open])
    {
        NSMutableDictionary *dicForProjsWithPlist = [NSMutableDictionary dictionary];
        [db executeStatements:@"create table libAndProjsTable(id integer primary key autoincrement,projName text,libPath text,projDate text,libDate text)"];
        
        FMResultSet *hasPlistProjs = [db executeQuery:@"select * from plistTable"];
        while ([hasPlistProjs next])
        {
            [dicForProjsWithPlist setObject:[hasPlistProjs stringForColumn:@"plistDate"] forKey:[hasPlistProjs stringForColumn:@"projName"]];
        }
        NSArray *arr = [dicForProjsWithPlist allKeys];
        
        //[db beginTransaction];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.usesSignificantDigits = YES;
        
        for (LibsInfo *lib in libs)
        {
            //NSMutableArray *projsForLib = [NSMutableArray array];
            FMResultSet *result = [db executeQuery:@"select * from relationshipTable where filePath=?",lib.libPath];
            while ([result next])
            {
                NSString *proj = [result stringForColumn:@"projName"];
                if ([dicForProjsWithPlist objectForKey:proj])
                {
                    NSNumber *plistVersion = [formatter numberFromString:[dicForProjsWithPlist objectForKey:proj]];
                    NSComparisonResult result = [lib.libModificationDate compare:plistVersion];
                    
                    if ([arr containsObject:proj] && (result == NSOrderedDescending))
                    {
                        [db executeUpdate:@"insert into libAndProjsTable(projName,libPath,projDate,libDate) values(?,?,?,?)",proj,lib.libPath,[dicForProjsWithPlist objectForKey:proj],[NSString stringWithFormat:@"%@",lib.libModificationDate]];
                    }
 
                }
            }
            
        }
        FMResultSet *result = [db executeQuery:@"select projName from libAndProjsTable"];
        NSMutableArray *projs = [NSMutableArray array];
        while ([result next])
        {
            NSString *proj = [result stringForColumn:@"projName"];
            if (![projs containsObject:proj])
            {
                [projs addObject:proj];
            }
        }
        NSMutableArray *arrForProjs = [NSMutableArray array];
        for (NSString *proj in projs)
        {
            NSMutableDictionary *dicForProj = [NSMutableDictionary dictionary];
            NSMutableArray *LibAndVersion = [NSMutableArray array];
            FMResultSet *re = [db executeQuery:@"select * from libAndProjsTable where projName=?",proj];
            while ([re next])
            {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[re stringForColumn:@"libPath"],@"lib path",[re stringForColumn:@"libDate"],@"lib modification date", nil];
                [LibAndVersion addObject:dic];
                [dicForProj setObject:[re stringForColumn:@"projDate"] forKey:@"proj version"];
            }
            [dicForProj setObject:proj forKey:@"proj name"];
            [dicForProj setObject:LibAndVersion forKey:@"libAndVersion"];
            [arrForProjs addObject:dicForProj];
        }
        NSError *err = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrForProjs options:NSJSONWritingPrettyPrinted error:&err];
       // [jsonData writeToFile:@"hhhhh.json" atomically:YES];
        NSMutableString *jsonString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *ch = nil;
        for (NSInteger index = 0;index < jsonString.length;index++)
        {
            ch = [jsonString substringWithRange:NSMakeRange(index, 1)];
            if ([ch isEqualToString:@"\\"])
                [jsonString deleteCharactersInRange:NSMakeRange(index, 1)];
        }
        [jsonString writeToFile:@"hhhhh.json" atomically:YES encoding:NSUTF8StringEncoding error:nil];
        //[arrForProjs writeToFile:@"hhhhh.json" atomically:YES];
        
        //[db commit];
    }
    [db close];
}
- (void)outputLibAndProjsTable
{
    
}
@end
