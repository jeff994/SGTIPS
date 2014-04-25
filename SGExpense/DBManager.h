//
//  DBManager.h
//  SqlLiteApp
//
//  Created by Hu Jianbo on 1/3/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "EntryItem.h"

@interface DBManager : NSObject
{
    NSString * databasePath;
}
+(DBManager *)getSharedInstance;
/// ----- Category table handing
// Used to create category of accounts
-(BOOL) createCategory;
// Given the parent name, get all it's child name from the category table
-(NSArray *) getChildCatetory:(NSString*)parent;

-(BOOL)createEntryTable;

-(BOOL) createCategoryImage;


-(BOOL) saveNewEntryData:(EntryItem *)entry;

-(BOOL) saveEntryData:(NSInteger)entry_id category:(NSString*)category value:(float)value
               description:(NSString *)description
                  date:(NSDate*)date imgpath:(NSString *)imgpath bRepeat:(BOOL)bRepeat;


- (BOOL) updateEntryData:(NSInteger)entry_id category:(NSString*)category value:(float)value
             description:(NSString *)description
                    date:(NSDate*)date imgpath:(NSString *)imgpath bRepeat:(BOOL)bRepeat;

-(NSArray *) findByRegisterNumber:(NSString *) registerNumber;

-(void)saveImage:(UIImage*)image directory:(NSString*)directory imgName:(NSString*)imgName overwrite:(BOOL)overwrite;

-(UIImage*)loadImage:(NSString*)directory imgName:(NSString*)imgName;

-(BOOL) cleanSettings;

-(NSInteger) getMaxEntryID;

-(BOOL) initDatabase;

-(void) initEntryDataForTesting;

// Find all data of a particular catergory (leaf category) 
-(NSMutableArray*) getAllEntry:(NSString*)catergory year:(NSInteger)year month:(NSInteger)month;

-(double) getSummaryCategory:(NSString*)category year:(NSInteger)year month:(NSInteger)month;

-(BOOL) updateEntryData:(EntryItem *) entry;

@end

