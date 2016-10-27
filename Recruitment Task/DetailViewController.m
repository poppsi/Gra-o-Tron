//
//  DetailViewController.m
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    /* Title label setup. */
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.text = self.titleString;
    
    /* Abstract label setup. */
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readMore)];
    [self.abstractLabel addGestureRecognizer:tapGesture];
    [self.abstractLabel setUserInteractionEnabled:YES];
    self.abstractLabel.adjustsFontSizeToFitWidth = YES;
    NSString *abstractFinalText = [self.abstractString stringByAppendingString:@" tap to read more!"];
    self.abstractLabel.text = abstractFinalText;
    
    /* Thumbnail image setup. */
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        //Download images.
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnailAdress]];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        //Back on the main thread with loaded UI elements.
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thumbnailImage.image = image;
        });
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)readMore {
    NSString *preLink = @"http://gameofthrones.wikia.com";
    NSString *finalLink = [preLink stringByAppendingString:self.linkString];
    //Safari
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalLink]];
}


@end
