//
//  SearchViewController.m
//  FailedBankCD
//
//  Created by Marcin Stepnowski on 02/12/14.
//  Copyright (c) 2014 weblify. All rights reserved.
//

#import "SearchViewController.h"
#import "FailedBankDetails.h"
#import "FailedBankInfo.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (nonatomic,retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *tView;
@property (nonatomic, strong) IBOutlet UILabel *noResultsLabel;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error in search %@, %@", error, [error userInfo]);
    } else {
        [self.tView reloadData];
        [self.searchBar resignFirstResponder];
        [_noResultsLabel setHidden:_fetchedResultsController.fetchedObjects.count > 0];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    
}

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    FailedBankInfo *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
                                 info.city, info.state];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(NSFetchedResultsController *)fetchedResultsController {
    // Create fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FailedBankInfo"
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"details.closeDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    // Create predicate
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name CONTAINS %@", self.searchBar.text];
    [fetchRequest setPredicate:pred];
    // Create fetched results controller
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil]; // better to not use cache
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

@end
