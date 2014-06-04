//
//  DealTableViewController.h
//  SGExpense
//
//  Created by Hu Jianbo on 10/5/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealTableViewController : UITableViewController
@property   NSMutableArray *pAllDeals;
@property UITextField * pHeaderField;
-(void) loadDeals;
- (void) initTableHeader;

@end

