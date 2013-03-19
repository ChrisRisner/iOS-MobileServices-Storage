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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self.navigationItem setTitle:self.tableName];
    self.storageService = [StorageService getInstance];
    //Subscribe to messages to refresh data
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshTableRows" object:nil];
    
    [self refreshData];
}

- (void)refreshData {
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
    static NSString *CellIdentifier = @"Cell";
    EntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[EntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } else {
        [cell clear];
    }
    
    NSDictionary *item = [self.storageService.tableRows objectAtIndex:indexPath.row];
        
    WATableEntity *entity = [[WATableEntity alloc] initWithDictionary:[item mutableCopy] fromTable:self.tableName];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//Set properties on the destination view controller before the segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"modifyTableRow"]) {
        
        ModifyTableRowViewController *vc = segue.destinationViewController;
        
        //Get the indexpath for the selected item because it's not sent into this method
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *item = [self.storageService.tableRows objectAtIndex:indexPath.row];
        WATableEntity *entity = [[WATableEntity alloc] initWithDictionary:[item mutableCopy] fromTable:self.tableName];
        vc.entity = entity;
        vc.tableName = self.tableName;
        vc.isNewEntity = NO;
    } else if ([segue.identifier isEqualToString:@"addTableRow"]) {        
        if (self.storageService.tableRows.count == 0) {
            ModifyTableRowViewController *vc = segue.destinationViewController;
            vc.isEmptyTable = YES;
            vc.tableName = self.tableName;
        } else {        
            NSDictionary *item = [self.storageService.tableRows objectAtIndex:0];                    
            WATableEntity *entity = [[WATableEntity alloc] initWithDictionary:[item mutableCopy] fromTable:self.tableName];
            ModifyTableRowViewController *vc = segue.destinationViewController;
            [entity prepareNewEntity];
            vc.entity = entity;
            vc.tableName = self.tableName;
            vc.isNewEntity = YES;
            vc.isEmptyTable = NO;
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Delete the table row
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *item = [self.storageService.tableRows objectAtIndex:indexPath.row];
        WATableEntity *entity = [[WATableEntity alloc] initWithDictionary:[item mutableCopy] fromTable:self.tableName];
        [self.storageService deleteTableRow:[entity getDictionary] withTableName:self.tableName withCompletion:^{
            [self refreshData];
        }];        
    }
}

@end
