//
//  EntryItem.m
//  SGExpense
//
//  Created by Hu Jianbo on 22/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "EntryItem.h"
#import "DBManager.h"

@implementation EntryItem
-(BOOL) validEntry
{
    BOOL notValid = TRUE;
    notValid = [self.categoryName length] == 0 || self.fAmountSpent <= 0 || self.entryDate == nil;
    return !notValid;
}

- (id)init:(NSString *)category date:(NSDate *)date description:(NSString *)description amount:(double)amount receipt:(UIImage*)receipt
{
    self = [super init];
    if(self)
    {
        _categoryName = category;
        _entryDate = date;
        _description = description;
        _fAmountSpent = amount;
        _receipt = receipt;
    }
    return self;
}

@end
