//
//  BankDetailViewController.m
//  FailedBankCD
//
//  Created by Marcin Stepnowski on 01/12/14.
//  Copyright (c) 2014 weblify. All rights reserved.
//

#import "BankDetailViewController.h"
#import "FailedBankDetails.h"

@interface BankDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

-(void)hidePicker;
-(void)showPicker;

@end

@implementation BankDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.bankInfo.name;
    
    // 1 - setting the right button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self action:@selector(saveBankInfo)];
    
    // 2 - setting interaction on date label
    self.dateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *dateTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(dateTapped)];
    [self.dateLabel addGestureRecognizer:dateTapRecognizer];
    // 3 - set date picker handler
    [self.datePicker addTarget:self action:@selector(dateHasChanged:)
         forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // setting values of fields
    self.nameField.text = self.bankInfo.name;
    self.cityField.text = self.bankInfo.city;
    self.zipField.text = [self.bankInfo.details.zip stringValue];
    self.stateField.text = self.bankInfo.state;
    
    self.datePicker.layer.opacity = 0;

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [formatter stringFromDate:self.bankInfo.details.closeDate];
    self.datePicker.date = self.bankInfo.details.closeDate;
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

-(void)saveBankInfo {
    
    self.bankInfo.name = self.nameField.text;
    self.bankInfo.city = self.cityField.text;
    self.bankInfo.details.zip = [NSNumber numberWithInt:[self.zipField.text intValue]];
    self.bankInfo.state = self.stateField.text;
    
    NSError *error;
    if ([self.bankInfo.managedObjectContext hasChanges] && ![self.bankInfo.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)dateTapped {
    [self showPicker];
}

-(void)dateHasChanged:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [formatter stringFromDate:self.datePicker.date];
    
}

-(void)showPicker {
    [self.zipField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.stateField resignFirstResponder];
    [self.cityField resignFirstResponder];
    
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.datePicker.layer.opacity = 1;
    [UIView commitAnimations];
}

-(void)hidePicker {
    [UIView beginAnimations:@"SlideOutPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.datePicker.layer.opacity = 0;
    [UIView commitAnimations];
}

@end
