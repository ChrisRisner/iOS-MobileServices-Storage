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

#import "NewTableViewController.h"
#import "StorageService.h"
#import "TableStorageTableViewController.h"

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
