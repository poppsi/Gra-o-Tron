//
//  MainViewController.h
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "WikiaCommunicator.h"
#import "ArticleObject.h"
#import "Article.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

//Start fetching data method.
-(void)getArticleData;

@end
