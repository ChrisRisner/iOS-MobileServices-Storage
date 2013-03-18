//
//  NewContainerViewController.m
//  StorageDemo
//
//  Created by Chris Risner on 3/18/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "NewContainerViewController.h"
#import "StorageService.h"

@interface NewContainerViewController ()

@end

@implementation NewContainerViewController

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

- (IBAction)tappedCreateContainer:(id)sender {
    if ([self.txtContainerName.text isEqualToString:@""]) {
        self.txtContainerName.backgroundColor = [UIColor redColor];
    } else {
        bool isPublic = NO;
        if ([self.segmentPublic selectedSegmentIndex] == 0)
            isPublic = YES;
        
        StorageService *storageService = [StorageService getInstance];
        [storageService createContainer:self.txtContainerName.text withPublicSetting:isPublic withCompletion:^{
            [self.navigationController popViewControllerAnimated:YES];
            //Posting message to refresh containers
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshContainers" object:nil];
        }];
        
    }
}
@end
