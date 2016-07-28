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


@end
