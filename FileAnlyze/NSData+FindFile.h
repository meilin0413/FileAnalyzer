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


//- (NSString *) afterProfuctreference:(NSData *)dataToFind;
- (NSRange)rangeOfData:(NSData *)dataToFind afterIndex:(NSInteger)index;

//find the data .... /* ..... */, between /* and */.
- (NSString *)findFileNameWithExtension:(NSString *)ext keyword:(NSString *)keyword;


//For Commit File
- (NSRange) rangeAfterIndex:(NSUInteger)index between:(char)a and:(char)b;
- (NSRange) beforeKeyDataRange:(NSRange)keyDataRange untilMeet:(char)a;

- (NSMutableArray *)arryOfDataWithExtension:(NSData *)dataExtention afterIndex:(NSInteger)afterIndex beforeIndex:(NSInteger)beforeIndex;
- (NSMutableDictionary *) locationOfData:(NSData *)dataToFind;


- (NSRange)rangeOfData:(NSData *)dataToFind afterIndex:(NSInteger)index beforeIndex:(NSInteger)beforIndex;
- (NSRange)rangeOfDataBackwardsSearch:(NSData*)dataToFind beforeIndex:(NSInteger) beforeindex;
@end
