//
//  PostgresError.m
//  OCFWebServer Mac Example
//
//  Created by Ben Gordon on 8/4/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//
//  PostgreSQL Code Modified from: http://macbug.org/macosxsample/postgresql
//

#import "PostgresError.h"

@implementation PostgresError

- (void)alertBox {
    NSAlert* alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:self.name];
    [alert setInformativeText:self.reason];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert runModal];
}

- (void)alertPanel:(NSWindow*)wnd {
    NSBeginAlertSheet(self.name, @"OK", nil, nil, wnd, nil, nil, nil, nil, @"%@", self.reason);
}

@end
