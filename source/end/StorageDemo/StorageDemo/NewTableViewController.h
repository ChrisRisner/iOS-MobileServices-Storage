//
//  NewTableViewController.h
//  StorageDemo
//
//  Created by Chris Risner on 3/12/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTableViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *lblTableName;
- (IBAction)tappedCreateTable:(id)sender;

@end
