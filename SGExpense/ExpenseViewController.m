//
//  ExpenseViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 21/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "ExpenseViewController.h"
#import "DBManager.h"

@interface ExpenseViewController ()

@end

@implementation ExpenseViewController


- (IBAction)selectCategory:(id)sender {
     self.pCategoryPicker.hidden = NO;
    
    if([self.pCategory.text length] == 0) return;
   
    NSInteger nIndex = 0;
    for (NSString* key in self.pCategoryArray)
    {
        if([key isEqualToString:self.pCategory.text]) break;
        nIndex++;
    }
    [self.pCategoryPicker selectRow:nIndex inComponent:0 animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initCategoryPicker
{
    self.pCategoryPicker.hidden = YES;
    self.pCategoryPicker.dataSource = self;
    self.pCategoryPicker.delegate = self;
    self.pCategoryPicker.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleBordered
                                   target:self action:@selector(donePickCategory:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     self.pCategory.frame.size.height- 45, 320, 45)];
    [toolBar setBarStyle:UIBarStyleBlack];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [NSDate date];
    self.pEntryDate.text = [dateFormatter stringFromDate:now];
    self.pEntry.entryDate = now;
    
    if([self.pCategoryArray count] == 1)
    {
        self.pCategory.text = [self.pCategoryArray objectAtIndex:0];
        [self.pCategory setUserInteractionEnabled:NO];
        self.pEntry.categoryName = [self.pCategoryArray objectAtIndex:0];
        self.pLabelCategory.text = @"";
    }
    else
    {
        NSInteger randomNumber = arc4random() % [self.pCategoryArray count] ;
        self.pCategory.inputView = self.pCategoryPicker;
        self.pCategory.text = [self.pCategoryArray objectAtIndex:randomNumber];
        self.pEntry.categoryName = [self.pCategoryArray objectAtIndex:randomNumber];
        self.pCategory.inputAccessoryView = toolBar;
        self.categoryRow = 0;
    }
    
    if([self.pCategory.text length] > 0)
    {
        self.pLabelCategory.text = @"";
    }
    if([self.pEntryDate.text length] > 0)
    {
        self.pLabelDate.text = @"";
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void) viewWillAppear:(BOOL)animated
{
    [self initCategoryPicker];
    return;
}

-(NSDate*) getFirstDateMonth:(NSInteger)nMonth
{
    NSDate *today = [NSDate date];  // returns correctly 28 february 2013
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:
                                        (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                                         NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                   fromDate:today];
    [dateComponents setDay:1];
    [dateComponents setMonth:nMonth];
    return [calendar dateFromComponents:dateComponents];;
}

-(NSDate*) getLastDateMonth:(NSInteger)nMonth
{
    NSDate *today = [NSDate date];  // returns correctly 28 february 2013
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:
                                        (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                                         NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                   fromDate:today];
    [dateComponents setDay:1];
    [dateComponents setMonth:nMonth + 1];
    [dateComponents setDay:0];
    return [calendar dateFromComponents:dateComponents];;
}

- (IBAction)getReceiptImage:(id)sender {
    NSString *actionSheetTitle = nil; //Action Sheet Title
    NSString *destructiveTitle = @"Take photo"; //Action Sheet Button Titles
    NSString *other1 = @"Choose photo";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:other1, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[self.view window]];
}

- (void) initDatePicker
{
    self.pDatePicker.hidden = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleBordered
                                   target:self action:@selector(donePickDate:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     self.pCategory.frame.size.height- 45, 320, 45)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    NSDate * pMaxDate = [self getLastDateMonth:self.nMonth];
    NSDate * pMinDate = [self getFirstDateMonth:self.nMonth];
    self.pDatePicker.maximumDate = pMaxDate;
    self.pDatePicker.minimumDate = pMinDate;
    
    self.pDatePicker.datePickerMode = UIDatePickerModeDate;
    self.pEntryDate.inputView = self.pDatePicker;
    self.pEntryDate.inputAccessoryView = toolBar;
}

- (void) initAmountField
{
    [self.pAmountField setDelegate:self];
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapRecognizer];
    //self.pAmountField.text = @"0.0";
    if ([self.pEntry validEntry] == NO)
    {
        self.pAmountField.layer.cornerRadius= 3.0f;
        self.pAmountField.layer.masksToBounds=YES;
        self.pAmountField.layer.borderColor=[[UIColor magentaColor]CGColor];
        self.pAmountField.layer.borderWidth= 1.0f;
    }
    if([self.pAmountField.text length] > 0)
    {
        self.pLabelAmount.text = @"";
    }
}

