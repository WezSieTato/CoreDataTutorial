//
//  TagTableViewController.m
//  FailedBankCD
//
//  Created by Marcin Stepnowski on 02/12/14.
//  Copyright (c) 2014 weblify. All rights reserved.
//

#import "TagTableViewController.h"
#import "Tag.h"

@interface TagTableViewController () < UIAlertViewDelegate >

@property (nonatomic, strong) NSMutableSet *pickedTags;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TagTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pickedTags = [[NSMutableSet alloc] init];
    // Retrieve all tags
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Error in tag retrieval %@, %@", error, [error userInfo]);
        abort();
    }
    // Each tag attached to the details is included in the array
    NSSet *tags = self.bankDetails.tags;
    for (Tag *tag in tags) {
        [self.pickedTags addObject:tag];
    }
    //
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.bankDetails.tags = self.pickedTags;
    NSError *error = nil;
    if (![self.bankDetails.managedObjectContext save:&error]) {
        NSLog(@"Error in saving tags %@, %@", error, [error userInfo]);
        abort();
    }
}

-(IBAction)addTag {
    UIAlertView *newTagAlert = [[UIAlertView alloc] initWithTitle:@"New tag"
                                                          message:@"Insert new tag name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    newTagAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [newTagAlert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"cancel");
    } else {
        NSString *tagName = [[alertView textFieldAtIndex:0] text];
        Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                 inManagedObjectContext:self.bankDetails.managedObjectContext];
        tag.name = tagName;
        NSError *error = nil;
        if (![tag.managedObjectContext save:&error]) {
            NSLog(@"Core data error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.fetchedResultsController performFetch:&error];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell" forIndexPath:indexPath];
    
    Tag *tag = (Tag *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([self.pickedTags containsObject:tag]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else
        cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = tag.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Tag *tag = (Tag *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell * cell = [self.tableView  cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if ([_pickedTags containsObject:tag]) {
        [_pickedTags removeObject:tag];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [_pickedTags addObject:tag];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag"
                                              inManagedObjectContext:self.bankDetails.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest managedObjectContext:self.bankDetails.managedObjectContext
                                                             sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = aFetchedResultsController;
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _fetchedResultsController;
}

@end
