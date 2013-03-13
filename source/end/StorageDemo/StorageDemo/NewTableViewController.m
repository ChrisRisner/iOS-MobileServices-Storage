//
//  NewTableViewController.m
//  StorageDemo
//
//  Created by Chris Risner on 3/12/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "NewTableViewController.h"
#import "StorageService.h"
#import "TableStroageTableViewController.h";

@interface NewTableViewController ()

@end

@implementation NewTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedCreateTable:(id)sender {
    if ([self.txtTableName.text isEqualToString:@""]) {
        self.txtTableName.backgroundColor = [UIColor redColor];
    } else {
        StorageService *storageService = [StorageService getInstance];
        [storageService createTable:self.txtTableName.text withCompletion:^{
            [self.navigationController popViewControllerAnimated:YES];
            //Posting message to refresh tables
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTables" object:nil];
        }];

    }
    
}
@end
