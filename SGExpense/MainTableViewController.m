//
//  MainTableViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 18/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "MainTableViewController.h"
#import "SubCategoryTableViewController.h"

@interface MainTableViewController ()
@end

@implementation MainTableViewController

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
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    NSString *CellIdentifier = @"HeaderCell";
    UITextField * pHeaderField = [[UITextField alloc] initWithFrame:CGRectMake( 15, 10, self.tableView.frame.size.width - 30, 40)];
    pHeaderField.backgroundColor = [UIColor clearColor];
     pHeaderField.clearButtonMode = UITextFieldViewModeWhileEditing;
    double fSummary = 0.0;
    pHeaderField.borderStyle = UITextBorderStyleRoundedRect;
    pHeaderField.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [pHeaderField setFont:[UIFont boldSystemFontOfSize:12]];
    /*for (NSString* key in self.allEntryData) {
        NSMutableArray *array  = [self.allEntryData objectForKey:key];
        for (EntryItem * pItem in array) {
            fSummary += pItem.fAmountSpent;
        }
        // do stuff
    }
     */
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSArray * monthnames =[df monthSymbols];
    //NSString *monthName = [monthnames objectAtIndex:(self.nMonth-1)];
    
    //pHeaderCell.textLabel.text = [NSString stringWithFormat:@"%@ %ld", monthName, (long)self.nYear];
    //NSString *summary = [NSString stringWithFormat:@"Total: %@ %.2f", self.currency, fSummary];
    //pHeaderCell.detailTextLabel.text = summary;
    //pHeaderCell.imageView.image = self.pCategoryImage;
    pHeaderField.text = @"Test";
    pHeaderField.enabled = YES;
    pHeaderField.inputView = self.pMonthYearPicker;
    [headerView addSubview:pHeaderField];
    self.tableView.tableHeaderView = headerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pSelectedCategory = nil;
    // Get the db manager from the DBManager
    [self initTableHeader];

    _pDbManager = [DBManager getSharedInstance];
    NSArray * pMainCat = [_pDbManager getChildCatetory:@"Expense"];
    _pCategory = [NSMutableArray arrayWithArray:pMainCat];
    return;
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.pCategory count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListMainCatogory" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString * pCatName = [_pCategory objectAtIndex:indexPath.row];
    
    cell.textLabel.text = pCatName;
    UIImage * pImage = [_pDbManager loadImage:@"cfgimg" imgName: @"money.png"];;
    cell.imageView.image = pImage;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.pSelectedCategory = [_pCategory objectAtIndex:indexPath.row];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
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
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    self.pSelectedCategory = [_pCategory objectAtIndex:ip.row];

    if([segue.identifier isEqualToString:@"idNavigateSubCat"])
    {
        SubCategoryTableViewController* dest = (SubCategoryTableViewController*)segue.destinationViewController;
        dest.pMainCat = self.pSelectedCategory;
        self.pSelectedCategory = nil;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
