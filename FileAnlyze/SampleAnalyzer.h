//
//  SampleAnalyzer.h
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSData+FindFile.h"
@interface SampleAnalyzer : NSObject


@property NSMutableArray* projContent;
@property NSString* projName;
@property NSMutableDictionary* plistList;
@property NSString* libraryName;


- (id)initWithFile:(NSString *)path andsqlitePath:(NSString* )sqlitePath;


@end