- (void) initReciptButton
{
    CGRect buttonFrame = self.pImageButton.frame;
    buttonFrame.size = CGSizeMake(150, 150);
    self.pImageButton.frame = buttonFrame;
    [[self.pImageButton layer] setCornerRadius:20.0f];
    [[self.pImageButton layer] setBorderWidth:1.0f];
    [self.pImageButton layer].masksToBounds = YES;
    self.pImageButton.contentMode = UIViewContentModeScaleAspectFit;
    if([[DBManager getSharedInstance] isChildOf:@"Expense" child:self.pMainCategoryName])
    {
        [self.pImageButton setTitle:@"Add a receipt" forState:UIControlStateNormal];
    }else if ([[DBManager getSharedInstance] isChildOf:@"Income" child:self.pMainCategoryName])
    {
        [self.pImageButton setTitle:@"Add a payment slip" forState:UIControlStateNormal];
    }
    if(self.pEntry)
    {
        if(self.pEntry.receipt)
        {
            [self.pImageButton setTitle:nil forState:UIControlStateNormal];
            [ self.pImageButton setBackgroundImage:self.pEntry.receipt forState:UIControlStateNormal];
        }
    }
}

- (IBAction)categoryChanged:(id)sender {
    self.pEntry.categoryName = self.pCategory.text;
    self.pLabelCategory.text = @"";
}

- (IBAction)dateChanged:(id)sender {
    if([self.pEntryDate.text length] <= 0)
    {
        self.pEntry.entryDate = nil ;
    }
    self.pEntryDate.text = @"";
}

-(void) initEntryData
{
    if(self.pEntry == nil)
    {
        self.pEntry = [[EntryItem alloc] init];
        self.pEntry.entry_id = -1;
    }
    else
    {
        self.pOldEntry = [[EntryItem alloc] init:self.pEntry.categoryName date:self.pEntry.entryDate description:self.pEntry.description amount:self.pEntry.fAmountSpent receipt:self.pEntry.receipt];
        self.pOldEntry.bRepat = self.pEntry.bRepat;
    }
    if ([self.pEntry validEntry])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;
}

// Init initinal value of the input field
-(void) initUIData
{
    [self setTitle:self.pMainCategoryName];
    self.currencyLabel.text = self.currency;
    [self.repeatSwitch setOn:self.pEntry.bRepat];
    
    if([self.pEntry.description length] > 0)
        self.pDescriptionField.text = self.pEntry.description;
    self.pCategory.text = self.pEntry.categoryName;
    self.pAmountField.text = [NSString stringWithFormat:@"%.2f", self.pEntry.fAmountSpent];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDateString = [dateFormatter stringFromDate:self.pEntry.entryDate];
    self.pEntryDate.text = formattedDateString;
    if ([self.pEntry validEntry])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;

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
    
    [self.pDescriptionField setDelegate:self];
    [self initCategoryPicker];
    [self initDatePicker];
    [self initAmountField];
    [self initReciptButton];
    [self initEntryData];
    [self initUIData];
    
    // Do any additional setup after loading the view.
}

- (IBAction)repeatSwitched:(id)sender {
    self.pEntry.bRepat = [self.repeatSwitch isOn];
}

- (void)handleSwipeLeft:(UITapGestureRecognizer *)recognizer {
    if(self.doneButton.isEnabled)
        [self performSegueWithIdentifier:@"addNewEntry" sender:self];
    // Insert your own code to handle swipe left
}

- (void)handleSwipeRight:(UITapGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:@"unwindToList" sender:self];
    // Insert your own code to handle swipe right
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.pDescriptionField)
    {
        self.pEntry.description = self.pDescriptionField.text;
        [self.pDescriptionField resignFirstResponder];
    }
    if(textField == self.pAmountField)
    {
        [self.pAmountField resignFirstResponder];
        self.pEntry.fAmountSpent = [self.pAmountField.text doubleValue];
        if ([self.pEntry validEntry])
            self.navigationItem.rightBarButtonItem.enabled = YES;
        else
            self.navigationItem.rightBarButtonItem.enabled = NO;
        
    }
    return YES;
}

