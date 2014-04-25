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

@interface MainTableViewController : UITableViewController <UITextFieldDelegate>

@property DBManager * pDbManager; // Used to get the database manager
@property NSMutableArray * pCategory;
@property NSString * pSelectedCategory;
@property NSInteger nMonth;
@property NSInteger nYear;
@property NSString * currency;
@property UIImage * pCategoryImage;
@property UITextField * pHeaderField;
- (IBAction)backFromSub:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) IBOutlet UIMonthYearPicker *pMonthYearPicker;
-(NSString *) formatMonthString:(NSDate *) date;
-(void) initTableHeader;
-(void) InitGlobalData;
@end
