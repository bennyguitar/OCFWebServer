//
//  OBCAppDelegate.h
//  OCFWebServer Mac Example
//
//  Created by cmk on 8/3/13.
//  Copyright (c) 2013 Objective-Cloud.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OBCAppDelegate : NSObject <NSApplicationDelegate>

typedef void (^QuerySuccess) (NSArray *queryRows);
typedef void (^QueryFailure) ();

@property (assign) IBOutlet NSWindow *window;

@end
