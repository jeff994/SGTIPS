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
    NSMutableArray * pAllLeafIncome;
    NSMutableArray * pAllLeafExpense;
    NSMutableArray * pAllConfigFile;
}

+(DBManager *)getSharedInstance;
+(void)clearSharedInstance;
/// ----- Category table handing
// Used to create category of accounts
-(BOOL) createCategory;
// Given the parent name, get all it's child name from the category table
-(NSMutableArray *) getChildCatetory:(NSString*)parent;

- (BOOL) isChildOf:(NSString *)parent child:(NSString *)child;

-(BOOL)createEntryTable;

-(void) SaveConfigFile:(NSString *)config;

-(BOOL) createCategoryImage;

-(NSString *) getDatabasePath;

-(NSString *) getDocumentDirectory;

-(NSMutableArray *)getCfgFilePath;

-(NSMutableArray *)getReceiptFilePath;

-(BOOL) saveNewEntryData:(EntryItem *)entry;

-(BOOL) saveEntryData:(NSInteger)entry_id category:(NSString*)category value:(float)value
               description:(NSString *)description
                  date:(NSDate*)date imgpath:(NSString *)imgpath bRepeat:(BOOL)bRepeat;


- (BOOL) updateEntryData:(NSInteger)entry_id category:(NSString*)category value:(float)value
             description:(NSString *)description
                    date:(NSDate*)date imgpath:(NSString *)imgpath bRepeat:(BOOL)bRepeat;


-(NSString *)saveImage:(UIImage*)image directory:(NSString*)directory imgName:(NSString*)imgName overwrite:(BOOL)overwrite;

-(UIImage * ) loadCfgImage:(NSString*)img;

-(UIImage*)loadImage:(NSString*)directory imgName:(NSString*)imgName;

-(BOOL) cleanSettings;

-(NSInteger) getMaxEntryID;

-(BOOL) initDatabase;

-(void) initEntryDataForTesting;

// Find all data of a particular catergory (leaf category) 
-(NSMutableArray*) getAllEntry:(NSString*)catergory year:(NSInteger)year month:(NSInteger)month;

-(NSMutableArray*)getAllRepeatingEntry:(NSString *)catergory year:(NSInteger)year month:(NSInteger)month;

-(double) getSummaryCategory:(NSString*)category year:(NSInteger)year month:(NSInteger)month;

-(double) getSummaryLeafCategory:(NSString *)parentcategory year:(NSInteger)year month:(NSInteger)month;

-(double) getSummaryLeafCategory:(NSString *)parentcategory year:(NSInteger)year;

-(BOOL) updateEntryData:(EntryItem *) entry;

-(void) getLeafCategory:(NSString *)category leafCategory:(NSMutableArray **)leafCategory;
-(double) getRecursiveSummaryCategory:(NSString *)category year:(NSInteger)year month:(NSInteger)month;

-(double) getRecursiveSummaryCategory:(NSString *)category year:(NSInteger)year;

-( NSMutableArray *) getAllLeaf:(NSString *) category;

@end

