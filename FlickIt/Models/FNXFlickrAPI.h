//
//  FNXFlickrAPI.h
//  FlickIt
//
//  Created by Bill Weakley on 7/2/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNXPhoto.h"

@interface FNXFlickrAPI : NSObject

#pragma mark - Init Method
-(id)init;

#pragma mark - API Call Methods
-(void) getRecentPhotosWithCallback:(FNXObjectCallback)callback;
-(void) getImageFromPhoto:(FNXPhoto *)photo withSize:(NSString *)size withCallback:(FNXObjectCallback)callback;
-(NSString *) getImageURLForPhoto:(FNXPhoto *)photo withSize:(NSString *)size;
-(void) getCommentsForPhoto:(FNXPhoto *)photo withCallback:(FNXObjectCallback)callback;
-(void) getPhotographerInfoForUser:(NSString *)userId withCallback:(FNXObjectCallback)callback;

@end
