//
//  SummaryTableViewController.h
//  SGExpense
//
//  Created by Hu Jianbo on 17/5/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryTableViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property UIView* pHeaderView;
@property UITextField *pHeaderLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *pPickerYear;
@property UIToolbar *toolBarYear;
@property NSMutableArray * pYearData;
@property int nYear;
@property NSString * pYearString;
@property NSString * pCurrency; 
@property NSDate    *pSelectedDate;
@property float fTotalExpense; 
-(NSString *) formatYearString:(NSDate *) date;
@property  UISwipeGestureRecognizer *swipeRight;
@property  UISwipeGestureRecognizer *swipeLeft;

@end
