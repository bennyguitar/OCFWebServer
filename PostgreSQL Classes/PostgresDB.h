//
//  Postgres.h
//  OCFWebServer Mac Example
//
//  Created by Ben Gordon on 8/4/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//
//  PostgreSQL Code Modified from: http://macbug.org/macosxsample/postgresql
//

#import <Foundation/Foundation.h>
#import <libpq-fe.h>

@interface PostgresDB : NSObject {
    NSString* serverName;// server path
    NSString* databaseName;// name of the database
    NSInteger port;//port number to connect to at the server host
    NSString* userName;
    NSString* password;
    PGconn* headerPG;
    NSString* lastError;
}
@property (readonly) PGconn* headerPG;
@property (copy) NSString* serverName;
@property (copy) NSString* databaseName;
@property NSInteger port;
@property (copy) NSString* userName;
@property (copy) NSString* password;
@property (readonly) NSString* lastError;

- (instancetype)initWithServerName:(NSString*) sName dbName:(NSString*)dbName port:(NSInteger)prt;
- (void)connect;
- (void)connectToDBwithUser:(NSString*)user password:(NSString*)psw;
- (BOOL)connected;
- (void)errorPG;
- (BOOL)isBusy;

@end

