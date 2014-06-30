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

-(void) initSwiper
{
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    self.swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    self.swipeRight.delegate = self;
    [self.view addGestureRecognizer:self.swipeRight];
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    self.swipeLeft.delegate = self;
    [self.view addGestureRecognizer:self.swipeLeft];
    [self.pWebView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.swipeRight];
    [self.pWebView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.swipeLeft];
}

- (void)handleSwipeLeft:(UITapGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:@"idbackfromweb" sender:self];
}

- (void)handleSwipeRight:(UITapGestureRecognizer *)recognizer {
    //[self.tabBarController setSelectedIndex:1];
    
    // Insert your own code to handle swipe right
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSwiper];
    [self setTitle:@"Deals"];
    if(self.pUrl != nil )
    {
        NSURL *fullUrl = [NSURL URLWithString:self.pUrl];
        NSURLRequest *httpRequest = [NSURLRequest requestWithURL:fullUrl];
        [self.DealView loadRequest:httpRequest];
    }
    self.DealView.delegate = self;
    
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

 -(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.DealView.canGoBack)
    {
        self.pPreviousPage.enabled = YES;
    }else
    {
        self.pPreviousPage.enabled = NO;
    }
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
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
