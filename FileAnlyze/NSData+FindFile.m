//
//  NSData+FindFile.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "NSData+FindFile.h"

#import "NSData+FindFile.h"

@implementation NSData (FindFile)
//this method is used to obtain a string contains .m or .cpp or .mm if type is YES, return the path of .framework or .a or .m or .mm or .cpp in .pbxproj, the path can be absolute path or relative path;
//if type is NO, find .plist
//- (NSString *)dateOfRange:(NSUInteger)index and:(const void *)byte and:(BOOL) type
//{
//    int searchIndex = 0;
//    NSRange found ={NSNotFound,0};
//    NSData* founData;
//    NSString* string;
//    if (type)
//    {
//        for (NSInteger i = 0; i < MAX_LENGTH_OF_PATH; i++)
//        {
//            if (((char*)byte)[index+i] == '.' && ((char*)byte)[index+i+1] == 'f' && ((char*)byte)[index+i+2] == 'r' && ((char*)byte)[index+i+3] == 'a' && ((char*)byte)[index+i+4] == 'm' && ((char*)byte)[index+i+5] == 'e')
//            {
//                searchIndex = searchIndex + 9;
//                break;
//            }
//            else if (((char*)byte)[index+i] == '.' && ((char*)byte)[index+i+1] == 'c' && ((char*)byte)[index+i+2] == 'p' && ((char*)byte)[index+i+3] == 'p')
//            {
//                searchIndex = searchIndex + 3;
//                break;
//            }
//            else if (((char*)byte)[index+i] == '.' && ((char*)byte)[index+i+1] == 'm' && ((char*)byte)[index+i+2] == 'm')
//            {
//                searchIndex = searchIndex + 2;
//                break;
//            }
//            else if (((char*)byte)[index+i] == '.' && ((char*)byte)[index+i+1] == 'm')
//            {
//                searchIndex = searchIndex + 1;
//                break;
//            }
//            else if (((char*)byte)[index+i] == '.' && ((char*)byte)[index+i+1] == 'a')
//            {
//                searchIndex = searchIndex + 1;
//                break;
//            }
//            else
//            {
//                searchIndex++;
//            }
//            
//            
//        }
//    }
//    //find .plist
//    else
//    {
//        int i = 0;
//        while (((char*)byte)[index] != ' ' && index > 0 && i < 2 && ((char*)byte)[index] != '\"')
//        {
//            if (((char*)byte)[index] == '/')
//                i++;
//            index--;
//            searchIndex++;
//        }
//    }
//    
//    
//    found.location = index + 1;
//    found.length = searchIndex;
//    if (found.location != NSNotFound && found.length < MAX_LENGTH_OF_PATH)
//    {
//        founData = [self subdataWithRange:found];
//        string = [[NSString alloc] initWithData:founData encoding:NSUTF8StringEncoding];
//        return string;
//    }
//    else
//        return nil;
//    
//}
//this method is used to obtain the data to find,ex:"path =", return a array which contains .framework ,.cpp,.m,.mm.

//- (NSMutableArray *)rangeOfData:(NSData*)dataToFind and:(BOOL)type {
//    
//    const void* bytes = [self bytes];
//    NSUInteger length = [self length];
//    const void* searchBytes = [dataToFind bytes];
//    NSUInteger searchLength = [dataToFind length];
//    NSUInteger searchIndex = 0;
//    NSMutableArray *contentOfFile = [NSMutableArray array];
//    
//    if (length < searchLength) {
//        return contentOfFile;
//        
//    }
//    for (NSUInteger index = 0; index < length; index++) {
//        // The current character matches.
//        if (((char*)bytes)[index] == ((char*)searchBytes)[searchIndex]) {
//            // Increment search character index to check for match.
//            searchIndex++;
//            
//            // All search character match.
//            // Break search routine and return found position.
//            if (searchIndex >= searchLength) {
//                NSString* data = [self dateOfRange:index and:bytes and:type];
//                //NSString* data = [self findDatabeforemeet:index and:bytes];
//                if ( data && (![contentOfFile containsObject:data]))
//                    [contentOfFile addObject:data];
//                searchIndex = 0;
//            }
//        }
//        // Match does not continue.
//        // Return to the first search character.
//        // Discard former found location.
//        else {
//            index = index - searchIndex;
//            searchIndex = 0;
//            
//        }
//    }
//    return contentOfFile;
//}

