//
//  FileList.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "FileList.h"
#import "SampleAnalyzer.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "TableController.h"

@implementation FileList
@synthesize fileList;
@synthesize sqlitePath;

- (id)initWithPath:(NSString *)repopath andsqlitePath:(NSString *)sqlitepath
{
    self = [super init];
    sqlitePath = sqlitepath;
    
    if (self && repopath)
    {
        NSPipe* pipe = [NSPipe pipe];
        NSFileHandle* file = pipe.fileHandleForReading;
        NSTask *task = [[NSTask alloc] init];
        [task setStandardInput:[NSPipe pipe]];
        [task setLaunchPath:@"/usr/bin/find"];
        [task setArguments:[NSArray arrayWithObjects:repopath, @"-name", @"*.pbxproj", nil]];
        task.standardOutput = pipe;
        // [task setStandardInput:[NSPipe pipe]];
        
        [task launch];
        
        NSData *data = [file readDataToEndOfFile];
        [file closeFile];
        
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"the output is %@",output);
        self.fileList = [output componentsSeparatedByString:@"\n"];
        //[self addFileToFileTable];
        
        
    }
    return self;
}
- (void) addFileToFileTable
{
    //    NSMutableArray *projlist = [NSMutableArray array];
    //    NSMutableArray *plistlist = [NSMutableArray array];
    //    NSString *projname = [NSString string];
    //    NSString *libraryName;
    
    TableController *control = [[TableController alloc] initTableWith:sqlitePath];
    NSString *a =@".sqlite";
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString *path in self.fileList) {
        [operation addExecutionBlock:^{
            
            NSNumber *num = [NSNumber numberWithInteger:i];
            NSString *b = [NSString stringWithFormat:@"%@%@",num,a];
            
            SampleAnalyzer *proj = [[SampleAnalyzer alloc] initWithFile:path andsqlitePath:b];
            if(proj)
            {
                [arr addObject:proj];
            }
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:b])
            {
                [fm removeItemAtPath:b error:NULL];
            }
            
        }];
        i++;
    }
    [operation start];
    
    //[control open];
    NSLog(@"Begin update table!");
    for (SampleAnalyzer *proj in arr)
    {
        [control updateAllTable:proj];
    }
    NSLog(@"End update table!");
    [control close];

    
}

@end

