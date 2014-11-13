//
//  main.m
//  OnDemandSnippet
//
//  Created by Fabien on 11/12/14.
//  Copyright (c) 2014 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "LTUApp.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        LTUApp * app = [[LTUApp alloc] init];
        [app sendImageToLTU:@"/path/to/image.jpg"];

        // Put the runLoop on wait to give us time to get the response from the server.
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:30]];
    }
    return 0;
}