//
//  PostgresQueryString.m
//  OCFWebServer Mac Example
//
//  Created by Benjamin Gordon on 8/4/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//

#import "PostgresQueryString.h"
#import <objc/runtime.h>

@implementation PostgresQueryString


+(NSString *)queryStringWithObject:(id)object parameters:(NSDictionary *)params table:(NSString *)table orderBy:(NSString *)order {
    NSString *properties = [PostgresQueryString propertyStringOfObject:object];
    NSString *parameters = [PostgresQueryString parameterStringFromDictionary:params];
    
    return [NSString stringWithFormat:@"select%@from %@%@ order by %@", properties, table,parameters,order];
}

+(NSString *)propertyStringOfObject:(NSObject *)object {
    NSString *propertyString = @" ";
    if (object) {
        unsigned count;
        objc_property_t *properties = class_copyPropertyList([object class], &count);
        
        for (int i = 0; i < count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            propertyString = [propertyString stringByAppendingFormat:@"'%@'%@", key, (i < count - 1 ? @"," : @" ")];
        }
        
        free(properties);
    }
    else {
        propertyString = @" * ";
    }
    return propertyString;
}

+(NSArray *)propertiesOfObject:(id)object {
    NSMutableArray *props = [NSMutableArray array];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [props addObject:key];
    }
    
    free(properties);
    return props;
}

+(NSString *)parameterStringFromDictionary:(NSDictionary *)dict {
    NSString *paramString = @"";
    if (dict) {
        paramString = @" where ";
        for (int i = 0; i < dict.allKeys.count; i++) {
            NSString *key = dict.allKeys[i];
            BOOL isNumber = [dict[key] intValue] || [key isEqualToString:@"0"];
            NSString *formatValue = isNumber ? dict[key] : [NSString stringWithFormat:@"'%@'", dict[key]];
            paramString = [paramString stringByAppendingFormat:@"\"%@\"=%@%@", key, formatValue, (i < dict.allKeys.count - 1 ? @" and " : @"")];
        }
    }
    
    return paramString;
}

@end
