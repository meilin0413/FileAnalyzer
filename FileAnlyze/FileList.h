//
//  FileList.h
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileList : NSObject

@property NSArray<NSString *>* fileList;
@property NSString* sqlitePath;

- (id)initWithPath:(NSString *)repopath andsqlitePath:(NSString *)sqlitepath;
- (void) addFileToFileTable;
@end
