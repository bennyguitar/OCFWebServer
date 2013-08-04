//
//  PostgresError.h
//  OCFWebServer Mac Example
//
//  Created by Ben Gordon on 8/4/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//
//  PostgreSQL Code Modified from: http://macbug.org/macosxsample/postgresql
//

#import <Foundation/Foundation.h>

@interface PostgresError : NSException

- (void)alertBox;
- (void)alertPanel:(NSWindow*)wnd;

@end
