//
//  LTFileSystemImageCache.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 2/25/14.
//  Copyright (c) 2014 hsiao. All rights reserved.
//

#import "LTFileSystemImageCache.h"

UIKIT_STATIC_INLINE NSURL *LTImageCacheDirectory(void) {
    static NSURL *directoryURL = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSURL *documentsDirURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                                         inDomains:NSUserDomainMask] objectAtIndex:0];
        directoryURL = [documentsDirURL URLByAppendingPathComponent:@"_profPic_cache" isDirectory:YES];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:@(NO)
                                                               forKey:NSFileAppendOnly];
        
        NSError *creationError = nil;
        BOOL createdDirectory = [[NSFileManager defaultManager] createDirectoryAtURL:directoryURL
                                                         withIntermediateDirectories:NO
                                                                          attributes:attributes
                                                                               error:&creationError];
        if(!createdDirectory) {
            NSLog(@"[ERROR]: Could not create directory at path: %@", directoryURL);
            NSLog(@"Details: %@", creationError);
        }
    });
    
    return directoryURL;
}

UIKIT_STATIC_INLINE NSString *BIFileSystemCacheFileNameWithURLString(NSURL *URL) {
    NSString *host = [URL host];
    NSArray *pathComponents = [URL pathComponents];
    pathComponents = [pathComponents subarrayWithRange:NSMakeRange(1, [pathComponents count] - 1)];
    return [host stringByAppendingFormat:@"_%@", [pathComponents componentsJoinedByString:@"_"]];
}

@interface LTFileSystemImageCache ()
@end

@implementation LTFileSystemImageCache

static LTFileSystemImageCache *shared = nil;
static dispatch_once_t onceToken;

+ (LTFileSystemImageCache *)shared {
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (NSURL *)cacheURLForKey:(id)key {
    if([key isKindOfClass:[NSString class]]) key = [NSURL URLWithString:key];
    if(key) {
        NSString *realFileName = BIFileSystemCacheFileNameWithURLString(key);
        if(realFileName) return [LTImageCacheDirectory() URLByAppendingPathComponent:realFileName];
    }
    
    return nil;
}

- (void)setObject:(id)object forKey:(id)cachedKey {
    if(!cachedKey) return;
    
    NSData *data = nil;
    if([object isKindOfClass:[NSData class]]) {
        data = object;
    } else if([object isKindOfClass:[UIImage class]]) {
        data = UIImagePNGRepresentation((UIImage *)object);
    } else {
        return;
    }
    
    NSURL *cacheURL = [self cacheURLForKey:cachedKey];
    NSLog(@"[%@] -> Writing image to filesystem path %@", NSStringFromClass([self class]), cacheURL);
    
    NSError *error = nil;
    BOOL succeeded = [data writeToURL:cacheURL
                              options:NSDataWritingAtomic | NSDataWritingFileProtectionNone
                                error:&error];
    
    if(!succeeded) {
        NSLog(@"[%@] -> Couldn't save image data! ----> %@", NSStringFromClass([self class]), error);
    }
}

- (id)objectForKey:(id)aKey {
    NSURL *URL = [self cacheURLForKey:aKey];
    if(!URL) return nil;
    
    id object = [UIImage imageWithData:[NSData dataWithContentsOfURL:URL]];
    
    return object;
}

@end
