//
//  MainViewController.m
//  Recruitment Task
//
//  Created by Filip Olbromski on 25.07.2016.
//  Copyright © 2016 Filip Olbromski. All rights reserved.
//

#define URL @"http://gameofthrones.wikia.com/api/v1/Articles/Top?expand=1&category=Characters&limit=75"

#import "MainViewController.h"
#import "DetailViewController.h"
#import "Article+CoreDataProperties.h"

@interface MainViewController ()

//Expandable cell properties
@property (strong, nonatomic) UILabel *expandedLabel;
@property (nonatomic) NSInteger indexOfCellToExpand;

@property (strong, nonatomic) NSMutableArray *articlesReceived;

@property (strong, nonatomic) NSManagedObjectContext *context;


@end

@implementation MainViewController

-(NSMutableArray *)articlesReceived {
    if (!_articlesReceived) {
        _articlesReceived = [[NSMutableArray alloc] init];
    }
    return _articlesReceived;
}

#pragma mark - View

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.title = @"Game of Thrones character list";
    
    //Fetch article data from Wiki API
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isFetched"] == NO) {
        [self fetchArticleData];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFetched"];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.indexOfCellToExpand = -1;
    
    //To register CustomCell from xib file.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //Load data from Core Data
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view protocol methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articlesReceived count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle = @"";
    
    if (section == 0) {
        headerTitle = @"Articles";
    }
    return headerTitle;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /* General cell setup */
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //Merging cells tag with its index path value.
    cell.tag = indexPath.row;
    cell.abstractLabel.tag = indexPath.row;
    
    /* Cell gesture recognizer setup on abstractLabel */
    UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressGestureHandler:)];
    //Press gesture properties.
    pressGesture.minimumPressDuration = 0.5;
    pressGesture.numberOfTouchesRequired = 1;
    pressGesture.numberOfTapsRequired = 0;
    
    [cell.abstractLabel addGestureRecognizer:pressGesture];
    cell.abstractLabel.userInteractionEnabled = YES;
    
    /* Sections cells setup */
    
    if ([self.articlesReceived count] != 0) {
        if (indexPath.section == 0) {
            Article *articleItem = [self.articlesReceived objectAtIndex:indexPath.row];
            
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
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toDetailVC" sender:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.indexOfCellToExpand) {
        return 230 + self.expandedLabel.frame.size.height - 25.5;
    } else {
        return 230;
    }
}

#pragma mark - Cell gesture recognizer method setup

-(void)pressGestureHandler:(UILongPressGestureRecognizer *)sender {
    
    //Attach pressed label
    UILabel *pressGestureLabel = (UILabel *)sender.view;
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:pressGestureLabel.tag inSection:0];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        Cell *cell = [self.tableView cellForRowAtIndexPath:cellIndexPath];
        Article *article = [self.articlesReceived objectAtIndex:pressGestureLabel.tag];
        
        //Expanded cell properties
        [cell.abstractLabel sizeToFit];
        cell.abstractLabel.text = article.abstract;
        
        self.expandedLabel = cell.abstractLabel;
        self.indexOfCellToExpand = pressGestureLabel.tag;
        
        [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        //Set index initial value
        self.indexOfCellToExpand = -1;
        //Set default row height
        [self.tableView setRowHeight:230];
        //Attach pressed label
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:pressGestureLabel.tag inSection:0];
        //And refresh that row
        [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toDetailVC"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Article *article = [self.articlesReceived objectAtIndex:indexPath.row];
        
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.titleString = article.title;
        detailVC.abstractString = article.abstract;
        detailVC.thumbnailAdress = article.thumbnail;
        detailVC.linkString = article.url;
    }
}


#pragma mark - Fetch data method

-(void)fetchArticleData {
    NSString *requestURL = [NSString stringWithFormat:URL];
    
    NSURL *url = [[NSURL alloc] initWithString:requestURL];
    
    [WikiaCommunicator fetchDataFromWikia:url withCompletionHandler:^(NSData *data) {
        if (data !=nil) {
            
            NSError *serializationError;
            
            NSDictionary *dictionaryOfJSONobjects = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];
            NSArray *wikiaResults = [dictionaryOfJSONobjects valueForKey:@"items"];
            
            if (serializationError) {
                NSLog(@"Serialization error: %@", [serializationError description]);
            } else {
                [self saveData:wikiaResults];
            }
            
            //Fetch to present directly after data is stored and
            [self loadData];
            //refresh when data was loaded succesfully.
            [self.tableView reloadData];
            
        } else {
            
            NSLog(@"No data was fetched");
        }
    }];
}

#pragma mark - Core Data methods

-(void)loadData {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Article"];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.context = [delegate managedObjectContext];
    NSError *error = nil;
    
    self.articlesReceived = [[self.context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSLog(@"Articles rec: %lu", (unsigned long)[self.articlesReceived count]);
}

-(void)saveData:(NSArray *)arrayOfData {
    // To store to Core Data fetched articles
    id delegate = [[UIApplication sharedApplication] delegate];
    self.context = [delegate managedObjectContext];
    NSError *error = nil;
    
    for (NSDictionary *data in arrayOfData) {
        Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:self.context];
        
        //Core Data Article properties.
        article.abstract = [data objectForKey:@"abstract"];
        article.thumbnail = [data objectForKey:@"thumbnail"];
        article.title = [data objectForKey:@"title"];
        article.url = [data objectForKey:@"url"];
        article.isFavourite = [NSNumber numberWithBool:NO];
        
        if (![self.context save:&error]) NSLog(@"(Model) Core Data error: %@", error);
    }

}

@end
