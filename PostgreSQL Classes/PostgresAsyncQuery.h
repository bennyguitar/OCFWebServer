//
//  PostgresAsyncQuery.h
//  OCFWebServer Mac Example
//
//  Created by Ben Gordon on 8/4/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//
//  PostgreSQL Code Modified from: http://macbug.org/macosxsample/postgresql
//

#import "PostgresQuery.h"

@interface PostgresAsyncQuery : PostgresQuery

- (NSInteger)fetch; // return number of records in  the intermediate result, or -1 if query the end

@end
