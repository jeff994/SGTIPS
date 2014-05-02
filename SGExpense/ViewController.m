//
//  ViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 18/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "ViewController.h"
#import <DropboxSDK/DropboxSDK.h>


@interface ViewController ()

@end

@implementation ViewController

- (IBAction)linkDropBox:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }else
    {
        [self.pButtonLinkDropbox setTitle:@"Sync" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pScrollView.layer.borderWidth = 2;
    self.pScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    if ([[DBSession sharedSession] isLinked])
    {
        [self.pButtonLinkDropbox setTitle:@"Sync" forState:UIControlStateNormal];
    }
    //[self.pScrollView setContentOffset:CGPointMake(0, 100) animated:YES];
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

@end
