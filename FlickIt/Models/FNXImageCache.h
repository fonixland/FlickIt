//
//  FNXImageCache.h
//  FlickIt
//
//  Created by Bill Weakley on 7/2/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNXImageCache : NSObject

@property (nonatomic, retain) NSCache *imgCache;

+(FNXImageCache*) sharedImageCache;
-(void) addImage:(UIImage *)image forURL:(NSString *)imageURL;
-(UIImage*) getImageForURL:(NSString *)imageURL;
-(BOOL) isCached:(NSString *)imageURL;

@end
