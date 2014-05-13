//
//  DealViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 20/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "DealViewController.h"

@interface DealViewController ()
//@property (strong, nonatomic) IBOutlet UIWebView *pUIWebView;

@end

@implementation DealViewController

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
    [self setTitle:@"Deals"];
    if(self.pUrl != nil )
    {
        NSURL *fullUrl = [NSURL URLWithString:self.pUrl];
        NSURLRequest *httpRequest = [NSURLRequest requestWithURL:fullUrl];
        [self.DealView loadRequest:httpRequest];
        
    }
    
     // Do any additional setup after loading the view.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
