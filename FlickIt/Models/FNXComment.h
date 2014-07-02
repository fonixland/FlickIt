//
//  FNXComment.h
//  
//
//  Created by Bill Weakley on 7/1/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNXComment : NSObject {}

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorname;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *datecreate;
@property (nonatomic, copy) NSNumber *iconfarm;
@property (nonatomic, copy) id iconserver;
@property (nonatomic, copy) NSString *pathAlias;
@property (nonatomic, copy) NSString *permalink;
@property (nonatomic, copy) NSString *realname;

+ (FNXComment *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
