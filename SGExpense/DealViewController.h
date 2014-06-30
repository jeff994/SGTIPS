//
//  DealViewController.h
//  SGExpense
//
//  Created by Hu Jianbo on 20/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealViewController : UIViewController<UIWebViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *DealView;
@property (strong, nonatomic) IBOutlet UIWebView *pWebView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *pPreviousPage;
@property NSString * pUrl;
@property  UISwipeGestureRecognizer *swipeRight;
@property  UISwipeGestureRecognizer *swipeLeft;
@end
