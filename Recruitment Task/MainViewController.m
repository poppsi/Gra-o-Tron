//
//  MainViewController.m
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) NSMutableArray *articlesReceived;

@end

@implementation MainViewController

-(NSMutableArray *)articlesReceived {
    if (!_articlesReceived) {
        _articlesReceived = [[NSMutableArray alloc] init];
    }
    return _articlesReceived;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Game of Thrones character list";
    
    //To register CustomCell from xib file.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //Get article items.
    [self getArticleData];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view protocol methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articlesReceived count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /* General cell setup */
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    //Merging cells tag with its index path value.
    cell.tag = indexPath.row;
    
    ArticleObject *articleItem = [self.articlesReceived objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = articleItem.title;
    cell.abstractLabel.text = articleItem.abstract;
    
    /* Cells thumbnail image setup. */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        //Download images.
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:articleItem.thumbnail]];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        //Back on the main thread with loaded UI elements.
        dispatch_async(dispatch_get_main_queue(), ^{
            //Check if cells tag belongs to that row.
            if (cell.tag == indexPath.row) {
                cell.thumbnailImage.image = image;
            }
        });
    });

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toDetailVC"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ArticleObject *articleData = [self.articlesReceived objectAtIndex:indexPath.row];
        
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.titleString = articleData.title;
        detailVC.abstractString = articleData.abstract;
        detailVC.thumbnailAdress = articleData.thumbnail;
        detailVC.linkString = articleData.link;
    }
}

#pragma mark - Fetch data

-(void)getArticleData {
    NSString *requestURL = [NSString stringWithFormat:@"http://gameofthrones.wikia.com/api/v1/Articles/Top?expand=1&category=Characters&limit=75"];
    
    NSURL *url = [[NSURL alloc] initWithString:requestURL];
    
    [WikiaCommunicator fetchDataFromWikia:url withCompletionHandler:^(NSData *data) {
        if (data !=nil) {
            
            NSError *serializationError;
            
            NSDictionary *objectFromJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];
            NSArray *wikiaResults = [objectFromJSON valueForKey:@"items"];
            NSLog(@"Articles count: %lu", (unsigned long)[wikiaResults count]);
            
            if (serializationError) {
                NSLog(@"Serialization error: %@", [serializationError description]);
            } else {
                for (NSDictionary *articleData in wikiaResults) {
                    ArticleObject *article = [[ArticleObject alloc] initWithJSONData:articleData];
                    [self.articlesReceived addObject:article];
                }
            }
            
            [self.tableView reloadData];
            
        } else {
            
            NSLog(@"No data was fetched");
        }
        
    }];
    
}

@end
