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
#import <DropboxSDK/DropboxSDK.h>

@interface MainTableViewController : UITableViewController <UITextFieldDelegate, DBRestClientDelegate>

@property NSMutableArray * pCategory;
@property NSString * pSelectedCategory;
@property NSInteger nMonth;
@property NSInteger nYear;
@property NSString * currency;
@property UIImage * pCategoryImage;
@property UITextField * pHeaderField;
@property UIButton * pButtonExpense; 
@property NSDate    *pSelectedDate;
- (IBAction)backFromSub:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) IBOutlet UIMonthYearPicker *pMonthYearPicker;
-(NSString *) formatMonthString:(NSDate *) date;
-(void) initTableHeader;
-(void) InitGlobalData;
-(void) DownloadData;
@property NSString * m_rev;
@property (nonatomic, strong) DBRestClient *restClient;
@end