- (NSString *)findDatabeforemeet:(NSUInteger)index and:(const void *)byte
{
    int searchIndex = 0;
    NSRange found ={NSNotFound,0};
    NSData* founData;
    NSString* string;
    while (((char*)byte)[index] != ' ' && index > 0 && ((char*)byte)[index] != '\"' && ((char*)byte)[index] != '/')
    {
        index--;
        searchIndex++;
    }
    found.location = index + 1;
    found.length = searchIndex;
    if (found.location != NSNotFound)
    {
        founData = [self subdataWithRange:found];
        string = [[NSString alloc] initWithData:founData encoding:NSUTF8StringEncoding];
        return string;
    }
    else
        return nil;
}
//- (NSString *)nameOfDataBackwardsSearch:(NSData*)dataToFind {
//    
//    const void* bytes = [self bytes];
//    NSUInteger length = [self length];
//    const void* searchBytes = [dataToFind bytes];
//    NSUInteger searchLength = [dataToFind length];
//    NSUInteger searchIndex = 0;
//    NSString *nameofData;
//    NSData *name;
//    NSRange foundRange = {NSNotFound, searchLength};
//    if (length < searchLength) {
//        return nameofData;
//    }
//    for (NSInteger index = length - searchLength; index >= 0;) {
//        //		NSLog(@"%c == %c", ((char*)bytes)[index], ((char*)searchBytes)[searchIndex]); /* DEBUG LOG */
//        if (((char*)bytes)[index] == ((char*)searchBytes)[searchIndex]) {
//            // The current character matches.
//            if (foundRange.location == NSNotFound) {
//                foundRange.location = index;
//            }
//            index++;
//            searchIndex++;
//            if (searchIndex >= searchLength) {
//                foundRange.location = index - searchIndex + 1;
//                foundRange.length = length - (index-searchIndex) - 1;
//                name = [self subdataWithRange:foundRange];
//                nameofData = [[NSString alloc] initWithData:name encoding:NSUTF8StringEncoding];
//                return nameofData;
//                
//            }
//        }
//        else {
//            // Decrement to search backwards.
//            if (foundRange.location == NSNotFound) {
//                // Skip if first byte has been reached.
//                if (index == 0) {
//                    foundRange.location = NSNotFound;
//                    return nameofData;
//                }
//                index--;
//            }
//            // Jump over the former found location
//            // to avoid endless loop.
//            else {
//                //index = index - 2;//
//                index = index - searchIndex-1;
//            }
//            searchIndex = 0;
//            foundRange.location = NSNotFound;
//        }
//    }
//    return nameofData;
//}

//- (BOOL)iscontainsString:(NSString *)stringtoFind
//{
//    const void* bytes = [self bytes];
//    NSUInteger length = [self length];
//    NSData *stringData = [stringtoFind dataUsingEncoding:NSUTF8StringEncoding];
//    const void* searchBytes = [stringData bytes];
//    NSUInteger searchLength = [stringData length];
//    NSUInteger searchIndex = 0;
//    if (length < searchLength) {
//        return NO;
//    }
//    for (NSUInteger index = 0; index < length; index++) {
//        // The current character matches.
//        if (((char*)bytes)[index] == ((char*)searchBytes)[searchIndex]) {
//            // Increment search character index to check for match.
//            searchIndex++;
//            
//            // All search character match.
//            // Break search routine and return found position.
//            if (searchIndex >= searchLength) {
//                return YES;
//            }
//        }
//        // Match does not continue.
//        // Return to the first search character.
//        // Discard former found location.
//        else {
//            index = index - searchIndex;
//            searchIndex = 0;
//            
//        }
//    }
//    return NO;
//}
//this method is used to find the name of file .a which is the product of a proj
//if the product of proj is not .a, return nil
- (NSString *) afterProfuctreference:(NSData *)dataToFind
{
    const void* bytes = [self bytes];
    NSUInteger length = [self length];
    const void* searchBytes = [dataToFind bytes];
    NSUInteger searchLength = [dataToFind length];
    int count = 0;
    NSString *libraryName;
    //    NSRange foundRange = {NSNotFound, searchLength};
    if (length < searchLength) {
        return libraryName;
    }
    NSUInteger searchIndex = 0;
    for (NSUInteger index = 0; index < length; index++) {
        if (count <= MAX_COUNT_OF_PRODUCTREFERENCE)
        {
            // The current character matches.
            if (((char*)bytes)[index] == ((char*)searchBytes)[searchIndex]) {
                // Increment search character index to check for match.
                searchIndex++;
                
                // All search character match.
                // Break search routine and return found position.
                //the string productReference is found
                if (searchIndex >= searchLength) {
                    count++;
                    NSRange range = [self rangeInData:bytes afterIndex:index];
                    libraryName = [[NSString alloc] initWithData:[self subdataWithRange:range] encoding:NSUTF8StringEncoding];
                    if ([libraryName hasSuffix:@".a"])
                    {
                        return libraryName;
                    }
                    else
                    {
                        libraryName = nil;
                        searchIndex = 0;
                    }
                }
            }
            // Match does not continue.
            // Return to the first search character.
            // Discard former found location.
            else {
                index = index - searchIndex;
                searchIndex = 0;
                
            }
        }
        else
        {
            break;
        }
        
    }
    return libraryName;
    
}
//this method is used to find the range of data in /* abcbab */, noticed that there is a blank after or before *

