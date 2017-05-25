//
//  SampleAnalyzer.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/23.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "SampleAnalyzer.h"
//#import "NSMutbleArray+delteUnuseful.h"
#import "TableController.h"
@interface SampleAnalyzer ()

@property NSString* filePath;

@end

@implementation SampleAnalyzer


@synthesize projContent;
@synthesize projName;
@synthesize plistList;
@synthesize libraryName;


//add main path in order to analyze the path
- (id)initWithFile:(NSString *)path andsqlitePath:(NSString* )sqlitePath
{
    self = [super init];
    if (self)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            NSData* data=[NSData data];
            self.filePath = path;
            
            data = [NSData dataWithContentsOfFile:path];
            self.projContent = [NSMutableArray array];
            self.projName = [NSString string];
            self.projName = [self projNameForFullPath];
            self.libraryName = [NSString string];
            self.plistList = [NSMutableDictionary dictionary];
            
            NSData *productReference = [@"productReference" dataUsingEncoding:NSUTF8StringEncoding];
            self.libraryName = [data afterProfuctreference:productReference];
            
            [self updateInfoFrom:data andSqilitePath:sqlitePath];
        }
        else
            return nil;
    }
    return self;
}

// this method return project name
- (NSString *)projNameForFullPath
{
    NSArray *projPath = [NSArray array];
    projPath = [self.filePath componentsSeparatedByString:@"/"];
    NSUInteger length = [projPath count];
    if ( length >= 2 )
    {
        return [projPath objectAtIndex:length-2];
    }
    else
        return nil;
}

//this method return the projct dictionary
- (NSString *)projPath
{
    NSString *projPath = [self.filePath stringByAppendingString:@"/../.."];
    projPath = [projPath stringByStandardizingPath];
    return projPath;
}



- (void)updateInfoFrom:(NSData *)data andSqilitePath:(NSString *)path
{
    NSMutableArray *arrForFiles = [NSMutableArray array];
    NSMutableArray *arrForGroups = [NSMutableArray array];
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [arrForGroups addObjectsFromArray:[self findGroupsInProj:data]];
    }];
    
    [operation addExecutionBlock:^{
        [arrForFiles addObjectsFromArray:[self findFileInProjs:data]];
    }];
    [operation start];
    
    NSString *mainGroupId = [self findMainGroupIdFrom:data];
    NSMutableArray *arr = [NSMutableArray array];
    
    TableController *controller = [[TableController alloc] initTableWith:path];
    [controller creatFileTable];
    [controller updateFileTable:arrForFiles and:arrForGroups];
    [controller findGroupPathFromMainPath:[self projPath] andMainGroupId:mainGroupId];
    arr = [controller findFilePathFromMainPath:[self projPath]];
    
    [controller dropFileTable];
    for (NSString *path in arr)
    {
        BOOL isPathPlist = [path containsString:@".plist"];
        if (isPathPlist)
        {
            BOOL isPathValid = ![path containsString:@"test"] && ![path containsString:@"Test"];
            
            if (isPathValid)
            {
               // [self.plistList addObject:path];
                NSDictionary *dicForPlist = [[NSDictionary alloc] initWithContentsOfFile:path];
                //NSLog(@"path is %@",path);
                NSString *plistVersion = [dicForPlist objectForKey:@"CFBundleVersion"];
                NSArray *arrForPlistVersion = [plistVersion componentsSeparatedByString:@"."];
                
                if ([arrForPlistVersion count] >= 2)
                {
                    NSString *plistDate = [NSString stringWithFormat:@"%@.%@",arrForPlistVersion[0],arrForPlistVersion[1]];
                    [self.plistList setObject:plistDate forKey:path];
                }
                
            }
        }
        else
            [self.projContent addObject:path];
    }
}

