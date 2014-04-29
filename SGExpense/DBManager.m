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
        //[sharedInstance cleanSettings];
        [sharedInstance initDatabase];
        [sharedInstance createCategoryImage];
        [sharedInstance openDatabase];
        //[sharedInstance initEntryDataForTesting];
    }
    return sharedInstance;
}

-(BOOL) openDatabase
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        return true;
    return false;
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
    [self saveImage:pImage directory:@"cfgimg" imgName:@"money.png" overwrite:NO];
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
        "CREATE TABLE entry(entry_id INT AUTO_INCREMENT PRIMARY KEY, category_name VCHAR(256) NOT NULL, value REAL NOT NULL, description VARCHAR(1024) not NULL,  entry_date Date NULL, photo_path VCHAR(256) NULL, repeating Logic NULL);";
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

- (void)saveImage:(UIImage*)image directory:(NSString*)directory imgName:(NSString*)imgName overwrite:(BOOL)overwrite;
{
    if (image != nil)
    {
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString* dataPath = [documentsDirectory stringByAppendingPathComponent:directory];
        NSError *error;
        
        if ([filemgr fileExistsAtPath:dataPath ] == NO)
            [filemgr createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
        
        
        NSString* path = [dataPath stringByAppendingPathComponent:imgName];
       
        if ([filemgr fileExistsAtPath:path ] == NO)
        {
            NSData* data = UIImagePNGRepresentation(image);
            [data writeToFile:path atomically:YES];
        }
        if(overwrite)
        {
            NSData* data = UIImagePNGRepresentation(image);
            [data writeToFile:path atomically:YES];
        }
    }
}

- (UIImage*)loadImage:(NSString*)directory imgName:(NSString*)imgName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* spath = [[documentsDirectory stringByAppendingPathComponent:directory] stringByAppendingPathComponent:imgName];
    UIImage* image = [UIImage imageWithContentsOfFile:spath];
    return image;
}

- (NSMutableArray*)getChildCatetory:(NSString *)parent
{
    //const char *dbpath = [databasePath UTF8String];
    //if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    //{
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
        }
        //sqlite3_close(database);
        return resultArray;
    //}
    //return nil;
}


-(NSInteger) getMaxEntryID
{
    //const char *dbpath = [databasePath UTF8String];
    //if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    //{
        NSInteger nRet = -1;
        NSString *querySQL = [NSString stringWithFormat:@"select max(entry_id) from entry"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                nRet = sqlite3_column_int(statement, 0);
            }
            
           
        }
        sqlite3_reset(statement);
        return nRet;
    //}
    return -1;
}


- (BOOL) saveEntryData:(NSInteger)entry_id category:(NSString*)category value:(float)value
               description:(NSString *)description
              date:(NSDate*)date imgpath:(NSString *)imgpath bRepeat:(BOOL)bRepeat;

{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];

    //const char *dbpath = [databasePath UTF8String];
    //if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into entry (entry_id, category_name,value, description, entry_date, photo_path, repeating) values (%d, \"%@\", %f, \"%@\", \"%@\", \"%@\", %d)", entry_id, category, value, description, formattedDateString, imgpath,  bRepeat];
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
        //sqlite3_close(database);
    }
    return NO;
}

- (BOOL) updateEntryData:(NSInteger)entry_id category:(NSString*)category value:(float)value
           description:(NSString *)description
                  date:(NSDate*)date imgpath:(NSString *)imgpath bRepeat:(BOOL)bRepeat;

{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    //const char *dbpath = [databasePath UTF8String];
    //if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"update entry set category_name = \"%@\",value = %f, description = \"%@\", entry_date = \"%@\", photo_path = \"%@\", repeating = %d where entry_id = %d", category, value, description, formattedDateString, imgpath,  bRepeat, entry_id];
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
        //sqlite3_close(database);
    }
    return NO;
}


-(double) getSummaryCategory:(NSString *)parentcategory year:(NSInteger)year month:(NSInteger)month
{
    NSString *smonth = [NSString stringWithFormat:@"%02d", month];
    
    //SELECT * FROM entry WHERE strftime("%m", `entry_date`) = "04" and category_name = "Home"
    
    double fSummary = 0;
    //const char *dbpath = [databasePath UTF8String];
    //if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"select SUM(value) from entry"];
        NSString *querySQL = [NSString stringWithFormat:@"select SUM(value) from entry where strftime('%@', `entry_date`) = \"%@\" AND strftime('%@', `entry_date`)  = \"%d\" and category_name in (select name from category where parent = (select category_id from category where name = \'%@\')) ", @"%m", smonth,  @"%Y", year, parentcategory];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                fSummary = sqlite3_column_double(statement, 0);
            }
        }
        sqlite3_reset(statement);

        //sqlite3_close(database);
    }
    return  fSummary;
}

