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
@property NSString *pMainCat;
@property DBManager * pDbManager; // Used to get the database manager
@property NSArray * pCategory;
@property NSString * pSelectedCategory;

@property NSMutableDictionary *allEntryData;  // Used to hold all entry data

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
- (IBAction)addNewEntry:(UIStoryboardSegue *)segue;

- (void) initEntryData; 

@end
