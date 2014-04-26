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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) initTableHeader
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.layer.cornerRadius = 5;
    headerView.layer.masksToBounds = YES;
    self.pHeaderField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, self.tableView.frame.size.width - 10, 50)];
    self.pHeaderField.backgroundColor = [UIColor clearColor];
    self.pHeaderField.clearButtonMode = UITextFieldViewModeNever;
    self.pHeaderField.borderStyle = UITextBorderStyleRoundedRect;
    self.pHeaderField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pHeaderField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.pHeaderField.textAlignment = NSTextAlignmentCenter;
    self.pHeaderField.delegate = self;
    [self.pHeaderField setFont:[UIFont boldSystemFontOfSize:15]];
    self.pHeaderField.backgroundColor = [UIColor lightGrayColor];
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
        fSummary += [self.pDbManager getSummaryCategory:key year:self.nYear month:self.nMonth];
    }
    
    //pHeaderCell.textLabel.text = [NSString stringWithFormat:@"%@ %ld", monthName, (long)self.nYear];
    NSString *summary = [NSString stringWithFormat:@"Total: %@%.2f", self.currency, fSummary];
    pHeaderCell.textLabel.text = summary;
    //pHeaderCell.imageView.image = self.pCatergoryImage;
    
    
    
    [headerView addSubview:pHeaderCell];
    self.tableView.tableFooterView = headerView;
}

-(void) InitGlobalData
{
    self.currency = @"S$" ;
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

-(void)donePickMonth:(id)sender
{
    self.pHeaderField.text = [self formatMonthString:self.pMonthYearPicker.date];
    [self.pHeaderField resignFirstResponder];
    self.pMonthYearPicker.hidden = YES;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pSelectedCategory = nil;
    // Get the db manager from the DBManager
    [self initTableHeader];
    [self InitGlobalData];

    _pDbManager = [DBManager getSharedInstance];
    NSArray * pMainCat = [_pDbManager getChildCatetory:@"Expense"];
    [self setTitle:@"Expense"];
    _pCategory = [NSMutableArray arrayWithArray:pMainCat];
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
    
    double fSummary = [self.pDbManager getSummaryCategory:pCatName year:self.nYear month:self.nMonth];
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@%.2f", self.currency, fSummary];
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
        dest.nMonth = self.nMonth;
        dest.nYear = self.nYear;
        dest.pCurrency = self.currency;
        self.pSelectedCategory = nil;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void) pickerView:(UIPickerView *)pickerView didChangeDate:(NSDate *)newDate{
    return;
    //dateLabel.text = [dateFormatter stringFromDate:newDate];
}

- (IBAction)backFromSub:(UIStoryboardSegue *)segue
{
    [self.tableView reloadData];
    [self initTableFooter];
}

@end
