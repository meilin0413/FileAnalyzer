//
//  CommitFile.h
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommitFile : NSObject
{
    NSMutableDictionary *commitFilesForAuthors;
}

@property NSMutableDictionary *commitFilesForAuthors;


- (id)initWithPath:(NSString *)path andSqlitePath:(NSString *)sqlitePath;
- (void)addCommitInfoIntoCommitTable;

+ (NSString *)authorString;
+ (NSArray *)extensionString;

@end

