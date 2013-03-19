//
//  ContainerTableViewController.m
//  StorageDemo
//
//  Created by Chris Risner on 3/12/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "ContainerTableViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "StorageService.h"
#import "BlobTableViewController.h"

@interface ContainerTableViewController ()

@property (strong, nonatomic) StorageService *storageService;

@end

@implementation ContainerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.storageService = [StorageService getInstance];
    [self refreshData];

    //Subscribe to messages to refresh data
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshContainers" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) refreshData {
    [self.storageService refreshContainersOnSuccess:^{
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
    return [self.storageService.containers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *item = [self.storageService.containers objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"name"];
    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

//Set the containerName property on the destination view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showBlobs"]) {
        BlobTableViewController *blobVC = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        blobVC.containerName = cell.textLabel.text;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Handle deleting the container
    if (editingStyle == UITableViewCellEditingStyleDelete) {        
        NSDictionary *item = [self.storageService.containers objectAtIndex:indexPath.row];
        [self.storageService deleteContainer:[item objectForKey:@"name"] withCompletion:^{
            [self refreshData];
        }];
    }
}

@end
