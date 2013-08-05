//
//  PostgresAsyncQuery.m
//  OCFWebServer Mac Example
//
//  Created by Ben Gordon on 8/4/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//
//  PostgreSQL Code Modified from: http://macbug.org/macosxsample/postgresql
//

#import "PostgresAsyncQuery.h"
#import "PostgresDB.h"

@implementation PostgresAsyncQuery

#pragma mark - Execute Query
- (void)execQuery {
    if(pgResult) {
        // clear result before
        PQclear(pgResult);
    }

    if(!PQsendQuery(db.headerPG, sql.UTF8String)) {
        [db errorPG];
    }
}


#pragma mark - Fetch
- (NSInteger)fetch {
    NSInteger result;
    if(pgResult) {
        // clear result before
        PQclear(pgResult);
    }
    
    // Execute Query
    pgResult = PQgetResult(db.headerPG);
    
    // Handle Result
    if (pgResult) {
        ExecStatusType status = PQresultStatus(pgResult);
        if(status == PGRES_BAD_RESPONSE || status == PGRES_NONFATAL_ERROR || status == PGRES_FATAL_ERROR) {
            [db errorPG];
        }
        result = [self recordCount];
    }
    else  {
        result = -1;
    }
    return result;
}

@end
