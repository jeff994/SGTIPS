//
//  ViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 18/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (IBAction)linkDropBox:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    [[DBAccountManager sharedManager] linkFromController:rootViewController];
    /*
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }else
    {
        [self.pButtonLinkDropbox setTitle:@"Sync" forState:UIControlStateNormal];
        //[self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
    }
     */
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.pCategoryArray objectAtIndex:row];
}

-(void) initCurrency
{
    self.pCategoryArray = [[NSMutableArray alloc]init];
   // NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *Code = [theLocale objectForKey:NSLocaleCurrencyCode];
    self.pCurrency.text = Code;
    theLocale = nil;
    [self.pCurrency setUserInteractionEnabled:NO];
}

- (IBAction)beginSetCurrency:(id)sender {
    self.pPickerCurrency.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pScrollView.layer.borderWidth = 2;
    self.pScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    /*
    if ([[DBSession sharedSession] isLinked])
    {
        [self.pButtonLinkDropbox setTitle:@"Sync" forState:UIControlStateNormal];
    }
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
     */
    [self initCurrency];
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
