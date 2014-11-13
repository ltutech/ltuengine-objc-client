//
//  LTUApp.h
//  OnDemandSnippet
//
//  Created by Fabien on 11/12/14.
//  Copyright (c) 2014 LTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface LTUApp : NSObject

@property (strong) NSURLConnection *connection;

- (instancetype)init;

- (void)sendImageToLTU:(NSString *)imagePath;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (void)parseJSONData:(NSData *)data;

@end
