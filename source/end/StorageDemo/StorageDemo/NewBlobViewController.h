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
