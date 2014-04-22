//
//  EntryItem.h
//  SGExpense
//
//  Created by Hu Jianbo on 22/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <Foundation/Foundation.h>

// Used to hold entry data

@interface EntryItem : NSObject
    @property NSDate    * entryDate;            // Hold entry date of the record
    @property NSString  * description;   
    @property NSString  * categoryName;
    @property double    fAmountSpentT;
    @property int       nIndexRecord;
    @property UIImage   * receipt;          // Recipt should be Loaded/Saved from receipt path
    @property NSString  * receiptPath;
    @property NSString  * currency;
@end
