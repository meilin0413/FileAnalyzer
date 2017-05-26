//
//  NSString+pathAnlyze.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "NSString+pathAnlyze.h"

@implementation NSString (pathAnlyze)

//if component do not exist, return self
- (NSMutableString *)deletePathComponentBeforeMeet:(NSString *)component
{
    NSArray *pathComponents = [self componentsSeparatedByString:@"/"];
    NSMutableString *path = [NSMutableString string];
    NSInteger searchIndex = 0;
    for (NSInteger index = 0; index < [pathComponents count];index++)
    {
        if (![[pathComponents objectAtIndex:index] isEqualToString:component])
        {
            searchIndex++;
        }
        else
            break;
    }
    if (searchIndex >= [pathComponents count])
    {
        return [NSMutableString stringWithString:self];
    }
    
    if ([[pathComponents objectAtIndex:0] isEqualToString:@""])
    {
        for (NSInteger indexTmp = 1;indexTmp < searchIndex;indexTmp++)
        {
            [path appendString:@"/"];
            [path appendString:[pathComponents objectAtIndex:indexTmp]];
        }
    }
    else
    {
        for (NSInteger indexTmp = 0;indexTmp < searchIndex;indexTmp++)
        {
            [path appendString:@"/"];
            [path appendString:[pathComponents objectAtIndex:indexTmp]];
        }
    }
    return path;
    
}
@end
