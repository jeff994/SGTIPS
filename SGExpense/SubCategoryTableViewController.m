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

    NSMutableArray *array = [self.allEntryData objectForKey:pCatName];
    return [array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idSubCategory" forIndexPath:indexPath];
    NSString * pCatName = [_pCategory objectAtIndex:indexPath.section];
    
    NSMutableArray *array = [self.allEntryData objectForKey:pCatName];
    
    EntryItem * pEntry = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = pEntry.description;
    NSString * pDetailed = [NSString stringWithFormat:@"%.2f %@", pEntry.fAmountSpent, pEntry.currency];
    cell.detailTextLabel.text = pDetailed;
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
    NSString * pCatName = pEntryItem.categoryName;
    NSMutableArray *array = [self.allEntryData objectForKey:pCatName];
    [array addObject:pEntryItem];
     [self.tableView reloadData];
    return; 
}

-(void) initEntryData
{
    self.allEntryData = [[NSMutableDictionary alloc] init];
    NSDate *today = [NSDate date];
    EntryItem * pItem1 = [[EntryItem alloc] init:@"Mortage" date:today description:@"Mortage" amount:700.00 receipt:nil];
    EntryItem * pItem2 = [[EntryItem alloc] init:@"Rent" date:today description:@"Rent of hdb" amount:700.00 receipt:nil];
    EntryItem * pItem3 = [[EntryItem alloc] init:@"Home Improvements" date:today description:@"Home improves" amount:700.00 receipt:nil];
    EntryItem * pItem4 = [[EntryItem alloc] init:@"Home Repairs" date:today description:@"Home repair expense" amount:700.00 receipt:nil];
    pItem1.currency = @"S$";
    pItem2.currency = @"S$";
    pItem3.currency = @"S$";
    pItem4.currency = @"S$";
    
    NSMutableArray *itemsArray1 = [[NSMutableArray alloc] initWithObjects:pItem1, nil];
    self.allEntryData = [NSMutableDictionary dictionaryWithObject:itemsArray1 forKey:@"Mortage"];
    
    
    NSMutableArray *itemsArray2 = [[NSMutableArray alloc] initWithObjects:pItem2, nil];
    [self.allEntryData setObject:itemsArray2 forKey:@"Rent"];
    
    NSMutableArray *itemsArray3 = [[ NSMutableArray alloc] initWithObjects:pItem3, nil];
    [self.allEntryData setObject:itemsArray3 forKey:@"Home Improvements"];

    
    NSMutableArray *itemsArray4 = [[ NSMutableArray alloc] initWithObjects:pItem4, nil];
     [self.allEntryData setObject:itemsArray4 forKey:@"Home Repairs"];
    
}


@end