- (NSMutableArray *)findFileInProjs:(NSData *)data
{
    NSData *fileReference = [@"/* Begin PBXFileReference section */" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *fileReferenceEnd = [@"/* End PBXFileReference section */" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *pathData = [@"path = " dataUsingEncoding:NSUTF8StringEncoding];
    NSData *sourceTree = [@"sourceTree = " dataUsingEncoding:NSUTF8StringEncoding];
    
    NSRange rangeOfBeginRefer = [data rangeOfData:fileReference afterIndex:0 beforeIndex:[data length]];
    NSRange rangeOfEndRefer = [data rangeOfData:fileReferenceEnd afterIndex:0 beforeIndex:[data length]];
    
    NSInteger indexRef = rangeOfBeginRefer.location + rangeOfBeginRefer.length;
    
    NSMutableArray *arrForFiles = [NSMutableArray array];
    
    while ( indexRef <rangeOfEndRefer.location)
    {
        // file name between /* and */
        NSRange beginFile = [data rangeOfData:[@"/* " dataUsingEncoding:NSUTF8StringEncoding] afterIndex:indexRef beforeIndex:rangeOfEndRefer.location];
        
        if (beginFile.location == NSNotFound)
            break;

        NSRange endFile = [data rangeOfData:[@" */" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:indexRef beforeIndex:rangeOfEndRefer.location];
        
        indexRef = endFile.location + endFile.length;
        
        NSRange rangeOfFile = {beginFile.location+beginFile.length,endFile.location-(beginFile.location+beginFile.length)};
        NSString *fileName = [[NSString alloc] initWithData:[data subdataWithRange:rangeOfFile] encoding:NSUTF8StringEncoding];
        
        if([fileName hasSuffix:@".m"] || [fileName hasSuffix:@".mm"] || [fileName hasSuffix:@".cpp"] || [fileName hasSuffix:@".framework"] || [fileName hasSuffix:@".plist"] || [fileName hasSuffix:@".a"])
        {
            // NSLog(@"fileName %@",fileName);
            
            NSRange rangeOfFileId = {beginFile.location-25,24};
            NSString *fileId = [[NSString alloc] initWithData:[data subdataWithRange:rangeOfFileId] encoding:NSUTF8StringEncoding];
            // NSLog(@"id is %@",fileId);
            
            
            //[arrForfileName addObject:fileName];
            NSRange path = [data rangeOfData:pathData afterIndex:endFile.location beforeIndex:rangeOfEndRefer.location];
            
            if (path.location != NSNotFound)
            {
                NSRange endPath = [data rangeOfData:[@";" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:path.location+path.length beforeIndex:rangeOfEndRefer.location];
                if (endPath.location != NSNotFound)
                {
                    NSRange rangeOfPath = {path.location + path.length, endPath.location- (path.location + path.length)};
                    NSString *filePath = [[NSString alloc] initWithData:[data subdataWithRange:rangeOfPath] encoding:NSUTF8StringEncoding];
                    
                    NSString *filePathWithout = [filePath stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    // NSLog(@"file path %@",filePathWithout);
                    
                    NSRange rangeOfsourceTree = [data rangeOfData:sourceTree afterIndex:rangeOfFile.location beforeIndex:rangeOfEndRefer.location];
                    if(rangeOfsourceTree.location != NSNotFound)
                    {
                        NSRange endRangeOfSourceTree = [data rangeOfData:[@";" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:endPath.location+endPath.length beforeIndex:rangeOfEndRefer.location];
                        NSRange soureTreeRange = {rangeOfsourceTree.location+rangeOfsourceTree.length,endRangeOfSourceTree.location -(rangeOfsourceTree.location+rangeOfsourceTree.length)};
                        // update index
                        indexRef = soureTreeRange.location +soureTreeRange.length;
                        
                        NSString *sourceTreeName = [[NSString alloc] initWithData:[data subdataWithRange:soureTreeRange] encoding:NSUTF8StringEncoding];
                        NSString *sourceTreeNameWithout = [sourceTreeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        // NSLog(@"sourece tree %@",sourceTreeNameWithout);
                        
                        if (![sourceTreeNameWithout isEqualToString:@"<absolute>"] && ![sourceTreeNameWithout isEqualToString:@"SDKROOT"]  )
                        {
                            NSArray *arr = @[fileName,filePathWithout,sourceTreeNameWithout,fileId];
                            [arrForFiles addObject:arr];
                            
                        }
                    }
                    
                }
            }
            
        }
    }
    return arrForFiles;
}


- (NSMutableArray *)findGroupsInProj:(NSData *)data
{
    //FMDatabase *db = [FMDatabase databaseWithPath:tablePath];
    
    NSData *pathData = [@"path = " dataUsingEncoding:NSUTF8StringEncoding];
    NSData *sourceTree = [@"sourceTree = " dataUsingEncoding:NSUTF8StringEncoding];
    NSData *pbxGroupBegin = [@"/* Begin PBXGroup section */" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *pbxGroupEnd = [@"/* End PBXGroup section */" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSRange rangeOfGroupBegin = [data rangeOfData:pbxGroupBegin afterIndex:0 beforeIndex:[data length]];
    NSRange rangeOfGroupEnd = [data rangeOfData:pbxGroupEnd afterIndex:rangeOfGroupBegin.location+rangeOfGroupBegin.length beforeIndex:[data length]];

    NSInteger index = rangeOfGroupBegin.location+rangeOfGroupBegin.length;
    NSInteger count = 0;
    NSUInteger tmp = 0;
    NSMutableArray *arrForGroups = [NSMutableArray array];
    
    while (index < rangeOfGroupEnd.location)
    {
        NSRange rangeOfGroupBodyBegin = [data rangeOfData:[@"{" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:index beforeIndex:rangeOfGroupEnd.location];
        
        NSUInteger locationRangeOfGroup = 0;
        if (count == 0)
        {
            locationRangeOfGroup = rangeOfGroupBegin.location+rangeOfGroupBegin.length;
        }
        else
            locationRangeOfGroup = tmp;
        
        NSRange rangeOfGroupNameBefore = [data rangeOfData:[@"/* " dataUsingEncoding:NSUTF8StringEncoding] afterIndex:locationRangeOfGroup beforeIndex:rangeOfGroupBodyBegin.location];
        
        NSString *groupId = nil;
        NSRange rangeOfGroupId = {0,24};
        
        if (rangeOfGroupNameBefore.location != NSNotFound)
        {
            rangeOfGroupId.location = rangeOfGroupNameBefore.location - 25;
        }
        else
        {
            rangeOfGroupId.location = rangeOfGroupBodyBegin.location - 27;
        }
        groupId = [[NSString alloc] initWithData:[data subdataWithRange:rangeOfGroupId] encoding:NSUTF8StringEncoding];
        NSRange rangeOfGroupBodyEnd = [data rangeOfData:[@"};" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:index beforeIndex:rangeOfGroupEnd.location];
        
        tmp = rangeOfGroupBodyEnd.location;
        
        if (rangeOfGroupBodyBegin.location == NSNotFound)
            break;
        //find path and souretree
        NSRange rangeOfPathData = [data rangeOfData:pathData afterIndex:rangeOfGroupId.location+rangeOfGroupId.length beforeIndex:rangeOfGroupBodyEnd.location];
        NSString *pathWithOut = nil;
        if (rangeOfPathData.location != NSNotFound)
        {
            NSRange rangeOfpathAtEnd = [data rangeOfData:[@";" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:rangeOfPathData.location+rangeOfPathData.length beforeIndex:rangeOfGroupBodyEnd.location];
            if (rangeOfpathAtEnd.location != NSNotFound)
            {
                NSRange rangeOfPath = {rangeOfPathData.location+rangeOfPathData.length,rangeOfpathAtEnd.location-(rangeOfPathData.location+rangeOfPathData.length)};
                
                NSString *path = [[NSString alloc] initWithData:[data subdataWithRange:rangeOfPath] encoding:NSUTF8StringEncoding];
                pathWithOut = [path stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                //NSLog(@"path %@",pathWithOut);
            }
        }
        else
        {
            pathWithOut = @"";
            //NSLog(@"path %@",pathWithOut);
        }
        NSRange rangeOfSoureTree = [data rangeOfData:sourceTree afterIndex:rangeOfGroupId.location+rangeOfGroupId.length beforeIndex:rangeOfGroupBodyEnd.location];
        NSString *sourceTreeWithout = nil;
        if (rangeOfSoureTree.location != NSNotFound)
        {
            NSRange rangeOfSourceTreeAtEnd = [data rangeOfData:[@";" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:rangeOfSoureTree.location+rangeOfSoureTree.length beforeIndex:rangeOfGroupBodyEnd.location];
            
            if (rangeOfSourceTreeAtEnd.location != NSNotFound)
            {
                NSRange rangeOfSourceTreeInfo = {rangeOfSoureTree.location+rangeOfSoureTree.length,rangeOfSourceTreeAtEnd.location - (rangeOfSoureTree.location +rangeOfSoureTree.length)};
                NSString *sourceTree = [[NSString alloc] initWithData:[data subdataWithRange:rangeOfSourceTreeInfo] encoding:NSUTF8StringEncoding];
                sourceTreeWithout = [sourceTree stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                // NSLog(@"path %@",sourceTreeWithout);
            }
        }
        else
        {
            sourceTreeWithout = @"";
        }
        //find child
        NSMutableArray *children = [NSMutableArray array];
        NSInteger i = rangeOfGroupBodyBegin.location + rangeOfGroupBodyBegin.length;
        while ( i < rangeOfGroupBodyEnd.location)
        {
            
            NSRange stara = [data rangeOfData:[@"/*" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:i beforeIndex:rangeOfGroupBodyEnd.location];
            if (stara.location == NSNotFound)
                break;
            NSRange starb = [data rangeOfData:[@"*/" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:i beforeIndex:rangeOfGroupBodyEnd.location];
            // NSLog(@"%lu  %lu",stara.location, starb.location);
            NSRange rangeOfChildId = {stara.location-25,24};
            NSString *childId = [[NSString alloc] initWithData:[data subdataWithRange:rangeOfChildId] encoding:NSUTF8StringEncoding];
            
            NSRange string;
            if (stara.location != NSNotFound)
            {
                string.location = stara.location + stara.length +1;
                string.length = starb.location - stara.location - 4;
                
                NSString *stringa = [[NSString alloc] initWithData:[data subdataWithRange:string] encoding:NSUTF8StringEncoding];
                
                //NSLog(@"stringa %@", stringa);
                //only string has suffix .m .mm .cpp .framework .a is valid
                BOOL isFilevalid = !([stringa hasSuffix:@".h"] || [stringa hasSuffix:@".cp"] || [stringa hasSuffix:@".pch"] || [stringa hasSuffix:@".png"] || [stringa hasSuffix:@".dylib"] || [stringa hasSuffix:@".xctest"] || [stringa hasSuffix:@".strings"] || [stringa hasSuffix:@".bundle"] || [stringa hasSuffix:@".nib"] || [stringa hasSuffix:@".app"]);
                
                if(!isFilevalid)
                {
                    stringa = @"";
                }
                if (![stringa isEqualToString:@""])
                {
                    [children addObject:childId];
                    NSArray *arr = @[pathWithOut,sourceTreeWithout,groupId,childId];
                    [arrForGroups addObject:arr];
                }
                i = starb.location+starb.length;
            }
            else
                break;
        }
        
        index = rangeOfGroupBodyEnd.location + rangeOfGroupBodyEnd.length;
        count++;
    }
    return arrForGroups;
}

- (NSString *)findMainGroupIdFrom:(NSData *)data
{
    NSRange main = [data rangeOfData:[@"mainGroup = " dataUsingEncoding:NSUTF8StringEncoding] afterIndex:0 beforeIndex:[data length]];
    NSRange mainEnd = [data rangeOfData:[@";" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:main.location +main.length beforeIndex:[data length]];
    
    NSRange mainInfo ={main.location+main.length, mainEnd.location-(main.location+main.length)};
    
    NSString *mainGroup = [[NSString alloc] initWithData:[data subdataWithRange:mainInfo] encoding:NSUTF8StringEncoding];
    
    NSString *mainGroupName = @"";
    //length of id is 24
    NSRange rangeOfMainGroupId = {0,24};
    
    if ([mainGroup containsString:@"/*"])
    {
        NSRange beginGroupName = [data rangeOfData:[@"/* " dataUsingEncoding:NSUTF8StringEncoding] afterIndex:mainInfo.location beforeIndex:mainInfo.location+mainInfo.length];
        NSRange endGroupName = [data rangeOfData:[@" */" dataUsingEncoding:NSUTF8StringEncoding] afterIndex:mainInfo.location beforeIndex:mainInfo.location+mainInfo.length];
        NSRange rangeOfmainGroupName = {beginGroupName.location+beginGroupName.length, endGroupName.location-(beginGroupName.location+beginGroupName.length)};
        mainGroupName = [[NSString alloc] initWithData:[data subdataWithRange:rangeOfmainGroupName] encoding:NSUTF8StringEncoding];
        rangeOfMainGroupId.location = beginGroupName.location - 25;
    }
    else
    {
        rangeOfMainGroupId.location = main.location +main.length;
    }
    NSString *mainGroupId = [[NSString alloc] initWithData:[data subdataWithRange:rangeOfMainGroupId] encoding:NSUTF8StringEncoding];
    return mainGroupId;
    
}

//-(void)findGroupPathFromTable:(NSString *)tablePath andMainGroupId:(NSString *)mainGroupId
//{
//    FMDatabase *db = [FMDatabase databaseWithPath:tablePath];
//    NSString *mainPath = [self projPath];
//    
//    //i. e. NSString *mainPath = @"/Volumes/Data/webex-mac-client/src/classic_client/as";
//    //NSString *mainGroupName = @"recordplay";
//    NSMutableArray *arrForGroups = [NSMutableArray array];
//    
//    if ([db open])
//    {
//        FMResultSet *set = [db executeQuery:@"select groupId from fileAnalyze"];
//        while ([set next])
//        {
//            if (![arrForGroups containsObject:[set stringForColumn:@"groupId"]])
//            {
//                [arrForGroups addObject:[set stringForColumn:@"groupId"]];
//                
//            }
//            
//        }
//    }
//    [db close];
//    
//    NSMutableDictionary *dicForGroup = [NSMutableDictionary dictionary];
//    if ([db open])
//    {
//        [db beginTransaction];
//        for (NSString *string in arrForGroups)
//        {
//            NSString *path = @"";
//            FMResultSet *re = [db executeQuery:@"select * from fileAnalyze where groupId=?",string];
//            if ([re next])
//            {
//                if (![[re stringForColumn:@"path"] isEqualToString:@""])
//                {
//                    path = [path stringByAppendingFormat:@"%@",[re stringForColumn:@"path"]];
//                }
//                
//            }
//            re = [db executeQuery:@"select * from fileAnalyze where groupId=?",string];
//            
//            if ([[re stringForColumn:@"sourceTree"] isEqualToString:@"SOURCE_ROOT"])
//            {
//                if (![[re stringForColumn:@"path"] isEqualToString:@""])
//                    path = [mainPath stringByAppendingFormat:@"/%@",[re stringForColumn:@"path"]];
//                else
//                    path = mainPath;
//                
//                NSString *absolutePath = [path stringByStandardizingPath];
//                path = absolutePath;
//                
//            }
//            
//            else
//            {
//                FMResultSet *set = [db executeQuery:@"select * from fileAnalyze where childrenId=?",string];
//                if ([set next])
//                {
//                    NSString *groupId= [set stringForColumn:@"groupId"];
//                    
//                    while (![groupId isEqualToString:mainGroupId])
//                    {
//                        if (![[set stringForColumn:@"path"]isEqualToString:@""])
//                        {
//                            if (![path isEqualToString:@""])
//                            {
//                                path =[[set stringForColumn:@"path"] stringByAppendingFormat:@"/%@",path];
//                            }
//                            else
//                                path = [path stringByAppendingFormat:@"%@",[set stringForColumn:@"path"]];
//                        }
//                        
//                        set = [db executeQuery:@"select * from fileAnalyze where childrenId=?",groupId];
//                        
//                        if ([set next])
//                        {
//                            groupId = [set stringForColumn:@"groupId"];
//                        }
//                        else
//                            break;
//                    }
//                    
//                    if (![path isEqualToString:@""])
//                    {
//                        path = [mainPath stringByAppendingFormat:@"/%@",path];
//                    }
//                    else
//                        path = mainPath;
//                    
//                    NSString *absoulutePath = [path stringByStandardizingPath];
//                    path = absoulutePath;
//                    
//                    //NSLog(@"path %li %@",index,path);
//                    [dicForGroup setObject:path forKey:string];
//                    // NSLog(@"path %@",path);
//                    
//                }
//                else
//                {
//                    if (![path isEqualToString:@""])
//                    {
//                        path = [mainPath stringByAppendingFormat:@"/%@",path];
//                    }
//                    else
//                        path = mainPath;
//                    NSString *absoulutePath = [path stringByStandardizingPath];
//                    path = absoulutePath;
//                    //NSLog(@"path %li %@",index,path);
//                    [dicForGroup setObject:path forKey:string];
//                    // NSLog(@"path %@",path);
//                }
//                
//            }
//            
//            
//            //[db executeUpdate:@"alter table fileAnalyze add column absoulutePath text"];
//            
//            // [db executeUpdate:@"update fileAnalyze set path=? where groupName=?",path,string];
//        }
//        // NSLog(@"dic %@",dicForGroup);
//        
//        for (NSString *key in dicForGroup)
//        {
//            [db executeUpdate:@"update fileAnalyze set path=? where groupId=?",[dicForGroup objectForKey:key],key];
//        }
//        [db commit];
//    }
//    [db close];
//    
//}


//- (void)findFilePathIntable:(NSString *)path andMainPath:(NSString *)mainPath
//{
//    FMDatabase *db = [FMDatabase databaseWithPath:path];
//    if ([db open])
//    {
//        FMResultSet *fileset = [db executeQuery:@"select * from file"];
//        while([fileset next])
//        {
//            NSString *path = nil;
//            if ([[fileset stringForColumn:@"sourceTree"]isEqualToString:@"SOURCE_ROOT"] && ![[fileset stringForColumn:@"sourceTree"]isEqualToString:@""] )
//            {
//                path = [ mainPath stringByAppendingFormat:@"/%@",[fileset stringForColumn:@"path"]];
//            }
//            
//            else if ([[fileset stringForColumn:@"fileName"] containsString:@".a"] || [[fileset stringForColumn:@"fileName"] containsString:@".framework"])
//            {
//                path = [fileset stringForColumn:@"fileName"];
//            }
//            
//            else
//            {
//                FMResultSet *fileGroup = [db executeQuery:@"select * from fileAnalyze where childrenId=?",[fileset stringForColumn:@"fileId"]];
//                
//                if ([fileGroup next])
//                {
//                    NSString *groupPath = [fileGroup stringForColumn:@"path"];
//                    path = [groupPath stringByAppendingFormat:@"/%@",[fileset stringForColumn:@"path"]];
//                }
//            }
//            path = [path stringByStandardizingPath];
//            if ([path containsString:@".plist"])
//            {
//                if (![path containsString:@"test"] && ![path containsString:@"Test"])
//                {
//                    [self.plistList addObject:path];
//                }
//            }
//            else
//                [self.projContent addObject:path];
//        }
//        
//    }
//    [db close];
//}


@end