- (NSRange) rangeInData:(const void *)byte afterIndex:(NSUInteger)index
{
    NSRange range = {NSNotFound,0};
    NSInteger temp = 0;
    for (NSInteger i = 0; i < MAX_LENGTH_OF_PATH; i++)
    {
        if (((char*)byte)[index+i] == '/' && ((char*)byte)[index+i+1] == '*')
        {
            range.location = index + i + 3;
            break;
        }
    }
    for (NSInteger i = 0; i < MAX_LENGTH_OF_PATH; i++)
    {
        if (((char*)byte)[index+i] == '*' && ((char*)byte)[index+i+1] == '/')
        {
            temp = index + i -1;
            break;
        }
    }
    range.length = temp - range.location;
    return range;
}

//find a string after index between a and b, a b must be differen.

- (NSRange) rangeAfterIndex:(NSUInteger)index between:(char)a and:(char)b
{
    const void *byte = [self bytes];
    NSRange range = {NSNotFound,0};
    NSInteger temp = 0;
    for (NSInteger i = 0; i < MAX_LENGTH_OF_PATH; i++)
    {
        if (((char*)byte)[index+i] == a)
        {
            range.location = index + i + 1;
            break;
        }
    }
    if (range.location == NSNotFound)
    {
        return range;
    }
    for (NSInteger i = 0; i < MAX_LENGTH_OF_PATH; i++)
    {
        if (((char*)byte)[index+i] == b)
        {
            temp = index + i;
            break;
        }
    }
   
    range.length = temp - range.location;
    return range;
}

// between afterIndex and beforeIndex, find a arry with string with extention (dataExtention)

- (NSMutableArray *) arryOfData:(NSData *)dataExtention afterIndex:(NSInteger)afterIndex beforeIndex:(NSInteger)beforeIndex
{
    NSMutableArray *stringWithDataExtension = [NSMutableArray array];
    
    const void *bytes = [self bytes];
    const void *searchBytes = [dataExtention bytes];
    NSUInteger searchLength = [dataExtention length];
    NSUInteger searchIndex = 0;
    NSRange range = {NSNotFound,searchLength};
    
    if ((beforeIndex - afterIndex) < searchLength)
    {
        return stringWithDataExtension;
    }
    
    for (NSUInteger indexTemp = afterIndex; indexTemp < beforeIndex; indexTemp++) {
        // The current character matches.
        if (((char*)bytes)[indexTemp] == ((char*)searchBytes)[searchIndex]) {
            if (range.location == NSNotFound)
            {
                range.location = indexTemp;
            }
            // Increment search character index to check for match.
            searchIndex++;
            
            // All search character match.
            // Break search routine and return found position.
            if (searchIndex >= searchLength) {
                NSRange rangeOfDataWithExtension = [self beforeKeyDataRange:range untilMeet:(char)9];
                
                NSString *stringWithExtension = [[NSString alloc] initWithData:[self subdataWithRange:rangeOfDataWithExtension] encoding:NSUTF8StringEncoding];
                
                [stringWithDataExtension addObject:stringWithExtension];
                searchIndex = 0;
                range.location = NSNotFound;
            }
        }
        else {
            indexTemp = indexTemp - searchIndex;
            searchIndex = 0;
            range.location = NSNotFound;
        }
    }
    return stringWithDataExtension;
}

- (NSRange)rangeOfData:(NSData *)dataToFind afterIndex:(NSInteger)index
{
//    const void *bytes = [self bytes];
//    NSUInteger length = [self length];
//    const void *searchBytes = [dataToFind bytes];
//    NSUInteger lengthOfDataToFind = [dataToFind length];
    
    NSRange range = {NSNotFound,[dataToFind length]};
    range = [self rangeOfData:dataToFind afterIndex:index beforeIndex:[self length]];
    
//    NSUInteger searchIndex = 0;
//    
//    if (lengthOfDataToFind > (length - index))
//        return range;
//    for (NSUInteger indexTemp = index; indexTemp < length;indexTemp++)
//    {
//        if (((char*)bytes)[indexTemp] == ((char*)searchBytes)[searchIndex])
//        {
//            if (range.location == NSNotFound)
//                range.location = indexTemp;
//            searchIndex++;
//            if (searchIndex >= lengthOfDataToFind)
//            {
//                return range;
//            }
//        }
//        else
//        {
//            indexTemp = indexTemp - searchIndex;
//            searchIndex = 0;
//            range.location = NSNotFound;
//        }
//    }
    return range;
}

