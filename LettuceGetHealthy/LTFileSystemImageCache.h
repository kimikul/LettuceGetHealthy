//
//  LTFileSystemImageCache.h
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 2/25/14.
//  Copyright (c) 2014 hsiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTFileSystemImageCache : NSObject

+ (LTFileSystemImageCache *)shared;
- (id)objectForKey:(id)aKey;
- (void)setObject:(id)object forKey:(id)cachedKey;

@end
