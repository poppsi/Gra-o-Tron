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
    
    //Check if favourite.
    if (self.favBool == YES) {
        self.navigationItem.title = [[NSString stringWithString:self.titleString] stringByAppendingString:@" <333"];
    } else if (self.favBool == NO) {
        self.navigationItem.title = [[NSString stringWithString:self.titleString] stringByAppendingString:@" biography"];
    }

    [self.abstractLabel sizeToFit];
    self.abstractLabel.adjustsFontSizeToFitWidth = YES;
    self.abstractLabel.text = self.abstractString;
    
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

- (IBAction)readMoreButton:(UIButton *)sender {

    NSString *preLink = @"http://gameofthrones.wikia.com";
    NSString *finalLink = [preLink stringByAppendingString:self.linkString];
        
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalLink]];
}


@end
