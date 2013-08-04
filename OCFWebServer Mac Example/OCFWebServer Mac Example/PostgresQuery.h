//
//  PostgresQuery.h
//  OCFWebServer Mac Example
//
//  Created by Ben Gordon on 8/4/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//
//  PostgreSQL Code Modified from: http://macbug.org/macosxsample/postgresql
//

#import <Foundation/Foundation.h>
#import <libpq-fe.h>

@class PostgresDB;

@interface PostgresQuery : NSObject {
    __weak PostgresDB* db;
    NSString* sql;
    PGresult* pgResult; //result of query
}

@property (copy) NSString* sql;
@property (weak) PostgresDB *db;

- (id)initWithDatabase:(PostgresDB *)database;
- (void)execQuery;
- (NSInteger)recordCount;
- (NSString*)stringValFromRow:(int)row Column:(int)col;
- (NSInteger)integerValFromRow:(int)row Column:(int)col;
- (double)doubleValFromRow:(int)row Column:(int)col;
- (NSDate*)dateValFromRow:(int)row Column:(int)col;
- (NSString*) r_escape:(NSString*)s;
- (NSString*) r_Descape:(NSData*)d;
- (NSData*) dataValFromRow:(int)row Column:(int)col;
- (int) numFields;
- (NSString*) fieldName:(int)fieldNum;
- (NSArray*) fieldNames;

@end
