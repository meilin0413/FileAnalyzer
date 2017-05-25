//
//  NSData+FindFile.h
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MAX_LENGTH_OF_PATH                      70
#define MAX_COUNT_OF_PRODUCTREFERENCE           2
#define MIN_AUTHOR_COMMIT_LENGTH                100


@interface NSData (FindFile)
//- (NSMutableArray *)rangeOfData:(NSData*)dataToFind and: (BOOL) type;
//- (NSString *) dateOfRange:(NSUInteger)index and:(const void *)byte and:(BOOL) type;
//- (NSString *)nameOfDataBackwardsSearch:(NSData*)dataToFind;
//- (BOOL)iscontainsString:(NSString *)string;

//this method is used to find productREference =..../*  ...  */
//we need the content of /* ... */
//the count of productReference is at max 2

- (NSString *) afterProfuctreference:(NSData *)dataToFind;
- (NSRange)rangeOfData:(NSData *)dataToFind afterIndex:(NSInteger)index;



//For Commit File
- (NSRange) rangeAfterIndex:(NSUInteger)index between:(char)a and:(char)b;
- (NSRange) beforeKeyDataRange:(NSRange)keyDataRange untilMeet:(char)a;
- (NSMutableArray *)arryOfData:(NSData *)dataExtention afterIndex:(NSInteger)afterIndex beforeIndex:(NSInteger)beforeIndex;
- (NSMutableDictionary *) locationOfData:(NSData *)dataToFind;


- (NSRange)rangeOfData:(NSData *)dataToFind afterIndex:(NSInteger)index beforeIndex:(NSInteger)beforIndex;
- (NSRange)rangeOfDataBackwardsSearch:(NSData*)dataToFind beforeIndex:(NSInteger) beforeindex;
@end
