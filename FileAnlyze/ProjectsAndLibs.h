//
//  ProjectsAndLibs.h
//  FileAnlyze
//
//  Created by Lily li on 2017/5/27.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibsInfo.h"
@interface ProjectsAndLibs : NSObject

@property NSMutableArray *libs;


- (id)initWithDependenciesPath:(NSString *)dependencesPath;
- (void)updateTableLibsAndProjsWithSqlitePath:(NSString *)sqlitePath;
@end
