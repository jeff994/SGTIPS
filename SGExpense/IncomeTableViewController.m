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
        fSummary += [[DBManager getSharedInstance] getSummaryLeafCategory:key year:self.nYear month:self.nMonth];
    }
    
    //pHeaderCell.textLabel.text = [NSString stringWithFormat:@"%@ %ld", monthName, (long)self.nYear];
    NSString *summary = [NSString stringWithFormat:@"Total: %@%.2f", self.currency, fSummary];
    pHeaderCell.textLabel.text = summary;
    //pHeaderCell.imageView.image = self.pCatergoryImage;
    
    
    
    [headerView addSubview:pHeaderCell];
    self.tableView.tableFooterView = headerView;
}

-(void) initCurrency
{
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString * Getdollarsymbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
    self.currency = Getdollarsymbol;
    theLocale = nil;
    Getdollarsymbol = nil;
}

-(void) initSwiper
{
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    self.swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    self.swipeRight.delegate = self;
    [self.view addGestureRecognizer:self.swipeRight];
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    self.swipeLeft.delegate = self;
    [self.view addGestureRecognizer:self.swipeLeft];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self initSwiper];
    self.pSelectedCategory = @"Income";
    [self setTitle:@"Income"];
    [self initCurrency];
    // Get the db manager from the DBManager
       NSArray * pMainCat = [[DBManager getSharedInstance] getChildCatetory:@"Income"];
    _pCategory = [NSMutableArray arrayWithArray:pMainCat];
    [self addRepeatingEntry];
    [self initTableHeader];
    [self initTableFooter];
    self.pDbVersion = [[DBManager getSharedInstance] getLastVersion];
    self.pMonthYearPicker.hidden = YES; 
    return;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) animate:(NSInteger) controllerIndex
{
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = controllerIndex > self.tabBarController.selectedIndex;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    toView.frame = CGRectMake((scrollRight ? 320 : -320), viewSize.origin.y, 320, viewSize.size.height);
    
    [UIView animateWithDuration:1.0
                     animations: ^{
                         
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake((scrollRight ? -320 : 320), viewSize.origin.y, 320, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             self.tabBarController.selectedIndex = controllerIndex;
                         }
                     }];
    
}

- (void)handleSwipeLeft:(UITapGestureRecognizer *)recognizer {
    [self animate:2];
}

- (void)handleSwipeRight:(UITapGestureRecognizer *)recognizer {
    [self animate:0];

    // Insert your own code to handle swipe right
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // There is no version updates
    if([self.pDbVersion isEqualToString:[[DBManager getSharedInstance] getLastVersion]])
        return;
    // Database version not the same from current version
    [self.tableView reloadData];
    self.pDbVersion = [[DBManager getSharedInstance] getLastVersion];
    [self initTableFooter];
    return;
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
    
    double fSummary = [[DBManager getSharedInstance] getSummaryLeafCategory:pCatName year:self.nYear month:self.nMonth];
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@%.2f", self.currency, fSummary];
    cell.textLabel.text = pCatName;
    UIImage * pImage = [[DBManager getSharedInstance] loadCfgImage:pCatName];
    cell.imageView.image = pImage;
    pCatName = nil;
    pImage = nil;
    return cell;
}

- (void) addRepeatingEntry
{
    NSMutableArray * pAllEntryCurrentMonth = [[DBManager getSharedInstance] getAllEntry:@"Income" year:self.nYear month:self.nMonth];
    if([pAllEntryCurrentMonth count] > 0)
    {
        pAllEntryCurrentMonth = nil;
        return;
    }
    NSMutableArray * pAllEntryRepeatingLastMonth = [[DBManager getSharedInstance] getAllRepeatingEntry:@"Income" year:self.nYear month:self.nMonth - 1];
    if([pAllEntryRepeatingLastMonth count] <= 0) return;
    for(EntryItem * pItem in pAllEntryRepeatingLastMonth)
    {
        pItem.entry_id = -1;
        pItem.receipt = nil;
        pItem.receiptPath = nil;
        pItem.entryDate = self.pSelectedDate;
        [[DBManager getSharedInstance] saveNewEntryData:pItem];
    }
    pAllEntryCurrentMonth = nil;
    pAllEntryRepeatingLastMonth = nil;
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
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    self.pSelectedCategory = [_pCategory objectAtIndex:ip.row];
    
    //self.pSelectedCategory = @"Income";
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) initTableHeader
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    headerView.backgroundColor = [UIColor clearColor];
    self.pHeaderField = [[UITextField alloc] initWithFrame:CGRectMake( 5, 5, self.tableView.frame.size.width - 10, 40)];
    self.pHeaderField.backgroundColor = [UIColor clearColor];
    self.pHeaderField.clearButtonMode = UITextFieldViewModeNever;
    self.pHeaderField.borderStyle = UITextBorderStyleNone;
    self.pHeaderField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pHeaderField.textAlignment = NSTextAlignmentCenter;
    self.pHeaderField.delegate = self;
    //self.pHeaderField.backgroundColor = [UIColor lightGrayColor];
    [self.pHeaderField setFont:[UIFont boldSystemFontOfSize:15]];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleBordered
                                   target:self action:@selector(donePickMonth:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     self.pHeaderField.frame.size.height- 45, 320, 45)];
    [toolBar setBarStyle:UIBarStyleBlack];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    self.pHeaderField.text =  [self formatMonthString:[NSDate date]];
    self.pHeaderField.enabled = YES;
    self.pHeaderField.inputView = self.pMonthYearPicker;
    self.pHeaderField.inputAccessoryView = toolBar;
    self.pMonthYearPicker.hidden = YES;
    [headerView addSubview:self.pHeaderField];
    CGRect sepFrame = CGRectMake(0, headerView.frame.size.height-1, 320, 1);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
    [headerView addSubview:seperatorView];
    
    self.tableView.tableHeaderView = headerView;
    self.pMonthYearPicker._delegate = self;
    
}

-(void)donePickMonth:(id)sender
{
    self.pHeaderField.text = [self formatMonthString:self.pMonthYearPicker.date];
    [self.pHeaderField resignFirstResponder];
    [self addRepeatingEntry];
    self.pMonthYearPicker.hidden = YES;
    [self.tableView reloadData];
    [self initTableFooter];
}

-(NSString *) formatMonthString:(NSDate *) date
{
    self.pSelectedDate = date;
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
