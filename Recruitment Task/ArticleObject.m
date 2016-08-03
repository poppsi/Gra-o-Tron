//
//  ArticleObject.m
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import "ArticleObject.h"

@implementation ArticleObject

//Article initializer.
-(id)initWithJSONData:(NSDictionary *)data {
    self = [super init];
    
    if (self) {
        self.title = [data objectForKey:@"title"];
        self.thumbnail = [data objectForKey:@"thumbnail"];
        self.abstract = [data objectForKey:@"abstract"];
        self.link = [data objectForKey:@"url"];
        self.isFavourite = NO;
    }
    return self;
}

@end
