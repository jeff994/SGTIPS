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

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

- (BOOL) isEqual:(id)object
{
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    EntryItem * other = object;
    BOOL bRet = YES;
    if(self.description != other.description) return NO;
    if(self.categoryName != other.categoryName) return NO;
    if(self.fAmountSpent != other.fAmountSpent) return NO;
    if(self.bRepat != other.bRepat) return NO;
    if(![self image:self.receipt isEqualTo:other.receipt]) return NO;
    if (![self.entryDate isEqual:other.entryDate]) return NO;
    return bRet;
}
@end