//.plist range, return abc.plist range
- (NSRange) beforeKeyDataRange:(NSRange)keyDataRange untilMeet:(char)a
{
    NSRange range = {NSNotFound,0};
    const void *bytes = [self bytes];
    
    if (keyDataRange.location == NSNotFound)
        return range;
    
    if (!a)
        return range;
    
    NSInteger index = keyDataRange.location;
    while (index > 0 && ((char*)bytes)[index] != a)
    {
        index--;
    }
    range.location = index + 1;
    range.length = keyDataRange.location - index - 1 + keyDataRange.length;
    return range;
}

- (NSMutableDictionary *) locationOfData:(NSData *)dataToFind
{
    NSMutableDictionary* locationsOfdata = [NSMutableDictionary dictionary];
    
    NSUInteger length = [self length];
    for (NSInteger index = 0;index < length;index++ )
    {
        NSRange rangeOfdata = [self rangeOfData:dataToFind afterIndex:index];
        
        //NSLog(@"location %lui, length %lu",rangeOfdata.location,rangeOfdata.length); //for test
        
        if (rangeOfdata.location != NSNotFound)
        {
            index = rangeOfdata.location + MIN_AUTHOR_COMMIT_LENGTH;
            NSNumber *location = [NSNumber numberWithInteger:rangeOfdata.location];
            
            NSRange rangeOfAuthor = [self rangeAfterIndex:rangeOfdata.location between:'<' and:'>'];
            NSString *authorName = nil;
            
            if (rangeOfAuthor.location != NSNotFound)
            {
                authorName = [[NSString alloc] initWithData: [self subdataWithRange:rangeOfAuthor] encoding:NSUTF8StringEncoding];
            }
            if (authorName)
            {
                [locationsOfdata setObject:authorName forKey:location];
            }
        }
        else
        {
            return locationsOfdata;
        }
        
    }
    return locationsOfdata;
}

- (NSRange)rangeOfData:(NSData *)dataToFind afterIndex:(NSInteger)index beforeIndex:(NSInteger)beforIndex
{
    const void *bytes = [self bytes];
    NSUInteger length = [self length];
    const void *searchBytes = [dataToFind bytes];
    NSUInteger lengthOfDataToFind = [dataToFind length];
    
    NSRange range = {NSNotFound,lengthOfDataToFind};
    NSUInteger searchIndex = 0;
    
    if (lengthOfDataToFind > (length - index))
        return range;
    if (beforIndex - index < 0)
        return range;
    
    for (NSUInteger indexTemp = index; indexTemp < beforIndex;indexTemp++)
    {
        if (((char*)bytes)[indexTemp] == ((char*)searchBytes)[searchIndex])
        {
            if (range.location == NSNotFound)
                range.location = indexTemp;
            searchIndex++;
            if (searchIndex >= lengthOfDataToFind)
            {
                return range;
            }
        }
        else
        {
            indexTemp = indexTemp - searchIndex;
            searchIndex = 0;
            range.location = NSNotFound;
        }
    }
    return range;
}
- (NSRange)rangeOfDataBackwardsSearch:(NSData*)dataToFind beforeIndex:(NSInteger) beforeindex{
    
    const void* bytes = [self bytes];
    NSUInteger length = [self length];
    const void* searchBytes = [dataToFind bytes];
    NSUInteger searchLength = [dataToFind length];
    NSUInteger searchIndex = 0;
    
    NSRange foundRange = {NSNotFound, searchLength};
    if (length < searchLength) {
        return foundRange;
    }
    for (NSInteger index = beforeindex - searchLength; index >= 0;) {
        //		NSLog(@"%c == %c", ((char*)bytes)[index], ((char*)searchBytes)[searchIndex]); /* DEBUG LOG */
        if (((char*)bytes)[index] == ((char*)searchBytes)[searchIndex]) {
            // The current character matches.
            if (foundRange.location == NSNotFound) {
                foundRange.location = index;
            }
            index++;
            searchIndex++;
            if (searchIndex >= searchLength) {
                return foundRange;
            }
        }
        else {
            // Decrement to search backwards.
            if (foundRange.location == NSNotFound) {
                // Skip if first byte has been reached.
                if (index == 0) {
                    foundRange.location = NSNotFound;
                    return foundRange;
                }
                index--;
            }
            // Jump over the former found location
            // to avoid endless loop.
            else {
                //index = index - 2;//
                index = index - searchIndex-1;
            }
            searchIndex = 0;
            foundRange.location = NSNotFound;
        }
    }
    return foundRange;
}


@end
