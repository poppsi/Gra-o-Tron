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
@property (strong, nonatomic) NSMutableArray *articlesFavourite;


@end

@implementation MainViewController

#pragma mark - Data source arrays lazy instantiation

-(NSMutableArray *)articlesReceived {
    if (!_articlesReceived) {
        _articlesReceived = [[NSMutableArray alloc] init];
    }
    return _articlesReceived;
}

-(NSMutableArray *)articlesFavourite {
    if (!_articlesFavourite) {
        _articlesFavourite = [[NSMutableArray alloc] init];
    }
    return _articlesFavourite;
}

#pragma mark - View

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
    NSInteger rowCount = 0;
    
    if (section == 0) rowCount = [self.articlesFavourite count];
    
    if (section == 1) rowCount = [self.articlesReceived count];

    return rowCount;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle = @"";
    
    if (section == 0) headerTitle = @"Favourites";
    
    if (section == 1) headerTitle = @"Articles";
    
    return headerTitle;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /* General cell setup */
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    //CellDelegate data pass.
    cell.delegate = self;
    cell.cellIndexRow = indexPath.row;
    cell.cellIndexSection = indexPath.section;
    
    //Merging cells tag with its index path value.
    cell.tag = indexPath.row;
    
    /* Sections cells setup */

    //favs
    if (indexPath.section == 0) {
        ArticleObject *articleItem = [self.articlesFavourite objectAtIndex:indexPath.row];
        
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
    }
    //recvs
    if (indexPath.section == 1) {
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
    }
    
    return cell;
}


#pragma mark - CellDelegate method

-(void)didClickOnCellAtIndexRow:(NSInteger)cellIndexRow inSection:(NSInteger)cellIndexSection {
    //To recognize cells index path on custom button click.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndexRow inSection:cellIndexSection];
    
    //Reorganize cells: Favourite / Not favourite.
    if (indexPath.section == 0) {
        ArticleObject *articleObject = [self.articlesFavourite objectAtIndex:indexPath.row];
        articleObject.isFavourite = NO;
        [self.articlesFavourite removeObject:articleObject];
        [self.articlesReceived insertObject:articleObject atIndex:0];
    }
    
    if (indexPath.section == 1) {
        ArticleObject *articleObject = [self.articlesReceived objectAtIndex:indexPath.row];
        articleObject.isFavourite = YES;
        [self.articlesReceived removeObject:articleObject];
        [self.articlesFavourite addObject:articleObject];
    }
    
    //Refresh table view.
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toDetailVC"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        if (indexPath.section == 0) {
            //favs
            ArticleObject *articleData = [self.articlesFavourite objectAtIndex:indexPath.row];
            
            DetailViewController *detailVC = segue.destinationViewController;
            detailVC.titleString = articleData.title;
            detailVC.abstractString = articleData.abstract;
            detailVC.thumbnailAdress = articleData.thumbnail;
            detailVC.linkString = articleData.link;
            detailVC.favBool = articleData.isFavourite;
        }
        
        if (indexPath.section == 1) {
            //recvs
            ArticleObject *articleData = [self.articlesReceived objectAtIndex:indexPath.row];
            
            DetailViewController *detailVC = segue.destinationViewController;
            detailVC.titleString = articleData.title;
            detailVC.abstractString = articleData.abstract;
            detailVC.thumbnailAdress = articleData.thumbnail;
            detailVC.linkString = articleData.link;
            detailVC.favBool = articleData.isFavourite;
        }
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
                    ArticleObject *articleObject = [[ArticleObject alloc] initWithJSONData:articleData];
                    [self.articlesReceived addObject:articleObject];
                }
            }
            
            //Refresh when data was loaded succesfully.
            [self.tableView reloadData];
            
        } else {
            
            NSLog(@"No data was fetched");
        }
    }];
}

@end
