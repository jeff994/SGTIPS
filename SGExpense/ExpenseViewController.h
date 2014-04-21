//
//  ExpenseViewController.h
//  SGExpense
//
//  Created by Hu Jianbo on 21/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate,  UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *pCategory;
@property (strong, nonatomic)          NSArray *pCategoryArray;
@property (strong, nonatomic) IBOutlet UIPickerView *pCategoryPicker;
@property (strong, nonatomic) IBOutlet UITextField *pEntryDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *pDatePicker;
@property (strong, nonatomic) IBOutlet UIButton *pImageButton;
@property (strong, nonatomic) IBOutlet UIScrollView *pScrollView;

@end
