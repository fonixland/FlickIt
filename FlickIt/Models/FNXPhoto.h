//
//  FNXPhoto.h
//  
//
//  Created by Bill Weakley on 6/30/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNXPhoto : NSObject {
    NSNumber *farm;
    NSNumber *isfamily;
    NSNumber *isfriend;
    NSNumber *ispublic;
    NSString *owner;
    NSString *photoId;
    NSString *secret;
    NSString *server;
    NSString *title;
}

@property (nonatomic, copy) NSNumber *farm;
@property (nonatomic, copy) NSNumber *isfamily;
@property (nonatomic, copy) NSNumber *isfriend;
@property (nonatomic, copy) NSNumber *ispublic;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *title;

+ (FNXPhoto *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
