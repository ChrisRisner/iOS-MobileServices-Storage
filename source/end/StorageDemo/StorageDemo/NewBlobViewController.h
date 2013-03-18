//
//  NewBlobViewController.h
//  StorageDemo
//
//  Created by Chris Risner on 3/18/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewBlobViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate, NSURLConnectionDelegate>{
    NSMutableData* _receivedData;
}
@property (strong, nonatomic) NSString* containerName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateBlob;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateBlobWithSAS;
@property (weak, nonatomic) IBOutlet UITextField *txtBlobName;

- (IBAction)tappedSelectImage:(id)sender;
- (IBAction)tappedCreateBlobWithSAS:(id)sender;


@end
