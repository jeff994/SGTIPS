//
//  MainTableViewController.h
//  SGExpense
//
//  Created by Hu Jianbo on 18/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "UIMonthYearPicker.h"

@interface MainTableViewController : UITableViewController

@property DBManager * pDbManager; // Used to get the database manager
@property NSMutableArray * pCategory;
@property NSString * pSelectedCategory;
@property NSInteger nMonth;
@property NSInteger nYear;
@property NSString * currency;
@property UIImage * pCategoryImage;
- (void) initTableHeader;
@property (strong, nonatomic) IBOutlet UIMonthYearPicker *pMonthYearPicker;

@end
