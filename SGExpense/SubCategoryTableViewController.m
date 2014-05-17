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

- (void) initTableHeader
{
    self.pHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
    self.pHeaderView.backgroundColor = [UIColor clearColor];
    NSString *CellIdentifier = @"HeaderCell";
    self.pHeaderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    self.pHeaderCell.backgroundColor = [UIColor clearColor];
    
    double fSummary = 0.0;
    
    for (NSString* key in self.pAllEntryData) {
         NSMutableArray *array  = [self.pAllEntryData objectForKey:key];
        for (EntryItem * pItem in array) {
            fSummary += pItem.fAmountSpent;
        }
        // do stuff
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSArray * monthnames =[df monthSymbols];
    NSString *monthName = [monthnames objectAtIndex:(self.nMonth-1)];

    self.pHeaderCell.textLabel.text = [NSString stringWithFormat:@"%@ %ld", monthName, (long)self.nYear];
    NSString *summary = [NSString stringWithFormat:@"Total: %@%.2f", self.pCurrency, fSummary];
    self.pHeaderCell.detailTextLabel.text = summary;
    self.pHeaderCell.imageView.image = self.pCatergoryImage;
    [self.pHeaderView addSubview:self.pHeaderCell];
    self.tableView.tableHeaderView = self.pHeaderView;
    
    // Add a seperator in the view
    CGRect sepFrame = CGRectMake(0, self.pHeaderView.frame.size.height-10, 320, 1);
    self.pSeperatorView = [[UIView alloc] initWithFrame:sepFrame];
    self.pSeperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
    [self.pHeaderView addSubview:self.pSeperatorView];

    
    monthName =  nil;
    monthnames = nil;
    summary = nil;
    df = nil;
    CellIdentifier = nil;
}

-(void)dealloc {
    // Releaase memory here
    self.pCategory = nil;
    self.pCatergoryImage = nil;
    self.pCurrency = nil;
    self.pDbManager = nil;
    self.pMainCat = nil;
    self.pAllEntryData = nil;
    self.pSelectedCategory = nil;
    self.pHeaderView = nil;
    self.pHeaderCell = nil;
    return;
}

-(void) initGlobalData
{
    [self setTitle:_pMainCat];
    self.pDbManager = [DBManager getSharedInstance];
    self.pCategory = [_pDbManager getChildCatetory:_pMainCat];
    if([self.pCategory count] == 0)
    {
        [self.pCategory addObject:_pMainCat];
    }
    
    self.pCatergoryImage = [_pDbManager loadCfgImage:self.pMainCat];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGlobalData];
    [self initEntryData];
    self.tableView.layer.cornerRadius = 5;
    [self initTableHeader];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
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
    return [_pCategory objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * pCatName = [_pCategory objectAtIndex:section];
    NSMutableArray *array = [self.pAllEntryData objectForKey:pCatName];
    NSInteger nRows = [array count];
    array = nil;
    pCatName = nil;
    return nRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString * pCatName = [_pCategory objectAtIndex:section];
    NSMutableArray *array = [self.pAllEntryData objectForKey:pCatName];
    double fSummary = 0.0;
    for (EntryItem * pItem in array) {
        fSummary += pItem.fAmountSpent;
    }
    
    array = nil;
    pCatName = nil;
    
    if(fSummary > 0)
    {
        NSString *summary = [NSString stringWithFormat:@"Subotal: %@%.2f", self.pCurrency, fSummary];
        return summary;
    }else
        return @"Subotal:$0.00";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idSubCategory" forIndexPath:indexPath];
    NSString * pCatName = [_pCategory objectAtIndex:indexPath.section];
    
    NSMutableArray *array = [self.pAllEntryData objectForKey:pCatName];
    
    EntryItem * pEntry = [array objectAtIndex:indexPath.row];
    if([pEntry.description length] <= 0)
    {
        long nRowIndex = indexPath.row + 1;
        cell.textLabel.text = [NSString stringWithFormat:@"***%@ %ld***", pCatName, nRowIndex];
    }else
        cell.textLabel.text = pEntry.description;
    NSString * pDetailed = [NSString stringWithFormat:@" %@%.2f",self.pCurrency, pEntry.fAmountSpent];
    cell.detailTextLabel.text = pDetailed;
    if(pEntry.receipt == nil)
        cell.imageView.image = [UIImage imageNamed:@"Default.jpg"];
    else
        cell.imageView.image = pEntry.receipt;
    // Clear memoery
    pCatName = nil;
    array = nil;
    pEntry = nil;
    pDetailed = nil;
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(void) reloadTable
{
    self.tableView.tableHeaderView = nil;
    [self initTableHeader];
    [self.tableView reloadData];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // perform the deletion here
        NSString * pCatName = [_pCategory objectAtIndex:indexPath.section];
        NSMutableArray *array = [self.pAllEntryData objectForKey:pCatName];
        [array removeObjectAtIndex:indexPath.row];
        [self reloadTable];
        array = nil;
        pCatName = nil;
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    //[self.tableView setEditing:YES animated:YES];

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
   
        return UITableViewCellEditingStyleDelete;
}

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
    if([segue.identifier isEqualToString:@"idNewEntry"])
    {
        self.pSelectedCategory = [_pCategory objectAtIndex:ip.section];
        ExpenseViewController* dest = (ExpenseViewController*)segue.destinationViewController;
        dest.nMonth = self.nMonth;
        dest.nYear = self.nYear;
        dest.currency = self.pCurrency;
        dest.pMainCategoryName = self.pMainCat;
        dest.pCategoryArray = [NSArray arrayWithArray:self.pCategory];
        self.pSelectedCategory = nil;
    }
    if([segue.identifier isEqualToString:@"idEditEntry"])
    {
        self.pSelectedCategory = [_pCategory objectAtIndex:ip.section];
        ExpenseViewController* dest = (ExpenseViewController*)segue.destinationViewController;
        dest.nMonth = self.nMonth;
        dest.nYear = self.nYear;
        dest.currency = self.pCurrency;
        dest.pMainCategoryName = self.pMainCat;
        
        dest.pCategoryArray = [NSArray arrayWithArray:self.pCategory];
        NSMutableArray *array = [self.pAllEntryData objectForKey:self.pSelectedCategory];
        dest.pEntry = [array objectAtIndex:ip.row];
        array = nil;
    }
    ip = nil;
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
}



- (IBAction)addNewEntry:(UIStoryboardSegue *)segue
{
    ExpenseViewController *pSource = [segue sourceViewController];
    EntryItem * pEntryItem = pSource.pEntry;
    NSString * pCatName = pEntryItem.categoryName;
    NSMutableArray *array = [self.pAllEntryData objectForKey:pCatName];
    // Save data into database
    if(pEntryItem.entry_id < 0) [self.pDbManager saveNewEntryData:pEntryItem];
    if(pEntryItem.bModified)
    {
        [self.pDbManager updateEntryData:pEntryItem];
        pEntryItem.bModified = NO;
    }
    if(pSource.pOldEntry == nil)[array addObject:pEntryItem];
    [self reloadTable];
    array = nil;
    pCatName = nil;
    return; 
}

-(void) initEntryData
{
    self.pAllEntryData = nil; 
    self.pAllEntryData = [[NSMutableDictionary alloc] init];
    
    for (NSString* key in self.pCategory)
    {
        NSMutableArray *itemsArray = [self.pDbManager getAllEntry:key year:self.nYear month:self.nMonth];
        [self.pAllEntryData setObject:itemsArray forKey:key];
        itemsArray = nil;
    }
}


@end
