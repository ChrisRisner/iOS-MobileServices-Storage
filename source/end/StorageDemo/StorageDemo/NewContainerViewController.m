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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)tappedCreateContainer:(id)sender {
    //Check that the user has entered something for the container name
    if ([self.txtContainerName.text isEqualToString:@""]) {
        self.txtContainerName.backgroundColor = [UIColor redColor];
    } else {
        bool isPublic = NO;
        if ([self.segmentPublic selectedSegmentIndex] == 0)
            isPublic = YES;        
        StorageService *storageService = [StorageService getInstance];
        //Create the new container with the public flag
        [storageService createContainer:self.txtContainerName.text withPublicSetting:isPublic withCompletion:^{
            [self.navigationController popViewControllerAnimated:YES];
            //Posting message to refresh containers
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshContainers" object:nil];
        }];        
    }
}
@end
