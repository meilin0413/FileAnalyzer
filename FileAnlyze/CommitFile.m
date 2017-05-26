//
//  CommitFile.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "CommitFile.h"
#import "NSData+FindFile.h"
#import "TableController.h"
//@interface CommitFile ()
//@end
//this file analyze should be update, since we don't know the commit file information
@interface CommitFile()

@property NSString *commitPath;
@property NSString *commitTablePath;

@end

@implementation CommitFile

@synthesize commitFilesForAuthors = _commitFilesForAuthors;


+ (NSArray *)extensionString
{
    return @[@".plist",@".framework",@".cpp",@".mm",@".m\n"];
}

+ (NSString *)authorString
{
    return @"Author";
}

- (id)initWithPath:(NSString *)path andSqlitePath:(NSString *)sqlitePath
{
    self = [super init];
    if (self)
    {
        _commitFilesForAuthors = [NSMutableDictionary dictionary];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            _commitPath = path;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:sqlitePath])
        {
            _commitTablePath = sqlitePath;
        }
        return self;
    }
    return nil;
}

- (void)addCommitInfoIntoCommitTable
{
    NSData *commitData = [[NSData alloc] initWithContentsOfFile:_commitPath];
    NSData *authorData = [[CommitFile authorString] dataUsingEncoding:NSUTF8StringEncoding];
    // return anthor name and location
    NSMutableDictionary *locationsForAuthors = [commitData locationOfData:authorData];
    NSArray *keys = [locationsForAuthors allKeys];
    keys = [keys sortedArrayUsingComparator:^(id obj1,id obj2){return [obj1 compare:obj2];}];
    NSArray *extensionString = [CommitFile extensionString];
    
    for (NSInteger index = 0; index < [keys count];index++)
    {
        NSString *name = [locationsForAuthors objectForKey:[keys objectAtIndex:index]];
        
        NSMutableArray *commitFileForauthor = [NSMutableArray array];
        
        for (NSString * extension in extensionString)
        {
            NSData *extensionData = [extension dataUsingEncoding:NSUTF8StringEncoding];
            
            if (index < [keys count] -1)
            {
                if ([[commitData arryOfDataWithExtension:extensionData afterIndex:[[keys objectAtIndex:index] integerValue] beforeIndex:[[keys objectAtIndex:(index+1)] integerValue]] count] != 0)
                {
                    [commitFileForauthor addObjectsFromArray:[commitData arryOfDataWithExtension:extensionData afterIndex:[[keys objectAtIndex:index] integerValue] beforeIndex:[[keys objectAtIndex:(index+1)] integerValue]]];
                }
                
            }
            else
            {
                if ([[commitData arryOfDataWithExtension:extensionData afterIndex:[[keys objectAtIndex:index] integerValue] beforeIndex:[commitData length]] count] != 0)
                {
                    [commitFileForauthor addObjectsFromArray:[commitData arryOfDataWithExtension:extensionData afterIndex:[[keys objectAtIndex:index] integerValue] beforeIndex:[commitData length]]];
                }
                
            }
            
        }
        
        if ([commitFileForauthor count] != 0)
        {
            NSInteger index = 0;
            for (NSString *file in commitFileForauthor)
            {
                if ([file containsString:@".framework"])
                {
//                    NSString *new = [file lastPathComponent];
                    [commitFileForauthor replaceObjectAtIndex:index withObject:[file lastPathComponent]];
                }
                index++;
            }
            NSLog(@"%@ changed %@",name,commitFileForauthor);
            
            TableController *controller = [[TableController alloc] initTableWith:_commitTablePath];
            [controller updateCommitTable:name andCommitFiles:commitFileForauthor];
            
        }
    }
    
    
}
@end
