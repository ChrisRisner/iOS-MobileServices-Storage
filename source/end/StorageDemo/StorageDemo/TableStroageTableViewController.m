//
//  TableStroageTableViewController.m
//  StorageDemo
//
//  Created by Chris Risner on 3/12/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "TableStroageTableViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "StorageService.h"
#import "TableRowsTableViewController.h"

@interface TableStroageTableViewController ()

@property (strong, nonatomic) StorageService *storageService;

@end

@implementation TableStroageTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.storageService = [StorageService getInstance];
    
    [self.storageService refreshTablesOnSuccess:^{
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.storageService.tables count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set the label on the cell and make sure the label color is black (in case this cell
    // has been reused and was previously greyed out
//    UILabel *label = (UILabel *)[cell viewWithTag:1];
//    label.textColor = [UIColor blackColor];
    NSDictionary *item = [self.storageService.tables objectAtIndex:indexPath.row];
    //label.text = [item objectForKey:@"TableName"];
    cell.textLabel.text = [item objectForKey:@"TableName"];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTableRows"]) {
        TableRowsTableViewController *vc = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        //UILabel *label = (UILabel *)[cell viewWithTag:1];
        //vc.tableName = label.text;
        vc.tableName = cell.textLabel.text;
        
        //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:vc.tableName style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}

@end