- (void)viewDidLayoutSubviews {
    [self.pScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.pScrollView.contentSize = CGSizeMake(320, 400);

}

- (IBAction)beginEditingDate:(id)sender {
    self.pDatePicker.hidden = NO;
    if(self.pEntry == nil) return;
    if(self.pEntry.entryDate == nil) return;
    [self.pDatePicker setDate:self.pEntry.entryDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.doneButton)
    {
        // Prepare to pack the data and send it to the calling view;
        // And data validation
        
        // the value cannot be null
        // The description
        if(self.pOldEntry != nil) // Second time
        {
            if(![self.pOldEntry isEqual:self.pEntry])
            {
                self.pEntry.bModified = true;
            }
            
        }
        return;
    }
    
    
    return;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(textField == self.pDescriptionField)
        self.pEntry.description = nil;
    return YES;
}

- (IBAction)descriptionChanged:(id)sender {
     self.pEntry.description = self.pDescriptionField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //Replace the string manually in the textbox
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //perform any logic here now that you are sure the textbox text has changed
    if(textField ==self.pDescriptionField)
        [self descriptionChanged:self.pDescriptionField];
    if(textField == self.pAmountField)
        [self amountSpecified:self.pDescriptionField];
    if ([self.pEntry validEntry])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;
    return NO; //this make iOS not to perform any action
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [self.pCategoryArray count] ;
    
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.pCategoryArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    self.pCategory.text = [self.pCategoryArray objectAtIndex:row];
    self.pEntry.categoryName = [self.pCategoryArray objectAtIndex:row];
    self.categoryRow = row;
}

-(void)donePickCategory:(id)sender
{
    self.pCategoryPicker.hidden = YES;
    [self.pCategory resignFirstResponder];
    self.pCategory.text = [self.pCategoryArray objectAtIndex:self.categoryRow];
    self.pEntry.categoryName = [self.pCategoryArray objectAtIndex:self.categoryRow];

    if ([self.pEntry validEntry])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if([self.pAmountField.text length] > 0)
    {
        self.pLabelAmount.text = @"";
    }
    if([self.pCategory.text length] > 0)
    {
        self.pLabelCategory.text = @"";
    }
    if([self.pEntryDate.text length] > 0)
    {
        self.pLabelDate.text = @"";
    }
    
}

- (IBAction)amountSpecified:(id)sender {
    self.pEntry.fAmountSpent = [self.pAmountField.text doubleValue];
    if ([self.pEntry validEntry])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;
    if([self.pAmountField.text length] > 0)
    {
        self.pLabelAmount.text = @"";
    }
    if([self.pCategory.text length] > 0)
    {
        self.pLabelCategory.text = @"";
    }
    if([self.pEntryDate.text length] > 0)
    {
        self.pLabelDate.text = @"";
    }
    
}

-(void) donePickDate:(id)sender
{
    [self.pEntryDate resignFirstResponder];
    self.pEntry.entryDate = self.pDatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:self.pDatePicker.date];
    self.pEntryDate.text = formattedDateString;
    if ([self.pEntry validEntry])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;
    if([self.pAmountField.text length] > 0)
    {
        self.pLabelAmount.text = @"";
    }
    if([self.pCategory.text length] > 0)
    {
         self.pLabelCategory.text = @"";
    }
    if([self.pEntryDate.text length] > 0)
    {
        self.pLabelDate.text = @"";
    }
}

-(void)tap:(id)sender
{
    self.pEntry.description = self.pDescriptionField.text;
    [self.pAmountField resignFirstResponder];
    self.pEntry.fAmountSpent = [self.pAmountField.text doubleValue];
    self.pEntry.bRepat = [self.repeatSwitch isOn];
    if([self.pCategory.text length] > 0)
        self.pEntry.categoryName = self.pCategory.text;
    
    [self.view endEditing:YES];
    if([self.pAmountField.text length] > 0)
    {
        self.pLabelAmount.text = @"";
    }
    if([self.pCategory.text length] > 0)
    {
        self.pLabelCategory.text = @"";
    }
    if([self.pEntryDate.text length] > 0)
    {
        self.pLabelDate.text = @"";
    }
    if ([self.pEntry validEntry])
    {
        self.pAmountField.layer.borderColor=[[UIColor clearColor]CGColor];
        self.pAmountField.layer.borderWidth= 1.0f;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;

  
}

- (IBAction)datePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:self.pDatePicker.date];
    self.pEntryDate.text = formattedDateString;
    self.pEntry.entryDate = self.pDatePicker.date;
}

-(void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];

}

-(void) selectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self takePhoto];
            break;
        case 1:
             [self selectPhoto];
            break;
        case 2:
            [self tap:actionSheet];
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //self.imageView.image = chosenImage;
    if(chosenImage!= nil)
    {
        [self.pImageButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
        [self.pImageButton setTitle:nil forState:UIControlStateNormal];
        self.pEntry.receipt = chosenImage;
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
