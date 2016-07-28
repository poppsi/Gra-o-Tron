//
//  DetailViewController.h
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

//@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *abstractLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *abstractString;
@property (strong, nonatomic) NSString *thumbnailAdress;
@property (strong, nonatomic) NSString *linkString;

- (IBAction)readMoreButton:(UIButton *)sender;

@end
