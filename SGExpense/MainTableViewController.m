//
//  MainTableViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 18/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "MainTableViewController.h"
#import "SubCategoryTableViewController.h"
#import "AppDelegate.h"

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
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    headerView.layer.cornerRadius = 5;
    headerView.layer.masksToBounds = YES;
    self.pHeaderField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, self.tableView.frame.size.width - 10, 40)];
    self.pHeaderField.backgroundColor = [UIColor clearColor];
    self.pHeaderField.clearButtonMode = UITextFieldViewModeNever;
    self.pHeaderField.borderStyle =     UITextBorderStyleNone;
    self.pHeaderField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pHeaderField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.pHeaderField.textAlignment = NSTextAlignmentCenter;
    self.pHeaderField.delegate = self;
    [self.pHeaderField setFont:[UIFont boldSystemFontOfSize:15]];
    self.pHeaderField.backgroundColor = [UIColor clearColor];
    
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
        fSummary += [[DBManager getSharedInstance] getSummaryCategory:key year:self.nYear month:self.nMonth];
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
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString * Getdollarsymbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
    self.currency = Getdollarsymbol;
    theLocale = nil;
    Getdollarsymbol = nil;
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

- (void) addRepeatingEntry
{
    NSMutableArray * pAllEntryCurrentMonth = [[DBManager getSharedInstance] getAllEntry:@"Expense" year:self.nYear month:self.nMonth];
    if([pAllEntryCurrentMonth count] > 0)
    {
        pAllEntryCurrentMonth = nil;
        return;
    }
    NSMutableArray * pAllEntryRepeatingLastMonth = [[DBManager getSharedInstance] getAllRepeatingEntry:@"Expense" year:self.nYear month:self.nMonth - 1];
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

-(void)donePickMonth:(id)sender
{
    self.pHeaderField.text = [self formatMonthString:self.pMonthYearPicker.date];
    [self.pHeaderField resignFirstResponder];
    [self addRepeatingEntry];
    self.pMonthYearPicker.hidden = YES;
    [self.tableView reloadData];
    [self initTableFooter];
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
    __weak AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.m_pMainViewControler = self;
    //[[DBSession sharedSession] unlinkAll];
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    else
    {
        self.m_rev = [[DBManager getSharedInstance] getLastVersion];
        [self DownloadData]; //Download data when app started
    }
    self.pSelectedCategory = nil;
    // Get the db manager from the DBManager
    [self initTableHeader];
    [self InitGlobalData];

  
    NSArray * pMainCat = [[DBManager getSharedInstance] getChildCatetory:@"Expense"];
    [self setTitle:@"Expense"];
    [self addRepeatingEntry];
    _pCategory = [NSMutableArray arrayWithArray:pMainCat];
    [self initTableFooter];
    return;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)handleSwipeLeft:(UITapGestureRecognizer *)recognizer {
    [self.tabBarController setSelectedIndex:1];
}

- (void)handleSwipeRight:(UITapGestureRecognizer *)recognizer {
    //[self.tabBarController setSelectedIndex:4];

    // Insert your own code to handle swipe right
}

/*
#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.view]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}
 */


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
    
    cell.imageView.image = nil;
    cell.textLabel.text = pCatName;
    
    double fSummary = [[DBManager getSharedInstance] getSummaryCategory:pCatName year:self.nYear month:self.nMonth];
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@%.2f", self.currency, fSummary];
    UIImage * pImage = [[DBManager getSharedInstance] loadCfgImage:pCatName];
    cell.imageView.image = pImage;
    pImage = nil; 
    pCatName = nil;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.pSelectedCategory = [_pCategory objectAtIndex:indexPath.row];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

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

#pragma mark - Drop box downloading data for the first time

-(void) DownloadData
{
    if ([[DBSession sharedSession] isLinked])
    {
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
        [self.restClient loadMetadata:@"/"];
    }
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
{
    return;
}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
    // 1. First time when there's no data in dropbox
    NSString * pRoot = [[DBManager getSharedInstance] getDocumentDirectory];

    NSString* root = @"/";
    // First time when user connects drop box would be handled in the config module
    // Data already in the server 
    if([metadata.contents count] == 3 && [metadata.path isEqualToString:root])
    {
        for(DBMetadata * pData in metadata.contents)
        {
            if(!pData.isDirectory)
            {
                if([self.m_rev isEqualToString:pData.rev] == NO)
                {
                    // Disable editing
                    [self.view setUserInteractionEnabled:NO];
                    self.m_rev = metadata.rev;
                   [self.restClient loadFile:pData.path  atRev:self.m_rev intoPath:[pRoot stringByAppendingPathComponent:pData.path]];
                }
            }
            else
                [self.restClient loadMetadata:pData.path];
        }
    }else if(metadata.isDirectory)
    {
         for(DBMetadata * pData in metadata.contents)
         {
             if(!pData.isDirectory)
                 [self.restClient loadFile:pData.path intoPath:[pRoot stringByAppendingPathComponent:pData.path]];
             else
                 [self.restClient loadMetadata:pData.path];

         }
    }
    
    return;
    //if(metadata.revision ! )
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    NSLog(@"File loaded into path: %@", localPath);
    NSString * dbFile = [[[DBManager getSharedInstance] getDatabasePath] lastPathComponent];
    NSString * dbFile2 = [localPath lastPathComponent];
    if([dbFile isEqual:dbFile2])
    {
        self.m_rev = metadata.rev;
        [DBManager clearSharedInstance];
        [[DBManager getSharedInstance]updateVersion:self.m_rev];
        [self.tableView reloadData];
        [self.view setUserInteractionEnabled:YES];
    }
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
}



@end