-(double) getSummaryLeafCategory:(NSString *)parentcategory year:(NSInteger)year{
    
    //SELECT * FROM entry WHERE strftime("%m", `entry_date`) = "04" and category_name = "Home"
    
    double fSummary = 0;
    const char *dbpath = [databasePath UTF8String];
    //if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"select SUM(value) from entry"];
        NSString *querySQL = [NSString stringWithFormat:@"select SUM(value) from entry where  strftime('%@', `entry_date`)  = \"%d\" AND category_name = \"%@\"",  @"%Y", year, parentcategory];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                fSummary = sqlite3_column_double(statement, 0);
            }
            sqlite3_reset(statement);
        }
        //sqlite3_close(database);
    }
    return  fSummary;
}

-(double) getSummaryLeafCategory:(NSString *)parentcategory year:(NSInteger)year month:(NSInteger)month
{
    NSString *smonth = [NSString stringWithFormat:@"%02d", month];
    
    //SELECT * FROM entry WHERE strftime("%m", `entry_date`) = "04" and category_name = "Home"
    
    double fSummary = 0;
    //const char *dbpath = [databasePath UTF8String];
    //if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
         //NSString *querySQL = [NSString stringWithFormat:@"select SUM(value) from entry"];
       NSString *querySQL = [NSString stringWithFormat:@"select SUM(value) from entry where strftime('%@', `entry_date`) = \"%@\" AND strftime('%@', `entry_date`)  = \"%d\" AND category_name = \"%@\"", @"%m", smonth,  @"%Y", year, parentcategory];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                fSummary = sqlite3_column_double(statement, 0);
            }
        }
        sqlite3_reset(statement);

        //sqlite3_close(database);
    }
    return  fSummary;
}

-(void) getLeafCategory:(NSString *)category leafCategory:(NSMutableArray **)leafCategory
{
    if(*leafCategory == nil)
        *leafCategory = [[NSMutableArray alloc]init];
    NSMutableArray*  pChildArray =[self getChildCatetory:category];
    if([pChildArray count] <=0)
    {
        [*leafCategory addObject:category];
        pChildArray = nil;
    }
    else
    {
        for(NSString * key in pChildArray)
        {
            [self getLeafCategory:key leafCategory:leafCategory];
        }
    }
}

-(double) getRecursiveSummaryCategory:(NSString *)category year:(NSInteger)year
{
    NSMutableArray * pAllLeafs;
    if([category isEqual:@"Income"])
    {
        if(pAllLeafIncome == nil)
        {
            [self getLeafCategory:category leafCategory:&pAllLeafs ];
            pAllLeafIncome = pAllLeafs;
        }else
            pAllLeafs = pAllLeafIncome;
    }else if([category isEqual:@"Expense"])
    {
        if(pAllLeafExpense == nil)
        {
            [self getLeafCategory:category leafCategory:&pAllLeafs];
            pAllLeafExpense = pAllLeafs;
        }else
            pAllLeafs = pAllLeafExpense ;
    }else
        [self getLeafCategory:category leafCategory:&pAllLeafs];
    double fSummary = 0.0;
    for(NSString * leaf in pAllLeafs)
    {
        fSummary += [self getSummaryLeafCategory:leaf year:year];
    }
    pAllLeafs = nil;
    return fSummary;
}

-(double) getRecursiveSummaryCategory:(NSString *)category year:(NSInteger)year month:(NSInteger)month
{
     NSMutableArray * pAllLeafs;
    [self getLeafCategory:category leafCategory:&pAllLeafs];
   
    
    double fSummary = 0.0;
    for(NSString * leaf in pAllLeafs)
    {
        fSummary += [self getSummaryLeafCategory:leaf year:year month:month];
    }
    pAllLeafs = nil; 
    return fSummary;
}

