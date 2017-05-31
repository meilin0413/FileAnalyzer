//
//  LibsInfo.h
//  FileAnlyze
//
//  Created by Lily li on 2017/5/27.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibsInfo : NSObject

@property NSNumber *libModificationDate;
@property NSString *libPath;

- (id)initWithLibPath:(NSString *)libpath;

@end
