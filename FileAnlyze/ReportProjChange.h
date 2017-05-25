//
//  ReportProjChange.h
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommitFile.h"
#import "FileList.h"
#import "FMResultSet.h"
@interface ReportProjChange : NSObject


@property NSString *sqlitePath;

@property NSMutableDictionary *projsChangeInfo;//store the plist do not change;

- (id)initWithSqlitePath:(NSString *)sqlitepath;
- (void)AuthorChangeForProjs;

@end
