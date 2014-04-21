//
//  DBManager.m
//  SqlLiteApp
//
//  Created by Hu Jianbo on 1/3/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "DBManager.h"
static DBManager * sharedInstance = nil;
static sqlite3 * database = nil;
static sqlite3_stmt  * statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance cleanSettings];
        [sharedInstance initDatabase];
        [sharedInstance createCategoryImage];
    }
    return sharedInstance;
}

-(BOOL) initDatabase
{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"account.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        [self createCategory];
        [self createEntryTable];
    }
    return isSuccess;
}

// Clean database and images
-(BOOL)cleanSettings
{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"account.db"]];
    NSError *error;
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:databasePath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:databasePath error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
    return true;
}

-(BOOL)createCategory
{
    BOOL isSuccess = YES;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        char *errMsg;
            // Create table
        const char *sql_stmt =
        "CREATE TABLE category(category_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(20) NOT NULL, parent INT DEFAULT NULL);";
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            isSuccess = NO;
            NSLog(@"Failed to create catetory table");
        }
            
            // Create some initial data inside the table
        if(isSuccess)
        {
            const char *sql_insert = "INSERT INTO category VALUES(0,'ALL',-1), (1,'Income',0), (2,'Expense',0), (3,'Wage',1), (4,'Bonus',1), (5,'Investment',1),(6,'Miscellaneous Income',1), (7,'Home',2), (8,'Utilities',2), (9,'Food',2), (10,'Family',2), (11,'Health and medical',2), (12,'Transportation',2), (13,'Debt Payments',2), (14,'Entertainment',2), (15,'Recreation',2), (16,'Pets',2), (17,'Clothing',2), (18,'Investment and savings',2), (19,'Miscellaneous Expense',2), (20,'Mortage',7), (21,'Rent',7), (22,'Home Improvements',7), (23,'Home Repairs',7), (24,'Electricity and Water',8), (25,'Natural gas',8), (26,'Telephone bill',8), (27,'Groceries',9), (28,'Eating out',9), (29,'Child support',10), (30,'Alimony',10), (31,'Day Care',10), (32,'Babysitting',10), (33,'Insurance',11), (34,'Unreimbursed Medical Expenses',11),(35,'Copays',11),(36,'Fitness',11),(37,'Car payments',12), (38,'Gasoline/Oil',12), (39,'Auto Repairs fees',12), (40,'Auto Insurance',12), (41,'MRT and bus',12),(42,'Taxi',12), (43,'Credit Card Payments',13), (44,'Student loans',13), (45,'Other loans',13), (46,'Cable TV',14), (47,'Computer Expenses',14), (48,'Hobbies',14), (49,'Vacations',15), (50,'Subscription and Dues',15), (51,'Pets food',16), (52,'Pets grooming, boarding, vet',16), (53,'Stocks',18), (54,'Funds',18), (55,'Savings',18), (56,'Emergency fund',18), (57,'Household products',19), (58,'Hongbao',19), (59,'Gifts',19), (60,'Grooming',19), (61,'Other miscellaneous',19);"
                ;
               
            if (sqlite3_exec(database, sql_insert, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to put the data inside the table");
            }
        }
        sqlite3_close(database);
    }
    return  isSuccess;

}

-(BOOL)createCategoryImage // Used to create initial set of category images
{
    // Save all the images to the image table once for all
    // Each category should have an idenpendent images icon
    UIImage * pImage = [UIImage imageNamed:@"money.png"];
    [self saveImage:pImage path:@"money.png"];
    return true;
}

-(BOOL)createEntryTable
{
    BOOL isSuccess = YES;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        char *errMsg;
        // Create table
        const char *sql_stmt =
        "CREATE TABLE entry(category_name VCHAR(256) NOT NULL, value REAL NOT NULL, currency Currency NULL, description VARCHAR(1024) not NULL,  entry_date Date NULL, photo_path VCHAR(256) NULL, Repeating Logic NULL);";
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
            != SQLITE_OK)
        {
            isSuccess = NO;
            NSLog(@"Failed to create entry table");
        }
        
        sqlite3_close(database);
        return  isSuccess;
    }
    else {
        isSuccess = NO;
        NSLog(@"Failed to open/create database");
    }
    return isSuccess;
}

- (void)saveImage: (UIImage*)image path:(NSString*)imgName;
{
    if (image != nil)
    {
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString* dataPath = [documentsDirectory stringByAppendingPathComponent:@"cfgimg"];
        NSError *error;
        
        if ([filemgr fileExistsAtPath:dataPath ] == NO)
            [filemgr createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
        
        
        NSString* path = [dataPath stringByAppendingPathComponent:imgName];
       
        if ([filemgr fileExistsAtPath:path ] == NO)
        {
            NSData* data = UIImagePNGRepresentation(image);
            [data writeToFile:path atomically:YES];
        }
    }
}

- (UIImage*)loadImage:(NSString*)imgName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* spath = [[documentsDirectory stringByAppendingPathComponent:@"cfgimg"] stringByAppendingPathComponent:imgName];
    UIImage* image = [UIImage imageWithContentsOfFile:spath];
    return image;
}

- (NSArray*)getChildCatetory:(NSString *)parent
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select name from category where parent = (select category_id from category where name = \'%@\');", parent];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                
                [resultArray addObject:name];
            }
            sqlite3_reset(statement);
            return resultArray;
        }
    }
    return nil;
}

- (BOOL) saveEntryData:(NSString*)category value:(float)value
              currency:(NSString*)currency description:(NSString *)description
              date:(NSString*)date imgpath:(NSString *)imgpath bRepeat:(BOOL)bRepeat;

{
    NSString *sRepeat =  bRepeat ? @"true" : @"false";
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into entry (category_name,value, currency, description, entry_date, photo_path, Repeating) values (\"%f\",\"%@\", \"%@\", \"%@\", \"%@\")",value, currency, description, date, sRepeat];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
        }
        else {
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (NSArray*) findByRegisterNumber:(NSString*)registerNumber
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select name, department, year from studentsDetail where regno=\"%@\"", registerNumber];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *department = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:department];
                NSString *year = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:year];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}

@end
