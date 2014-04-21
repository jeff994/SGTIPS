//
//  DBManager.h
//  SqlLiteApp
//
//  Created by Hu Jianbo on 1/3/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

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

- (BOOL) saveEntryData:(NSString*)category value:(float)value
              currency:(NSString*)currency description:(NSString *)description
                  date:(NSString*)date imgpath:(NSString *)imgpath bRepeat:(BOOL)bRepeat;

-(NSArray *) findByRegisterNumber:(NSString *) registerNumber;

-(void)saveImage: (UIImage*)image path:(NSString*)imgName;

-(UIImage*)loadImage:(NSString*)imgName;

-(BOOL) cleanSettings;

-(BOOL) initDatabase;
@end

