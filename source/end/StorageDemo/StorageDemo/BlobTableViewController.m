//
//  BlobTableViewController.m
//  StorageDemo
//
//  Created by Chris Risner on 3/18/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "BlobTableViewController.h"
#import "StorageService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "NewBlobViewController.h"
#import "BlobDetailsViewController.h"

@interface BlobTableViewController ()

@property (strong, nonatomic) StorageService *storageService;

@end

@implementation BlobTableViewController

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
    
    //Subscribe to messages to refresh data
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshBlobs" object:nil];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    [self.storageService refreshBlobsOnSuccess:self.containerName withCompletion:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.storageService.blobs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set the label on the cell and make sure the label color is black (in case this cell
    // has been reused and was previously greyed out
    //    UILabel *label = (UILabel *)[cell viewWithTag:1];
    //    label.textColor = [UIColor blackColor];
    NSDictionary *item = [self.storageService.blobs objectAtIndex:indexPath.row];
    //label.text = [item objectForKey:@"TableName"];
    cell.textLabel.text = [item objectForKey:@"name"];
    return cell;

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Delete the container
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *item = [self.storageService.blobs objectAtIndex:indexPath.row];
        NSLog(@"Item: %@", item);
        
        [self.storageService deleteBlob:[item objectForKey:@"name"] fromContainer:self.containerName withCompletion:^{
            [self refreshData];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"createBlob"]) {
        NewBlobViewController *blobVC = segue.destinationViewController;
        //UITableViewCell *cell = (UITableViewCell *)sender;
        blobVC.containerName = self.containerName;
    } else if ([segue.identifier isEqualToString:@"blobDetails"]) {
        BlobDetailsViewController *vc = segue.destinationViewController;
        
        //Get the indexpath for the selected item because it's not sent into this method
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *item = [self.storageService.blobs objectAtIndex:indexPath.row];
        vc.blob = item;
        vc.containerName = self.containerName;
    }
}

@end
