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

@interface IncomeTableViewController : UITableViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property NSMutableArray * pCategory;
@property NSString * pSelectedCategory;
@property NSString * currency;
@property NSInteger nMonth;
@property NSInteger  nYear;
@property NSString *pDbVersion;
- (IBAction)backFromSub:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) IBOutlet UIMonthYearPicker *pMonthYearPicker;
@property UITextField * pHeaderField;
-(NSString *) formatMonthString:(NSDate *) date;
@property NSDate    *pSelectedDate;
-(void)donePickMonth:(id)sender;
@end
