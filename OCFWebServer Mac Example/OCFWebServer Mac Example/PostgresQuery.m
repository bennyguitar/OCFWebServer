//
//  PostgresQuery.m
//  OCFWebServer Mac Example
//
//  Created by Ben Gordon on 8/4/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//
//  PostgreSQL Code Modified from: http://macbug.org/macosxsample/postgresql
//

#import "PostgresQuery.h"
#import "PostgresDB.h"

@implementation PostgresQuery
@synthesize sql, db;

#pragma mark - Init
- (id)initWithDatabase:(PostgresDB *)database {
    self = [super init];
    if (self) {
        db = database;
    }
    return self;
}


#pragma mark - Execute Query
- (void)execQuery {
    if(pgResult) {
        //clearing result before
        PQclear(pgResult);
    }
    
    // Get Result
    pgResult = PQexec(db.headerPG, sql.UTF8String);
    
    // Handle Result
    if(!pgResult) {
        //if it fails to raise an exception
        [db errorPG];
    }
    else{
        ExecStatusType status = PQresultStatus(pgResult);
        if(status == PGRES_BAD_RESPONSE || status == PGRES_NONFATAL_ERROR || status == PGRES_FATAL_ERROR) {
            [db errorPG];
        }
    }
}


#pragma mark - Handle Result
- (NSInteger)recordCount {
    NSInteger result = PQntuples(pgResult);
    return result;
}

- (NSString*)stringValFromRow:(int)row Column:(int)col {
    NSString* ps = [[NSString alloc] initWithUTF8String:PQgetvalue(pgResult,row,col)];
    return ps;
}

- (NSInteger)integerValFromRow:(int)row Column:(int)col {
    return [self stringValFromRow:row Column:col].integerValue;
}

- (double)doubleValFromRow:(int)row Column:(int)col {
    return [self stringValFromRow:row Column:col].doubleValue;
}

- (NSDate*)dateValFromRow:(int)row Column:(int)col {
    NSString* ps = [[NSString alloc] initWithUTF8String:PQgetvalue(pgResult,row,col)];
    NSDateFormatter* df = [[NSDateFormatter alloc] initWithDateFormat:@"yyyy-MM-dd" allowNaturalLanguage:YES];
    return [df dateFromString:ps];
}

- (NSString*) r_escape:(NSString*)s {
    NSInteger len = [s lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSString* result;
    if(len){
        NSInteger l = (len<<1)+1;
        //char toch[l];
        char* to = malloc(l);//toch;
        memset(to, 0, l);
        int err = 0;
        size_t tolen = PQescapeStringConn(db.headerPG, to, s.UTF8String, len,&err);
        if(!err && tolen){
            NSString *SQL = [[NSString alloc]initWithUTF8String: to];
            result = SQL;
        }
        else {
            result = s;
        }

        free(to);
    }
    else {
        result = s;
    }
    
    return result;
}

- (NSString*) r_Descape:(NSData*)da {
    NSUInteger tolen;
    NSUInteger dblen = da.length;
    unsigned char* res = PQescapeByteaConn(db.headerPG,da.bytes,dblen,&tolen);
    NSString* resultS = [[NSString alloc]initWithUTF8String:(const char*)res];
    PQfreemem(res);
    return resultS;
}

- (NSData*) dataValFromRow:(int)row Column:(int)col {
    unsigned char* val1 = (unsigned char*)PQgetvalue(pgResult,row,col);
    size_t tolen;
    unsigned char* res = PQunescapeBytea(val1, &tolen);
    NSData* result = [[NSData dataWithBytes:res length:tolen] copy];
    PQfreemem(res);
    return result;
}

- (int)numFields {
    return PQnfields(pgResult);
}

- (NSString*)fieldName:(int)fieldNum {
    char* resCh = PQfname(pgResult, fieldNum);
    return !resCh ? @"" : [NSString stringWithUTF8String:resCh];
}

- (NSArray*) fieldNames {
    NSMutableArray* result = [NSMutableArray array];
    NSInteger len=PQnfields(pgResult);
    if(len){
        for(NSInteger i=0;i<len;i++){
            [result addObject:[self fieldName:(int)i]];
        }
    }
    return [NSArray arrayWithArray:result];
}


#pragma mark - Memory
- (void)dealloc
{
    if(pgResult) {
        // Clear result
        PQclear(pgResult);
    }
}

@end
