//
//  PostgresQueryString.h
//  OCFWebServer Mac Example
//
//  Created by Benjamin Gordon on 8/4/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostgresQueryString : NSString

+(NSString *)queryStringWithObject:(id)object parameters:(NSDictionary *)params table:(NSString *)table orderBy:(NSString *)order;
+(NSArray *)propertiesOfObject:(id)object;

@end
