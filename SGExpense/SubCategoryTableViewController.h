//
//  SubCategoryTableViewController.h
//  SGExpense
//
//  Created by Hu Jianbo on 19/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface SubCategoryTableViewController : UITableViewController

// U
@property NSString *pMainCat;
@property DBManager * pDbManager; // Used to get the database manager
@property NSMutableArray * pCategory;
@property NSString * pSelectedCategory;
// Global value from parent 
@property NSString * pCurrency;
@property NSInteger  nMonth;
@property NSInteger  nYear;
@property UIImage * pCatergoryImage;
@property NSMutableDictionary *pAllEntryData;  // Used to hold all entry data
@property UIView* pHeaderView;
@property UITableViewCell * pHeaderCell;
@property UIView * pSeperatorView;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
- (IBAction)addNewEntry:(UIStoryboardSegue *)segue;

- (void) initEntryData;
- (void) initTableHeader;
- (void) initGlobalData;
- (void) reloadTable;
@end
