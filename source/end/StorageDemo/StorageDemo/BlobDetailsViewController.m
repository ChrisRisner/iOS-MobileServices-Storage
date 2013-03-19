//
//  BlobDetailsViewController.m
//  StorageDemo
//
//  Created by Chris Risner on 3/18/13.
//  Copyright (c) 2013 Microsoft DPE. All rights reserved.
//

#import "BlobDetailsViewController.h"
#import "StorageService.h"

@interface BlobDetailsViewController ()

@end

@implementation BlobDetailsViewController

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
    self.lblName.text = [self.blob objectForKey:@"name"];
    self.lblUrl.text = [self.blob objectForKey:@"url"];
    //self.lblProperties.text = [self.blob objectForKey:@"properties"];
    NSString *contentType = [[self.blob objectForKey:@"properties"] objectForKey:@"Content-Type"];
    self.lblContentType.text = contentType;
    
    if ([contentType isEqualToString:@"image/jpeg"]) {
        NSURL *url = [NSURL URLWithString:[self.blob objectForKey:@"url"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];

        self.imageView.image = image;
//        NSLog(@"ImageURL: %@", [self.blob objectForKey:@"url"]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedLoadWithSAS:(id)sender {
    
    StorageService *storageService = [StorageService getInstance];
    [storageService getSasUrlForNewBlob:[self.blob objectForKey:@"name"] forContainer:self.containerName withCompletion:^(NSString *sasUrl) {
        NSURL *url = [NSURL URLWithString:sasUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        self.imageView.image = image;
    }];
}
@end
