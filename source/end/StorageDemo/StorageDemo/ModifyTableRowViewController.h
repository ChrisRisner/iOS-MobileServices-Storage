//
//  ModifyTableRowViewController.h
//  StorageDemo
//
//  Created by Chris Risner on 3/12/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WATableEntity.h"

@interface ModifyTableRowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblPartitionKey;
@property (weak, nonatomic) IBOutlet UILabel *lblRowKey;
- (IBAction)tappedSaveRow:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) WATableEntity *entity;
@property (strong, nonatomic) NSString *tableName;

@end
