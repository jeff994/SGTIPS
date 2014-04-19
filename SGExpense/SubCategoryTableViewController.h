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
@property NSMutableArray * pCategory;
@property NSString * pSelectedCategory;
@end
