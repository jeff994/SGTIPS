//
//  SummaryViewController.h
//  SGExpense
//
//  Created by Hu Jianbo on 26/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMonthYearPicker.h"

@interface SummaryViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate, UITabBarControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *pViewSummary;
@property (strong, nonatomic) IBOutlet UIView *pSeperate1View;
@property (strong, nonatomic) IBOutlet UIView *pSeperate2View;
@property (strong, nonatomic) IBOutlet UITextField *pMonthYearField;
@property (strong, nonatomic) IBOutlet UIView *pHeaderView;
@property (strong, nonatomic) IBOutlet UITextField *pMonthYearSelect;
@property (strong, nonatomic) IBOutlet UIPickerView *pPickerSelectYearMonth;
@property (strong, nonatomic)          NSArray      *pCategoryArray;
@property (strong, nonatomic) IBOutlet UIMonthYearPicker *pPickerMonthAndYear;
@property (strong, nonatomic) IBOutlet UIPickerView *pPickerYear;
@property                               NSMutableArray * pYearData;
@property (strong, nonatomic) IBOutlet UILabel *pIncomeTotalField;
@property (strong, nonatomic) IBOutlet UILabel *pExpenseTotalField;
@property (strong, nonatomic) IBOutlet UILabel *pRemainingField;
// Currently supports summary by year or by month
@property NSInteger nSummaryType;
@property NSInteger nYear;
@property NSInteger nMonth;
@property NSString *currency;
@property NSDate    *pSelectedDate;
@property double    fTotalExepnse;
@property double    fTotalIncome;
-(void) configMonthYearSelector;
-(void) configYearPicker;
@property UIToolbar *toolBarYear;
-(NSString *) formatMonthString:(NSDate *) date;
-(NSString *) formatYearString:(NSDate *) date;
-(void) doneSelectYear:(id)sender;
-(void) prepareSummaryData;

@end
