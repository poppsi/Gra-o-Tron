//
//  WikiaCommunicator.h
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikiaCommunicator : NSObject

+(void)fetchDataFromWikia:(NSURL *)url withCompletionHandler:(void (^)(NSData *data))completionHandler;

@end