-(NSMutableArray*)getAllEntry:(NSString *)catergory year:(NSInteger)year month:(NSInteger)month
{
    //const char *dbpath = [databasePath UTF8String];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    //if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select entry_id, category_name,value, description, entry_date, photo_path, repeating from entry where category_name=\"%@\" and strftime('%@', `entry_date`) = \"%02ld\" AND strftime('%@', `entry_date`)  = \"%d\" ", catergory, @"%m", (long)month, @"%Y", year];
        const char *query_stmt = [querySQL UTF8String];
               if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSInteger entry_id = sqlite3_column_int(statement, 0);
                NSString *cat_name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                double fAmount = sqlite3_column_double(statement, 2);
                NSString *description = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 3)];
                NSString *entry_date = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *photo_path = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 5)];
                NSInteger repeating = sqlite3_column_int(statement, 6);
             
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSDate *pDate = [dateFormat dateFromString:entry_date];
                
                //UIImage * pImage = nil ;
                //if([photo_path length] > 0) pImage =[self loadImage:@"receipt" imgName:photo_path];
                EntryItem * pNewEntry = [[EntryItem alloc] init:cat_name date:pDate description:description amount:fAmount receipt:nil];
                pNewEntry.entry_id = entry_id;
                pNewEntry.bRepat = repeating > 0;
                pNewEntry.receiptPath = photo_path;
                pNewEntry.receipt = [self loadImage:@"receipts" imgName:photo_path];
                [resultArray addObject:pNewEntry];
            }
        }
        sqlite3_reset(statement);
        //sqlite3_close(database);
    }
    return resultArray;

}

-(void) initEntryDataForTesting
{
    //const char *dbpath = [databasePath UTF8String];
    //if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_insert = "insert into entry (entry_id, category_name,value, description, photo_path, entry_date, repeating) values (0, \"Mortage\", 123.889999, \"expense 1\", \"\", \"2014-04-01\", 0);";
    
        if (sqlite3_exec(database, sql_insert, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to put the data inside the table");
        }
        const char *sql_insert1 = "insert into entry (entry_id, category_name,value, description, photo_path, entry_date,  repeating) values (1, \"Rent\", 123.889999, \"expense 1\", \"\", \"2014-04-01\", 0);";
        
        if (sqlite3_exec(database, sql_insert1, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to put the data inside the table");
        }
        
        const char *sql_insert2 = "insert into entry (entry_id, category_name,value, description, photo_path, entry_date, repeating) values (2, \"Home Improvements\", 123.889999, \"expense 1\", \"\", \"2014-04-01\", 0);";
        
        if (sqlite3_exec(database, sql_insert2, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to put the data inside the table");
        }
        
        const char *sql_insert3 = "insert into entry (entry_id, category_name,value, description, photo_path, entry_date, repeating) values (3, \"Home Repairs\", 123.889999, \"expense 1\", \"\", \"2014-04-01\", 0);";
        
        if (sqlite3_exec(database, sql_insert3, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to put the data inside the table");
        }
        sqlite3_reset(statement);
        //sqlite3_close(database);
    }
    
}

-(BOOL) saveNewEntryData:(EntryItem *)entry
{
    // Object is not a new entry;
    if(entry.entry_id >=0)  return FALSE;
    // Step 1:  Get a new id
    entry.entry_id = [[DBManager getSharedInstance] getMaxEntryID] + 1;
    // Step 2: Save receipt image
    if(entry.receipt != nil)
    {
        entry.receiptPath = [NSString stringWithFormat:@"receipt-%ld.png", entry.entry_id];
        [[DBManager getSharedInstance] saveImage:entry.receipt directory:@"receipts" imgName:entry.receiptPath overwrite:NO];
    }
    if(entry.description == nil || [entry.description length] == 0)
    {
        entry.description = @"";
    }
    // Step 3: enter record in the databse
    [[DBManager getSharedInstance] saveEntryData:entry.entry_id category:entry.categoryName value:entry.fAmountSpent description:entry.description date:entry.entryDate imgpath:entry.receiptPath bRepeat:entry.bRepat];
    return TRUE;
}

-(BOOL) updateEntryData:(EntryItem *) entry
{
    if(entry.receipt != nil)
    {
        entry.receiptPath = [NSString stringWithFormat:@"receipt-%ld.png", entry.entry_id];
        [[DBManager getSharedInstance] saveImage:entry.receipt directory:@"receipts" imgName:entry.receiptPath overwrite:YES];
    }
    if(entry.description == nil || [entry.description length] == 0)
    {
        entry.description = @"";
    }
    
    [[DBManager getSharedInstance] updateEntryData:entry.entry_id category:entry.categoryName value:entry.fAmountSpent description:entry.description date:entry.entryDate imgpath:entry.receiptPath bRepeat:entry.bRepat];
    
    return YES;
}


@end
