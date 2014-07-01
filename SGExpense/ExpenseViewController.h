//
//  ExpenseViewController.h
//  SGExpense
//
//  Created by Hu Jianbo on 21/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryItem.h"

@interface ExpenseViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate,  UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *pLabelDate;
@property (strong, nonatomic) IBOutlet UILabel *pLabelAmount;
@property (strong, nonatomic) IBOutlet UILabel *pLabelCategory;
@property (strong, nonatomic) IBOutlet UISwitch     *repeatSwitch;
@property (strong, nonatomic) IBOutlet UILabel      *currencyLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property                               NSString    *pMainCategoryName;
@property (strong, nonatomic) IBOutlet UITextField  *pCategory;
@property (strong, nonatomic)          NSArray      *pCategoryArray;
@property (strong, nonatomic) IBOutlet UIPickerView *pCategoryPicker;
@property (strong, nonatomic) IBOutlet UITextField  *pEntryDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *pDatePicker;
@property (strong, nonatomic) IBOutlet UIButton     *pImageButton;
@property (strong, nonatomic) IBOutlet UIScrollView *pScrollView;
@property (strong, nonatomic) IBOutlet UITextField  *pDescriptionField;
@property (strong, nonatomic) IBOutlet UITextField  *pAmountField;
@property                               EntryItem   *pEntry;
@property                               EntryItem   *pOldEntry;
@property                               NSInteger   categoryRow;
@property                               NSString    *currency;
@property                               NSInteger   nMonth;
@property                               NSInteger   nYear;

@property  UISwipeGestureRecognizer *swipeRight;
@property  UISwipeGestureRecognizer *swipeLeft;

-(void) initCategoryPicker;
-(void) initDatePicker;
-(void) initAmountField;
-(void) initReciptButton; 
-(void) takePhoto;
-(void) initEntryData;
-(void) initUIData;
-(NSDate*) getFirstDateMonth:(NSInteger)nMonth;
-(NSDate*) getLastDateMonth:(NSInteger)nMonth;
 @end


