//
//  NSString+pathAnlyze.h
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (pathAnalyze)

//- (NSMutableString *)deletePathComponentInlast:(NSUInteger)index;
- (NSMutableString *)deletePathComponentBeforeMeet:(NSString *)component;

@end
