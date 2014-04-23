//
//  EntryItem.m
//  SGExpense
//
//  Created by Hu Jianbo on 22/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "EntryItem.h"

@implementation EntryItem
-(BOOL) validEntry
{
    BOOL notValid = TRUE;
    notValid = [self.categoryName length] == 0 || self.fAmountSpent <= 0 || self.entryDate == nil;
    return !notValid;
}

@end
