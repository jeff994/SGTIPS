//
//  SummaryTableViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 17/5/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "SummaryTableViewController.h"
#import "DBManager.h"

@interface SummaryTableViewController ()

@end

@implementation SummaryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void) initHeaderView
{
    self.pHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    self.pHeaderView.layer.cornerRadius = 5;
    self.pHeaderView.layer.masksToBounds = YES;
    self.pHeaderLabel = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, self.tableView.frame.size.width - 10, 40)];
    self.pHeaderLabel.backgroundColor = [UIColor clearColor];
    self.pHeaderLabel.clearButtonMode = UITextFieldViewModeNever;
    self.pHeaderLabel.borderStyle =     UITextBorderStyleNone;
    self.pHeaderLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pHeaderLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.pHeaderLabel.textAlignment = NSTextAlignmentCenter;
    self.pHeaderLabel.delegate = self;
    [self.pHeaderLabel setFont:[UIFont boldSystemFontOfSize:15]];
    self.pHeaderLabel.backgroundColor = [UIColor clearColor];
    self.pYearString = [self formatYearString:[NSDate date]];
    self.pHeaderLabel.text = self.pYearString;
    self.pHeaderLabel.enabled = YES;
    [self.pHeaderView addSubview:self.pHeaderLabel];
    CGRect sepFrame = CGRectMake(0, self.pHeaderView.frame.size.height-1, 320, 1);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
    [self.pHeaderView addSubview:seperatorView];
    self.pHeaderLabel.inputView = self.pPickerYear;
    self.pHeaderLabel.inputAccessoryView = self.toolBarYear;
    self.pPickerYear.hidden = YES;
    self.tableView.tableHeaderView = self.pHeaderView;
}

- (void)doneSelectYear:(id *) idobject
{
    self.pPickerYear.hidden = YES;
    [self.pHeaderLabel resignFirstResponder];
    [self.tableView reloadData];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.pYearData objectAtIndex:row];
}

-(void) initGloablData
{
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString * Getdollarsymbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
    self.pCurrency = Getdollarsymbol;
    theLocale = nil;
    Getdollarsymbol = nil;
}

- (void) configYearPicker
{
    self.pPickerYear.hidden = YES;
    self.pPickerYear.dataSource = self;
    self.pPickerYear.delegate = self;
    self.pPickerYear.showsSelectionIndicator = YES;
    if(self.toolBarYear == nil)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                       target:self action:@selector(doneSelectYear:)];
        self.toolBarYear = [[UIToolbar alloc]initWithFrame:
                            CGRectMake(0, self.view.frame.size.height-
                                       self.pPickerYear.frame.size.height-45, 320, 45)];
        [self.toolBarYear setBarStyle:UIBarStyleBlackOpaque];
        NSArray *toolbarItems = [NSArray arrayWithObjects:
                                 doneButton, nil];
        [self.toolBarYear setItems:toolbarItems];
    }
    
    if(self.pYearData == nil)
    {
        self.pYearData = [[NSMutableArray alloc] init];
    }
    int loopNumber;
    for(loopNumber = 2000; loopNumber <= 2030; loopNumber++) {
        NSString * pString =[NSString stringWithFormat:@"%d", loopNumber];
        [self.pYearData addObject:pString];
    }
    
    return;
}

-(NSString *) formatYearString:(NSDate *) date
{
    self.pSelectedDate = date;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    self.nYear = (int)[components year];
    return [NSString stringWithFormat:@"%ld", (long)self.nYear];
}

-(NSString *) formatMonthString:(NSInteger) month
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSArray * monthnames =[df monthSymbols];
    NSString *monthName = [monthnames objectAtIndex:(month)];
    return monthName;
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
    
    [UIView animateWithDuration:0.4
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
    //[self.tabBarController setSelectedIndex:3];
    // Get the views.
    NSInteger controllerIndex = 3;
    [self animate:controllerIndex];
    
}

- (void)handleSwipeRight:(UITapGestureRecognizer *)recognizer {
    NSInteger controllerIndex = 1;
    [self animate:controllerIndex];
    
    // Insert your own code to handle swipe right
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSwiper];
    [self setTitle:@"Summary"];
    [self configYearPicker];
    [self initHeaderView];
    [self initGloablData];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    return;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 13;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if (pickerView == self.pPickerYear)
    {
        return [self.pYearData count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SummaryCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *label, * label2;
    label = (UILabel *)[cell viewWithTag:1];
    label2 = (UILabel *)[cell viewWithTag:2];
    
    CGRect sepFrame = CGRectMake(0, 1, 320, 1);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
    double fExpense, fIncome, fTotal;
    if(indexPath.section == 0)
    {
        fExpense = [[DBManager getSharedInstance] getRecursiveSummaryCategory:@"Expense" year:self.nYear];
        fIncome = [[DBManager getSharedInstance] getRecursiveSummaryCategory:@"Income" year:self.nYear];
    }else
    {
        fExpense = [[DBManager getSharedInstance] getRecursiveSummaryCategory:@"Expense" year:self.nYear month:(indexPath.section - 1)];
        fIncome = [[DBManager getSharedInstance] getRecursiveSummaryCategory:@"Income" year:self.nYear month:(indexPath.section -1)];
    }

    fTotal = fIncome - fExpense;
    switch(indexPath.row)
    {
        case 0:
            label.text = [NSString stringWithFormat:@"Income"];
            label2.text = [NSString stringWithFormat:@"%@%.2f", self.pCurrency, fIncome];
            break;
        case 1:
            label.text = [NSString stringWithFormat:@"Expense"];
            label2.text = [NSString stringWithFormat:@"%@%.2f", self.pCurrency, fExpense];
            break;
        case 2:
            label.text = [NSString stringWithFormat:@"Total"];
            if(fTotal >= 0 )
                label2.text = [NSString stringWithFormat:@"%@%.2f", self.pCurrency, fTotal];
            else
                label2.text = [NSString stringWithFormat:@"-%@%.2f", self.pCurrency, -fTotal];
            break;
    }
    if(indexPath.row == 2) [cell addSubview:seperatorView];
    /*if(indexPath.row == 2 & indexPath.section == 0)
    {
        CGRect sepFrame2 = CGRectMake(0, 34, 320, 1);
        UIView *seperatorView2 = [[UIView alloc] initWithFrame:sepFrame2];
        seperatorView2.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
        [cell addSubview:seperatorView2];

    }*/
    seperatorView  = nil;
    return cell;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    if(pickerView == self.pPickerYear)
    {
        
        self.nYear =  [[self.pYearData objectAtIndex:row] intValue];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.pSelectedDate];
        [components setYear:self.nYear];
        self.pHeaderLabel.text  = [self.pYearData objectAtIndex:row];
        return;
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.pPickerYear.hidden = NO;
    NSInteger nIndex = 0;
    for (NSString* key in self.pYearData)
    {
        if([key isEqualToString:self.pHeaderLabel.text]) break;
        nIndex++;
    }
    [self.pPickerYear selectRow:nIndex inComponent:0 animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0) return 10;
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sSection;
    switch (section)
    {
        case 0:
            sSection = [NSString stringWithFormat:@"Entire year"];
            break;
        default:
            sSection = [NSString stringWithFormat:@"%@", [self formatMonthString:(section - 1)]];
            break;
    }
    return sSection;
    //return [_pCategory objectAtIndex:section];
}

@end
