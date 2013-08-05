//
//  OBCAppDelegate.m
//  OCFWebServer Mac Example
//
//  Created by cmk on 8/3/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//

#import "OBCAppDelegate.h"
#import "OCFWebServer.h"
#import "Postgres.h"

#define DB_NAME @""
#define DB_SERVER @""
#define DB_USER @""
#define DB_PASS @""
#define DB_PORT 5432

@interface OBCAppDelegate ()
@property (nonatomic, strong) OCFWebServer *server;
@end

@implementation OBCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.server = [OCFWebServer new];
    
    // Add a request handler for every possible GET request
    
    __weak typeof(self) weakSelf = self;
    
    [self.server addDefaultHandlerForMethod:@"GET" requestClass:[OCFWebServerRequest class] processBlock:^void(OCFWebServerRequest *request,OCFWebServerResponseBlock respondWith) {
        // Make Query
        __block NSArray *results;
        [weakSelf queryForObject:nil parameters:request.query table:@"test" orderBy:@"id" success:^(NSArray *rows){
            results = rows;
        } failure:^{
            respondWith([OCFWebServerDataResponse responseWithHTML:@"Error."]);
        }];
        
        // Create JSON response
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        // Create your response and pass it to respondWith(...)
        respondWith([OCFWebServerDataResponse responseWithHTML:jsonString]);
        
    }];
    
    
    /*
    // TESTING VARIOUS REQUESTS
    [self.server addHandlerForMethod:@"GET"
                           path:@"/"
                   requestClass:[OCFWebServerRequest class]
                   processBlock:^void(OCFWebServerRequest* request,
                                      OCFWebServerResponseBlock respondWith) {
                       
                       NSString* html = @"<html><body> \
                       <form name=\"input\" action=\"/\" \
                       method=\"post\" enctype=\"application/x-www-form-urlencoded\"> \
                       Value: <input type=\"text\" name=\"value\"> \
                       <input type=\"submit\" value=\"Submit\"> \
                       </form> \
                       </body></html>";
                       
                       respondWith([OCFWebServerDataResponse responseWithHTML:html]);
                   }];
    
    [self.server addHandlerForMethod:@"POST"
                           path:@"/"
                   requestClass:[OCFWebServerURLEncodedFormRequest class]
                   processBlock:^void(OCFWebServerRequest* request,
                                      OCFWebServerResponseBlock respondWith) {
                       
                       NSString *value = [(OCFWebServerURLEncodedFormRequest*)request arguments][@"value"];
                       NSString* html = [NSString stringWithFormat:@"<p>%@</p>", value];
                       
                       respondWith([OCFWebServerDataResponse responseWithHTML:html]);
                   }];
    */
    
    // Run the server on port 8080
    [self.server startWithPort:6969 bonjourName:nil];
    
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSString *serverURLString = [NSString stringWithFormat:@"http://127.0.0.1:%lu", self.server.port];
    NSURL *URL = [NSURL URLWithString:serverURLString];
    [workspace openURL:URL];
}

-(void)queryForObject:(id)object parameters:(NSDictionary *)params table:(NSString *)table orderBy:(NSString *)order success:(QuerySuccess)success failure:(QueryFailure)failure {
    // Create DB
    PostgresDB *db = [[PostgresDB alloc] initWithServerName:DB_SERVER dbName:DB_NAME port:DB_PORT];
    
    // Try Query
    @try {
        // Connect
        [db connectToDBwithUser:DB_USER password:DB_PASS];
        
        // Make Query
        PostgresQuery *query = [[PostgresQuery alloc] initWithDatabase:db];
        query.sql = [PostgresQueryString queryStringWithObject:object parameters:params table:table orderBy:order];
        [query execQuery];
        
        // Handle Query
        NSMutableArray *rows = [NSMutableArray array];
        NSArray *propArray = [PostgresQueryString propertiesOfObject:object];
        for (int xx = 0; xx < query.recordCount; xx++) {
            NSMutableDictionary *rowDict = [NSMutableDictionary dictionary];
            for (int yy = 0; yy < propArray.count; yy++) {
                [rowDict setObject:[query stringValFromRow:xx Column:yy] forKey:propArray[yy]];
            }
            [rows addObject:rowDict];
        }
        
        // Success Block
        success(rows);
    }
    @catch (PostgresError *error) {
        [error alertBox];
        failure();
    }
}


@end
