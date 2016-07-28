//
//  WikiaCommunicator.m
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import "WikiaCommunicator.h"

@implementation WikiaCommunicator

//Wikia communicator for fetching Wikia data.

+(void)fetchDataFromWikia:(NSURL *)url withCompletionHandler:(void (^)(NSData *data))completionHandler {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"Session error: %@", [error localizedDescription]);
        } else {
            //To not block UI with loading data.
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(data);
            });
        }
    }];
    //Resume the task.
    [task resume];
}

@end
