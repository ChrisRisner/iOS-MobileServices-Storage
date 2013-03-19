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

#import <UIKit/UIKit.h>
#import "WATableEntity.h"

@interface ModifyTableRowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblPartitionKey;
@property (weak, nonatomic) IBOutlet UILabel *lblRowKey;
- (IBAction)tappedSaveRow:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) WATableEntity *entity;
@property (strong, nonatomic) NSString *tableName;
@property (nonatomic) BOOL isNewEntity;
@property (nonatomic) BOOL isEmptyTable;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
- (IBAction)tappedAdd:(id)sender;

@end
