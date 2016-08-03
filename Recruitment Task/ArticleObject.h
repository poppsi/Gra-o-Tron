//
//  ArticleObject.h
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleObject : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *abstract;
@property (strong, nonatomic) NSString *link;
@property (nonatomic) BOOL isFavourite;

-(id)initWithJSONData:(NSDictionary *)data;

@end
