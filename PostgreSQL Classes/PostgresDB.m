//
//  Postgres.m
//  OCFWebServer Mac Example
//
//  Created by Ben Gordon on 8/4/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//
//  PostgreSQL Code Modified from: http://macbug.org/macosxsample/postgresql
//

#import "PostgresDB.h"
#import "PostgresError.h"

@implementation PostgresDB
@synthesize headerPG;
@synthesize serverName, databaseName, port, userName, password, lastError;

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        serverName=@"localhost";
        databaseName=@"newDatabaseName";
        port=5432;
    }
    return self;
}

- (instancetype)initWithServerName:(NSString*) sName dbName:(NSString*)dbName port:(NSInteger)prt {
    self = [super init];
    if (self) {
        serverName = sName ? sName : @"localhost";
        databaseName = dbName ? dbName : @"postgres";
        port = prt > 0 ? prt : 5432;
    }
    return self;
}


#pragma mark - Connect
- (void)connect {
    NSString* portS = [NSNumber numberWithInteger:port].stringValue;//Строковое представление порта
    headerPG = PQsetdbLogin(serverName.UTF8String,portS.UTF8String,NULL,NULL,databaseName.UTF8String,
                            userName.UTF8String, password.UTF8String);
    
    BOOL result = [self connected];//Check if it will connect only using the function PQstatus API postreSQL
    if(!result){
        //Error connection
        [self errorPG];
    }
}

- (void)connectToDBwithUser:(NSString*)user password:(NSString*)psw {
    userName = user;
    password = psw;
    [self connect];
}

- (BOOL) connected {
    // return YES if connected
    BOOL result = NO;
    if(headerPG){
        if(PQstatus(headerPG) == CONNECTION_OK)
            result = YES;
    }
    return result;
}


#pragma mark - Error
-(void) errorPG {
    //rise exception with error message postgreSQL
    lastError = [NSString stringWithUTF8String:PQerrorMessage(headerPG)];
    PostgresError* e = [[PostgresError alloc] initWithName:@"PostgreSQLerror" reason:lastError userInfo:nil];
    @throw e;
}


#pragma mark - Dealloc
-(void) dealloc {
    @synchronized(self) {
        if(headerPG) {
            PQfinish(headerPG); // free allocated memory - libpq
        }
    }
}


#pragma mark - IsBusy
- (BOOL)isBusy {
    return PQisBusy(headerPG);
}

@end
