//
//  SubCategoryTableViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 19/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "SubCategoryTableViewController.h"
#import "ExpenseViewController.h"
#import "EntryItem.h"

@interface SubCategoryTableViewController ()

@end

@implementation SubCategoryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:_pMainCat];
    [self initEntryData];
    self.pDbManager = [DBManager getSharedInstance];
    
    self.pCategory = [_pDbManager getChildCatetory:_pMainCat];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.pCategory count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return  [_pCategory objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * pCatName = [_pCategory objectAtIndex:section];
    
    NSDictionary *dictionary = [self.allEntryData objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:pCatName];
    return [array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idSubCategory" forIndexPath:indexPath];
    NSString * pCatName = [_pCategory objectAtIndex:indexPath.section];
    
    NSDictionary *dictionary = [self.allEntryData objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:pCatName];
    
    EntryItem * pEntry = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = pEntry.description;
    UIImage * pImage = [_pDbManager loadImage:@"money.png"];
    cell.imageView.image = pImage;
    
    
    
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    self.pSelectedCategory = [_pCategory objectAtIndex:ip.row];
    
    if([segue.identifier isEqualToString:@"idNewEntry"])
    {
        ExpenseViewController* dest = (ExpenseViewController*)segue.destinationViewController;
        dest.pMainCategoryName = self.pMainCat;
        dest.pCategoryArray = [NSArray arrayWithArray:self.pCategory];
        self.pSelectedCategory = nil;
    }
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)addNewEntry:(UIStoryboardSegue *)segue
{
    ExpenseViewController *pSource = [segue sourceViewController];
    EntryItem * pEntryItem = pSource.pEntry;
    return; 
}

-(void) initEntryData
{
    self.allEntryData = [[NSMutableArray alloc] init];
    NSDate *today = [NSDate date];
    EntryItem * pItem1 = [[EntryItem alloc] init:@"Mortage" date:today description:@"Rent of hdb" amount:700.00 receipt:nil];
    EntryItem * pItem2 = [[EntryItem alloc] init:@"Rent" date:today description:@"Rent of hdb" amount:700.00 receipt:nil];
    EntryItem * pItem3 = [[EntryItem alloc] init:@"Home Improvements" date:today description:@"Rent of hdb" amount:700.00 receipt:nil];
    EntryItem * pItem4 = [[EntryItem alloc] init:@"Home Repairs" date:today description:@"Rent of hdb" amount:700.00 receipt:nil];
    
    NSArray *itemsArray1 = [[NSArray alloc] initWithObjects:pItem1, nil];
    NSDictionary *itemsArrayDict1 = [NSDictionary dictionaryWithObject:itemsArray1 forKey:@"Mortage"];
    [self.allEntryData addObject:itemsArrayDict1];
    
    
    NSArray *itemsArray2 = [[NSArray alloc] initWithObjects:pItem2, nil];
    NSDictionary *itemsArrayDict2 = [NSDictionary dictionaryWithObject:itemsArray2 forKey:@"Rent"];
    [self.allEntryData addObject:itemsArrayDict2];
    
    NSArray *itemsArray3 = [[NSArray alloc] initWithObjects:pItem3, nil];
    NSDictionary *itemsArrayDict3 = [NSDictionary dictionaryWithObject:itemsArray3 forKey:@"Home Improvements"];
    [self.allEntryData addObject:itemsArrayDict3];
    
    NSArray *itemsArray4 = [[NSArray alloc] initWithObjects:pItem4, nil];
    NSDictionary *itemsArrayDict4 = [NSDictionary dictionaryWithObject:itemsArray4 forKey:@"Home Repairs"];
    [self.allEntryData addObject:itemsArrayDict4];

}


@end
