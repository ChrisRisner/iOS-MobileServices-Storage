//
//  ModifyTableRowViewController.m
//  StorageDemo
//
//  Created by Chris Risner on 3/12/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "ModifyTableRowViewController.h"
#import "StorageService.h"

@interface ModifyTableRowViewController ()

@end

@implementation ModifyTableRowViewController

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
    
    
    self.lblPartitionKey.text = self.entity.partitionKey;
    self.lblRowKey.text = self.entity.rowKey;
    
    if (self.entity) {
        [self.viewHeader setHidden:YES];
        self.tableView.tableHeaderView = nil;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedSaveRow:(id)sender {
    //Update entity
    NSArray *cells = [self.tableView visibleCells];
    for (UITableViewCell *cell in cells) {
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        UITextView *txtValue = (UITextView *)[cell viewWithTag:2];
        UITextView *txtKey = (UITextView *)[cell viewWithTag:3];
        //If this is the first insertion from the table, use the textview
        //for key names, otherwise, use the label
        if (self.isEmptyTable) {
            [self.entity setObject:txtValue.text forKey:txtKey.text];
        } else {
            [self.entity setObject:txtValue.text forKey:label.text];
        }
    }
    //send to Mobile Services
    StorageService *storageService = [StorageService getInstance];
    if (self.isNewEntity == YES || self.isEmptyTable == YES) {
        [storageService insertTableRow:[self.entity getNewEntityDictionary] withTableName:self.tableName withCompletion:^{
            [self.navigationController popViewControllerAnimated:YES];
            
            //Posting message to refresh tables
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableRows" object:nil];
        }];
    } else {
    
        [storageService updateTableRow:[self.entity getDictionary] withTableName:self.tableName withCompletion:^{
            [self.navigationController popViewControllerAnimated:YES];
            
            //Posting message to refresh tables
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableRows" object:nil];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"Count: %@", [[self.entity keys] count]);
    return [[self.entity keys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //THIS Works and just shows the row key
    
     static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     
     // Configure the cell...
    UITextField *txtKey = (UITextField *)[cell viewWithTag:3];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = [self.entity.keys objectAtIndex:indexPath.row];
    if (self.isEmptyTable) {
        txtKey.text = label.text;
        if (![label.text isEqualToString:@"PartitionKey"] &&
            ![label.text isEqualToString:@"RowKey"]) {
            [label setHidden:YES];
            [txtKey setHidden:NO];
        }
    }
    
    UITextField *txtValue = (UITextField *)[cell viewWithTag:2];
    if (self.isNewEntity == NO && self.isEmptyTable == NO) {
    txtValue.text = [self.entity objectForKey:label.text];
        if ([label.text isEqualToString:@"PartitionKey"] ||
            [label.text isEqualToString:@"RowKey"]) {
            txtValue.enabled = NO;
            txtValue.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
     return cell;
     
    /*
    static NSString *CellIdentifier = @"Cell";
    
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } else {
        [cell clear];
    }
    // cell = [[EntityTableViewCell alloc] init];
    
    NSDictionary *item = [self.storageService.tableRows objectAtIndex:indexPath.row];
    
    
    WATableEntity *entity = [[WATableEntity alloc] initWithDictionary:[item mutableCopy] fromTable:self.tableName];
    //    [cell setKeysAndObjects:@"PartitionKey", [item objectForKey:@"PartitionKey" ], @"RowKey", [item objectForKey:@"RowKey"], entity, nil];
    [cell setKeysAndObjects:@"PartitionKey", [entity partitionKey], @"RowKey", [entity rowKey], entity, nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;*/
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tappedAdd:(id)sender {
    self.entity = [WATableEntity createEntityForTable:self.tableName];
    [self.tableView reloadData];
    self.tableView.tableHeaderView = nil;
}
@end
