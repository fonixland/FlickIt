//
//  FNXImageCache.m
//  FlickIt
//
//  Created by Bill Weakley on 7/2/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import "FNXImageCache.h"

@implementation FNXImageCache

static FNXImageCache* sharedImageCache = nil;

+(FNXImageCache *)sharedImageCache {
    @synchronized([FNXImageCache class]) {
        if (!sharedImageCache)
            sharedImageCache= [[self alloc] init];
        return sharedImageCache;
    }

    return nil;
}

+(id)alloc {
    @synchronized([FNXImageCache class]) {
        sharedImageCache = [super alloc];
        return sharedImageCache;
    }
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        _imgCache = [[NSCache alloc] init];
    }
    return self;
}

-(void)addImage:(UIImage *)image forURL:(NSString *)imageURL {
    [_imgCache setObject:image forKey:imageURL];
}

-(UIImage*)getImageForURL:(NSString *)imageURL {
    return [_imgCache objectForKey:imageURL];
}

-(BOOL)isCached:(NSString *)imageURL {
    if ([_imgCache objectForKey:imageURL] == nil){
        return false;
    }

    return true;
}


@end
