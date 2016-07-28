//
//  Article+CoreDataProperties.h
//  Recruitment Task
//
//  Created by Filip Olbromski on 27.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Article.h"

NS_ASSUME_NONNULL_BEGIN

@interface Article (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *thumbnail;
@property (nullable, nonatomic, retain) NSString *abstract;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSNumber *isFavourite;

@end

NS_ASSUME_NONNULL_END
