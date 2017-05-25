//
//  ReportProjChange.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "ReportProjChange.h"
#import "FMDatabase.h"
#import "NSData+FindFile.h"
#import "TableController.h"

@implementation ReportProjChange

//@synthesize projPath;
//@synthesize commitFilePath;
//@synthesize result;
////@synthesize file;
//@synthesize commitFile;
@synthesize sqlitePath;
@synthesize projsChangeInfo;

- (id)initWithSqlitePath:(NSString *)sqlitepath
{
    self = [super init];
    if (self)
    {
        if (sqlitepath)
        {
            sqlitePath = sqlitepath;
            projsChangeInfo = [NSMutableDictionary dictionary];
            
            return self;
        }
        return self;
    }
    return nil;
}

- (void)AuthorChangeForProjs
{
    TableController *controller = [[TableController alloc] initTableWith:sqlitePath];
    [controller updateResultTableByUseCommitTable];
}
@end
