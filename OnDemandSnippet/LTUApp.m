//
//  LTUApp.m
//  OnDemandSnippet
//
//  Created by Fabien on 11/12/14.
//  Copyright (c) 2014 LTU. All rights reserved.
//

#import "LTUApp.h"

@implementation LTUApp

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)sendImageToLTU:(NSString *)imagePath
{
    // On iOS you would get an UIImage from the camera.
//    UIImage * resizedImage = [imageTaken resizedImageWithContentMode:UIViewContentModeScaleAspectFit
//                                                              bounds:CGSizeMake(500.0, 500.0)
//                                                interpolationQuality:0.85];
//    NSData * imageToSend = UIImageJPEGRepresentation(cameraShot, 1.0);

    // On Mac OS X we open an image file.
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithContentsOfFile:imagePath];
    NSData *imageToSend = [imageRep representationUsingType:NSJPEGFileType properties:nil];

    NSString *applicationKey = @""; // Fill in your own application key.
    NSString *ltuUrl = [NSString stringWithFormat:@"https://api.ltu-engine.com/v2/ltuquery/json/SearchImageByUpload?application_key=%@", applicationKey];
    NSMutableURLRequest *ltuRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ltuUrl]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:10.0];
    [ltuRequest setHTTPMethod:@"POST"];

    NSString *boundary = [[NSString alloc] initWithString: [[NSProcessInfo processInfo] globallyUniqueString]];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [ltuRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // Add body
    NSMutableData *postBody = [NSMutableData data];
    // .. image part
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"image_content\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[NSData dataWithData:imageToSend]];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [ltuRequest setHTTPBody:postBody];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:ltuRequest delegate:self];
    
    if (self.connection) {
        NSLog(@"Connection: success.");
    } else {
        NSLog(@"Connection: fail.");
    }
}


#pragma mark - Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [self parseJSONData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"didFinishLoading");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFail");
}


#pragma mark - JSON magic

- (void)parseJSONData:(NSData *)data
{
    NSError * error;
    NSArray * jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                          options:kNilOptions
                                                            error:&error];

    // Process result.
    NSLog(@"%@", jsonArray);
}


@end
