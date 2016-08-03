//
//  CustomCell.m
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.abstractLabel.numberOfLines = 2;
    
    //AccessoryButton custom view.
    self.accessoryView = [self favButton];
    
    /* Cell gesture recognizer setup. */
    UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressGestureHandler:)];
    //Press gesture properties.
    pressGesture.minimumPressDuration = 0.5;
    pressGesture.numberOfTouchesRequired = 1;
    pressGesture.numberOfTapsRequired = 0;
    
    [self addGestureRecognizer:pressGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

    /* Cell gesture recognizer method setup. */
-(void)pressGestureHandler:(UILongPressGestureRecognizer *)pressGestureRecognizer {
    if (pressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.abstractLabel.numberOfLines = 0;
    } else if (pressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.abstractLabel.numberOfLines = 2;
    }
}
    /* AccessoryButton custom view and method setup */
-(UIButton *)favButton {
    UIImage *buttonImage = [UIImage imageNamed:@"like.png"];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, buttonImage.size.width/3.5, buttonImage.size.height/3.5);
    
    [self.button setImage:buttonImage forState:UIControlStateNormal];
    
    [self.button addTarget:self action:@selector(didAddToFavourites) forControlEvents:UIControlEventTouchUpInside];
    
    return self.button;
}

-(void)didAddToFavourites {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndexRow:inSection:)]){
        NSLog(@"Cell index row: [%li] and section: [%li]", (long)self.cellIndexRow, (long)self.cellIndexSection);
        [self.delegate didClickOnCellAtIndexRow:self.cellIndexRow inSection:self.cellIndexSection];
    }
}

@end
