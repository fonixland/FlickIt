//
//  FNXComment.m
//  
//
//  Created by Bill Weakley on 7/1/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import "FNXComment.h"

@implementation FNXComment

+ (FNXComment *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    FNXComment *instance = [[FNXComment alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"commentId"];
    } else if ([key isEqualToString:@"_content"]) {
        [self setValue:value forKey:@"content"];
    } else if ([key isEqualToString:@"path_alias"]) {
        [self setValue:value forKey:@"pathAlias"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}


- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.author) {
        [dictionary setObject:self.author forKey:@"author"];
    }

    if (self.authorname) {
        [dictionary setObject:self.authorname forKey:@"authorname"];
    }

    if (self.commentId) {
        [dictionary setObject:self.commentId forKey:@"commentId"];
    }

    if (self.content) {
        [dictionary setObject:self.content forKey:@"content"];
    }

    if (self.datecreate) {
        [dictionary setObject:self.datecreate forKey:@"datecreate"];
    }

    if (self.iconfarm) {
        [dictionary setObject:self.iconfarm forKey:@"iconfarm"];
    }

    if (self.iconserver) {
        [dictionary setObject:self.iconserver forKey:@"iconserver"];
    }

    if (self.pathAlias) {
        [dictionary setObject:self.pathAlias forKey:@"pathAlias"];
    }

    if (self.permalink) {
        [dictionary setObject:self.permalink forKey:@"permalink"];
    }

    if (self.realname) {
        [dictionary setObject:self.realname forKey:@"realname"];
    }

    return dictionary;

}

@end
