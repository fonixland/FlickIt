//
//  FNXPhoto.m
//  
//
//  Created by Bill Weakley on 6/30/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import "FNXPhoto.h"

@implementation FNXPhoto

+ (FNXPhoto *)instanceFromDictionary:(NSDictionary *)aDictionary
{

    FNXPhoto *instance = [[FNXPhoto alloc] init];
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
        [self setValue:value forKey:@"photoId"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}


- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.farm) {
        [dictionary setObject:self.farm forKey:@"farm"];
    }

    if (self.isfamily) {
        [dictionary setObject:self.isfamily forKey:@"isfamily"];
    }

    if (self.isfriend) {
        [dictionary setObject:self.isfriend forKey:@"isfriend"];
    }

    if (self.ispublic) {
        [dictionary setObject:self.ispublic forKey:@"ispublic"];
    }

    if (self.owner) {
        [dictionary setObject:self.owner forKey:@"owner"];
    }

    if (self.photoId) {
        [dictionary setObject:self.photoId forKey:@"photoId"];
    }

    if (self.secret) {
        [dictionary setObject:self.secret forKey:@"secret"];
    }

    if (self.server) {
        [dictionary setObject:self.server forKey:@"server"];
    }

    if (self.title) {
        [dictionary setObject:self.title forKey:@"title"];
    }

    return dictionary;

}

@end
