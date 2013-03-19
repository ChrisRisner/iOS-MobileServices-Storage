/*
 Copyright 2013 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

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
    
    NSDictionary *item = [self.storageService.blobs objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"name"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Delete the container
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *item = [self.storageService.blobs objectAtIndex:indexPath.row];
        [self.storageService deleteBlob:[item objectForKey:@"name"] fromContainer:self.containerName withCompletion:^{
            [self refreshData];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //If we're creating a blob, set the container name on the view controller
    if ([segue.identifier isEqualToString:@"createBlob"]) {
        NewBlobViewController *blobVC = segue.destinationViewController;
        blobVC.containerName = self.containerName;
    } else if ([segue.identifier isEqualToString:@"blobDetails"]) {
        //If we're viewing blob details, set the container name and
        //blob on the view controller
        BlobDetailsViewController *vc = segue.destinationViewController;        
        //Get the indexpath for the selected item because it's not sent into this method
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];        
        NSDictionary *item = [self.storageService.blobs objectAtIndex:indexPath.row];
        vc.blob = item;
        vc.containerName = self.containerName;
    }
}

@end
