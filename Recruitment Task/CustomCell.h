//
//  CustomCell.h
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface CustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *abstractLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;

@end
