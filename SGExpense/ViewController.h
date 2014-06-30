//
//  ViewController.h
//  SGExpense
//
//  Created by Hu Jianbo on 18/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface ViewController : UIViewController <DBRestClientDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *pHeaderView;
@property (strong, nonatomic) IBOutlet UITextField *pCurrency;
@property (strong, nonatomic) IBOutlet UIButton *pCurrencyField;
@property (strong, nonatomic) IBOutlet UIScrollView *pScrollView;
@property (strong, nonatomic) IBOutlet UIButton *pButtonLinkDropbox;
@property (nonatomic, strong) DBRestClient *restClient;
@property NSMutableArray* pCategoryArray;
@property NSMutableDictionary *pMetadataDictionary;
@property NSMutableDictionary *pUploadingDictationary; 
-(void) initCurrency;
-(void) saveDBFile;
-(void) saveCfgFile;
-(void) saveReceiptFile;
-(void) loadDBFile;
-(void) LoadCFGFile;
-(void) uploadData;
-(void) loadReceiptFile;
@property  UISwipeGestureRecognizer *swipeRight;
@property  UISwipeGestureRecognizer *swipeLeft;
 @end
