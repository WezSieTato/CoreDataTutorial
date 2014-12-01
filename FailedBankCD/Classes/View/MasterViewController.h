//
//  MasterViewController.h
//  FailedBankCD
//
//  Created by Marcin Stepnowski on 28/11/14.
//  Copyright (c) 2014 weblify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController

@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
