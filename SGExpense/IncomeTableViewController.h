//
//  IncomeTableViewController.h
//  SGExpense
//
//  Created by Hu Jianbo on 19/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "UIMonthYearPicker.h"

@interface IncomeTableViewController : UITableViewController

@property DBManager * pDbManager; // Used to get the database manager
@property NSMutableArray * pCategory;
@property NSString * pSelectedCategory;
@property NSString * currency;
@property NSInteger nMonth;
@property NSInteger  nYear;
- (IBAction)backFromSub:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) IBOutlet UIMonthYearPicker *pMonthYearPicker;
@property UITextField * pHeaderField;
-(NSString *) formatMonthString:(NSDate *) date;
-(void)donePickMonth:(id)sender;
@end
