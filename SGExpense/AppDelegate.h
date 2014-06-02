//
//  AppDelegate.h
//  SGExpense
//
//  Created by Hu Jianbo on 18/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "MainTableViewController.h"
#import "DealTableViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) ViewController *m_pViewControler;
@property (weak, nonatomic) MainTableViewController *m_pMainViewControler;
@property (weak, nonatomic) DealTableViewController *m_pDealTableController; 
@end
