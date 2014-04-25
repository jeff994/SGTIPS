//
//  IncomeTableViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 19/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "IncomeTableViewController.h"
#import "SubCategoryTableViewController.h"
#import "UIMonthYearPicker.h" 

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


- (void) initTableFooter
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    NSString *CellIdentifier = @"FooterCell";
    UITableViewCell * pHeaderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    pHeaderCell.backgroundColor = [UIColor clearColor];
    
    double fSummary = 0.0;
    
    
    for(NSString* key in self.pCategory)
    {
        fSummary += [self.pDbManager getSummaryLeafCategory:key year:self.nYear month:self.nMonth];
    }
    
    //pHeaderCell.textLabel.text = [NSString stringWithFormat:@"%@ %ld", monthName, (long)self.nYear];
    NSString *summary = [NSString stringWithFormat:@"Total: %@%.2f", self.currency, fSummary];
    pHeaderCell.textLabel.text = summary;
    //pHeaderCell.imageView.image = self.pCatergoryImage;
    
    
    
    [headerView addSubview:pHeaderCell];
    self.tableView.tableFooterView = headerView;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.pSelectedCategory = @"Income";
    self.currency = @"S$";
    [self setTitle:@"Income"];
    // Get the db manager from the DBManager
    _pDbManager = [DBManager getSharedInstance];
    NSArray * pMainCat = [_pDbManager getChildCatetory:@"Income"];
    _pCategory = [NSMutableArray arrayWithArray:pMainCat];
    [self initTableHeader];
    [self initTableFooter];
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
    
    double fSummary = [self.pDbManager getSummaryLeafCategory:pCatName year:self.nYear month:self.nMonth];
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@%.2f", self.currency, fSummary];
    cell.textLabel.text = pCatName;
    UIImage * pImage = [_pDbManager loadImage:@"cfgimg" imgName: @"money.png"];
    cell.imageView.image = pImage;
    return cell;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.pHeaderField)
    {
        self.pMonthYearPicker.hidden = NO;
        NSDate *pToday =  [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:
                                            (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                                             NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                       fromDate:pToday ];
        [dateComponents setDay:1];
        [dateComponents setMonth:self.nMonth ];
        [dateComponents setYear:self.nYear];
        self.pMonthYearPicker.date = [calendar dateFromComponents:dateComponents];
        
    }
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
    
    self.pSelectedCategory = @"Income";
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
    [self initTableFooter];
}


- (void) initTableHeader
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    self.pHeaderField = [[UITextField alloc] initWithFrame:CGRectMake( 15, 10, self.tableView.frame.size.width - 30, 40)];
    self.pHeaderField.backgroundColor = [UIColor clearColor];
    self.pHeaderField.clearButtonMode = UITextFieldViewModeNever;
    self.pHeaderField.borderStyle = UITextBorderStyleRoundedRect;
    self.pHeaderField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pHeaderField.delegate = self;
    [self.pHeaderField setFont:[UIFont boldSystemFontOfSize:12]];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(donePickMonth:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     self.pHeaderField.frame.size.height-50, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    self.pHeaderField.text =  [self formatMonthString:[NSDate date]];
    self.pHeaderField.enabled = YES;
    self.pHeaderField.inputView = self.pMonthYearPicker;
    self.pHeaderField.inputAccessoryView = toolBar;
    self.pMonthYearPicker.hidden = YES;
    [headerView addSubview:self.pHeaderField];
    self.tableView.tableHeaderView = headerView;
    self.pMonthYearPicker._delegate = self;
    
}

-(void)donePickMonth:(id)sender
{
    self.pHeaderField.text = [self formatMonthString:self.pMonthYearPicker.date];
    [self.pHeaderField resignFirstResponder];
    self.pMonthYearPicker.hidden = YES;
    [self.tableView reloadData];
}

-(NSString *) formatMonthString:(NSDate *) date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    self.nMonth = [components month];
    self.nYear = [components year];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSArray * monthnames =[df monthSymbols];
    NSString *monthName = [monthnames objectAtIndex:(self.nMonth-1)];
    return [NSString stringWithFormat:@"%@ %ld", monthName, (long)self.nYear];
}
@end
