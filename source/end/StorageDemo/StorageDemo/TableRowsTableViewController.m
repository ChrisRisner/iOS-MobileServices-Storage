//
//  TableRowsTableViewController.m
//  StorageDemo
//
//  Created by Chris Risner on 3/12/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "TableRowsTableViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "StorageService.h"
#import "EntityTableViewCell.h"
#import "WATableEntity.h"
#import "ModifyTableRowViewController.h"

@interface TableRowsTableViewController ()

@property (strong, nonatomic) StorageService *storageService;

@end

@implementation TableRowsTableViewController

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
    
    [self.navigationItem setTitle:self.tableName];
    
    self.storageService = [StorageService getInstance];
    
    [self.storageService refreshTableRowsOnSuccess:self.tableName withCompletion:^{
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
    return [self.storageService.tableRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //THIS Works and just shows the row key
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *item = [self.storageService.tableRows objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"RowKey"];
    
    return cell;
     */
    
    static NSString *CellIdentifier = @"Cell";
    
//    EntityTableViewCell *cell = (EntityTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[EntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    EntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[EntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [self.storageService.tableRows objectAtIndex:indexPath.row];
    WATableEntity *entity = [[WATableEntity alloc] initWithDictionary:[item mutableCopy] fromTable:self.tableName];
    int count = entity.keys.count + 2;
    return 12 + count * 25;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    if ([segue.identifier isEqualToString:@"modifyTableRow"]) {
        
        ModifyTableRowViewController *vc = segue.destinationViewController;
        
        //Get the indexpath for the selected item because it's not sent into this method
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *item = [self.storageService.tableRows objectAtIndex:indexPath.row];
        
        
        WATableEntity *entity = [[WATableEntity alloc] initWithDictionary:[item mutableCopy] fromTable:self.tableName];
        
        //UITableViewCell *cell = (UITableViewCell *)sender;
        //UILabel *label = (UILabel *)[cell viewWithTag:1];
        //vc.tableName = label.text;
        //vc.tableName = cell.textLabel.text;
        vc.entity = entity;
        vc.tableName = self.tableName;
        vc.isNewEntity = NO;
        
        //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:vc.tableName style:UIBarButtonItemStylePlain target:nil action:nil];
    } else if ([segue.identifier isEqualToString:@"addTableRow"]) {
        
        if (self.storageService.tableRows.count == 0) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                      message:@"We're not able to add entities to an empty table yet."
                      delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
            [message show];
        } else {
        
            NSDictionary *item = [self.storageService.tableRows objectAtIndex:0];
            
            
            WATableEntity *entity = [[WATableEntity alloc] initWithDictionary:[item mutableCopy] fromTable:self.tableName];
            ModifyTableRowViewController *vc = segue.destinationViewController;
            [entity prepareNewEntity];
            vc.entity = entity;
            vc.tableName = self.tableName;
            vc.isNewEntity = YES;
        }
    }
}

@end
