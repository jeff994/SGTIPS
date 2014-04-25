//
//  IncomeTableViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 19/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "IncomeTableViewController.h"
#import "SubCategoryTableViewController.h"

@interface IncomeTableViewController ()

@end

@implementation IncomeTableViewController

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
    self.pSelectedCategory = @"Income";
    self.nYear  =  2014;
    self.nMonth =  4;
    self.currency = @"S$";
    [self setTitle:@"Income"];
    // Get the db manager from the DBManager
    _pDbManager = [DBManager getSharedInstance];
    NSArray * pMainCat = [_pDbManager getChildCatetory:@"Income"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.pCategory count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListMainCatogory" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString * pCatName = [_pCategory objectAtIndex:indexPath.row];
    
    cell.textLabel.text = pCatName;
    UIImage * pImage = [_pDbManager loadImage:@"cfgimg" imgName: @"money.png"];
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
    //NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    //self.pSelectedCategory = [_pCategory objectAtIndex:ip.row];
    
    if([segue.identifier isEqualToString:@"id_income"])
    {
        SubCategoryTableViewController* dest = (SubCategoryTableViewController*)segue.destinationViewController;
        dest.pMainCat = self.pSelectedCategory;
        dest.nMonth = self.nMonth;
        dest.nYear = self.nYear;
        dest.pCurrency = self.currency;
        self.pSelectedCategory = nil;
    }
}

- (IBAction)backFromSub:(UIStoryboardSegue *)segue
{
    [self.tableView reloadData];
}


@end
