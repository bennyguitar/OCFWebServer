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

@interface OBCAppDelegate ()
@property (nonatomic, strong) OCFWebServer *server;
@end

@implementation OBCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.server = [OCFWebServer new];
    
    // Add a request handler for every possible GET request
    
    [self.server addDefaultHandlerForMethod:@"GET"
                          requestClass:[OCFWebServerRequest class]
                          processBlock:^void(OCFWebServerRequest *request,
                                             OCFWebServerResponseBlock respondWith) {
                              
                              
                              
                              // TESTING
                              // Create String representation of Query
                              NSString *dictRepresentation = @"";
                              for (NSString *key in request.query.allKeys) {
                                  dictRepresentation = [dictRepresentation stringByAppendingFormat:@"%@:%@  ", key, request.query[key]];
                              }
                              
                              // Create JSON representation of Query
                              NSData *jsonData = [NSJSONSerialization dataWithJSONObject:request.query options:NSJSONWritingPrettyPrinted error:nil];
                              NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                              
                              
                              
                              // Create your response and pass it to respondWith(...)
                              respondWith([OCFWebServerDataResponse responseWithHTML:json]);
                          }];
    
    
    
    
    // Run the server on port 8080
    [self.server startWithPort:6969 bonjourName:nil];
    
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSString *serverURLString = [NSString stringWithFormat:@"http://127.0.0.1:%lu", self.server.port];
    NSURL *URL = [NSURL URLWithString:serverURLString];
    [workspace openURL:URL];
}

@end
