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
