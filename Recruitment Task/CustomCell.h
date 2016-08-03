//
//  CustomCell.h
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>
@required

-(void)didClickOnCellAtIndexRow:(NSInteger)cellIndexRow inSection:(NSInteger)cellIndexSection;

@end

@interface CustomCell : UITableViewCell
//CellDelegate properties.
@property (strong, nonatomic) id <CellDelegate> delegate;
@property (nonatomic) NSInteger cellIndexRow;
@property (nonatomic) NSInteger cellIndexSection;
//CustomCell properties.
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *abstractLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;

@property (strong, nonatomic) UIButton *button;
-(void)didAddToFavourites;

@end
