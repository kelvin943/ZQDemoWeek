//
//  PAPlistManager.m
//
//  Created by luochenhao on 10/4/11.
//  Copyright 2011 平安好房. All rights reserved.
//

#import "PAPlistManager.h"

@interface PAPlistManager ()

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) BOOL fromMainBundle;

@end

@implementation PAPlistManager

#pragma mark - Public Methods

- (instancetype)initWithFileName:(NSString *)fileName autoCreate:(BOOL)create {
    if (self = [super init]) {
        
        NSAssert([fileName length] > 0, @"PAPlistManager can NOT be initialized with empty fileName");
        
        self.fileName = fileName;
        self.fromMainBundle = NO;
        
        NSString *plistFilePath = [[self plistPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", self.fileName]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistFilePath]) {
            
            if (create) {
                [[NSFileManager defaultManager] createFileAtPath:plistFilePath contents:nil attributes:nil];
            }
            else {
                plistFilePath = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"plist"];
                self.fromMainBundle = YES;
            }
        }
        
        NSError *error;
        NSData *plistData = [[NSFileManager defaultManager] contentsAtPath:plistFilePath];
        self.listData = [NSPropertyListSerialization propertyListWithData:plistData
                                                                  options:NSPropertyListMutableContainersAndLeaves
                                                                   format:nil
                                                                    error:&error];
    }
    return self;
}

- (BOOL)save {
    NSError *error;
    NSString *plistFilePath = [[self plistPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", self.fileName]];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:self.listData
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                                  options:NSPropertyListMutableContainersAndLeaves
                                                                    error:&error];
    
    if (plistData) {
        [plistData writeToFile:plistFilePath atomically:YES];
        return YES;
    } else {
        NSLog(@"Failed to save %@.plist with errors: \n%@", self.fileName, error);
        return NO;
    }
}

#pragma mark - Private Methods

- (NSString *)applicationSupportDirectory {
    NSString *applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return applicationSupportDirectory;
}

/**
 存放 Plist 文件的目录，不存在会自动创建

 @return /<SANDBOX_dir>/Library/Configure/
 */
- (NSString *)plistPath {
    NSString *baseDir = [self applicationSupportDirectory];
    NSString *subPath = [NSString stringWithFormat:@"Configure/"];
    NSString *plistPath = [baseDir stringByAppendingPathComponent:subPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL exists = [fileManager fileExistsAtPath:plistPath isDirectory:&isDir];
    
    // 不存在，则直接创建；存在但不是目录，先删除再创建
    if (!exists) {
        [fileManager createDirectoryAtPath:plistPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else if (!isDir) {
        [fileManager removeItemAtPath:plistPath error:nil];
        [fileManager createDirectoryAtPath:plistPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return plistPath;
}

@end
