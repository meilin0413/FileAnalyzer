//
//  LibsInfo.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/27.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "LibsInfo.h"

@implementation LibsInfo

@synthesize libPath;



- (id)initWithLibPath:(NSString *)libpath
{
    self = [super init];
    if (self)
    {
        libPath = libpath;
        [self setLibModificationDateWith:libPath];
        
    }
    return self;
}

- (void)setLibModificationDateWith:(NSString *)libpath
{
    NSTimeZone *zone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyMM.dd";
    formatter.timeZone = zone;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *dic = [fm attributesOfItemAtPath:libPath error:nil];;
    NSLog(@"dic %@",dic);
    NSDate *date = [dic objectForKey:@"NSFileModificationDate"];
    NSLog(@"date %@",date);
    NSString *dateString = [NSString string];
    dateString = [formatter stringFromDate:date];
    NSLog(@"string %@",dateString);
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    numFormatter.usesSignificantDigits = YES;
    self.libModificationDate = [numFormatter numberFromString:dateString];
    NSLog(@"%@",self.libModificationDate);
}
//
//- (float)libModificationDate
//{
//    return libModificationDate;
//}

@end
