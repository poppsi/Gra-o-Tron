//
//  Article+CoreDataProperties.m
//  Gra o Tron
//
//  Created by Filip Olbromski on 25.10.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import "Article+CoreDataProperties.h"

@implementation Article (CoreDataProperties)

+ (NSFetchRequest<Article *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Article"];
}

@dynamic abstract;
@dynamic thumbnail;
@dynamic title;
@dynamic isFavourite;
@dynamic url;

@end
