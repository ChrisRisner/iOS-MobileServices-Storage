//
//  NewBlobViewController.m
//  StorageDemo
//
//  Created by Chris Risner on 3/18/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "NewBlobViewController.h"
#import "StorageService.h"

@interface NewBlobViewController ()

@end

@implementation NewBlobViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedSelectImage:(id)sender {
    if ([self.txtBlobName.text isEqualToString:@""]) {
        self.txtBlobName.backgroundColor = [UIColor redColor];
    } else {
        
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
    
    if ([self.txtBlobName.text isEqualToString:@""]) {
        self.txtBlobName.backgroundColor = [UIColor redColor];
    } else {
        
        StorageService *storageService = [StorageService getInstance];
        [storageService getSasUrlForNewBlob:self.txtBlobName.text forContainer:self.containerName withCompletion:^(NSString *sasUrl) {
            [self postBlobWithUrl:sasUrl];
        }];
        
    }
}

- (void)postBlobWithUrl:(NSString *)sasUrl {
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    
    //PUT
    //ContentType "image/jpeg
    NSLog(@"SASURL: %@", sasUrl);
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
//    NSString* connectionHash = [NSString stringWithFormat:@"%i", connection.hash];
    
    //Pull out the stateobject by the connection's hash
    
    NSString *txt = [[NSString alloc] initWithData:_receivedData                                          encoding: NSASCIIStringEncoding];
    NSLog(@"Response data: %@", txt);
    //Call the callback that was originally sent in for this request
    //connectionState.callbackBlock(txt);
    //[callbacks removeObjectForKey:connectionHash];
    
    [self.navigationController popViewControllerAnimated:YES];
    //Posting message to refresh containers
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBlobs" object:nil];
}

@end
