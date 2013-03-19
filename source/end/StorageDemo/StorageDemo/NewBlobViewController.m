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

#import "NewBlobViewController.h"
#import "StorageService.h"

@interface NewBlobViewController ()

@end

@implementation NewBlobViewController

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

- (IBAction)tappedSelectImage:(id)sender {
    //Check that they have entered a name for the blob
    if ([self.txtBlobName.text isEqualToString:@""]) {
        self.txtBlobName.backgroundColor = [UIColor redColor];
    } else {
        //Allow the user to select an image from the gallery
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    self.imageView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
    self.btnCreateBlobWithSAS.enabled = YES;
}

- (IBAction)tappedCreateBlobWithSAS:(id)sender {
    //Check that they have entered a blob name
    if ([self.txtBlobName.text isEqualToString:@""]) {
        self.txtBlobName.backgroundColor = [UIColor redColor];
    } else {
        //Get a SAS and then post the image to it
        StorageService *storageService = [StorageService getInstance];
        [storageService getSasUrlForNewBlob:self.txtBlobName.text forContainer:self.containerName withCompletion:^(NSString *sasUrl) {
            [self postBlobWithUrl:sasUrl];
        }];
        
    }
}

//Handle doing the post to the SAS URL to save the object into blob storage
- (void)postBlobWithUrl:(NSString *)sasUrl {
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sasUrl]];
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:imageData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _receivedData = [[NSMutableData alloc] init];
    [_receivedData setLength:0];
}

//Hides keyboard on return
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma NSUrlConnectionDelegate Methods

-(void)connection:(NSConnection*)conn didReceiveResponse:
(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] >= 400) {
        NSLog(@"Status Code: %i", [httpResponse statusCode]);
        NSLog(@"Remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    }
    else {
        NSLog(@"Safe Response Code: %i", [httpResponse statusCode]);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:
(NSData *)data
{
    [_receivedData appendData:data];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:
(NSError *)error
{
    //We should do something more with the error handling here
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:
           NSURLErrorFailingURLStringErrorKey]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSString *txt = [[NSString alloc] initWithData:_receivedData                                          encoding: NSASCIIStringEncoding];
    //pop the current view
    [self.navigationController popViewControllerAnimated:YES];
    //Posting message to refresh containers
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBlobs" object:nil];
}

@end
