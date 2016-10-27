//
//  Article+CoreDataProperties.h
//  Gra o Tron
//
//  Created by Filip Olbromski on 25.10.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import "Article+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Article (CoreDataProperties)

+ (NSFetchRequest<Article *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *abstract;
@property (nullable, nonatomic, copy) NSString *thumbnail;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSNumber *isFavourite;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
