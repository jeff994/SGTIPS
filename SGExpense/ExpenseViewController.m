//
//  ExpenseViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 21/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "ExpenseViewController.h"

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
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(donePickCategory:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     self.pCategory.frame.size.height-50, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    self.pCategory.inputView = self.pCategoryPicker;
    self.pCategory.inputAccessoryView = toolBar;
    self.categoryRow = 0;
    
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
    [actionSheet showInView:self.view];
}

- (void) initDatePicker
{
    self.pDatePicker.hidden = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(donePickDate:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     self.pCategory.frame.size.height-50, 320, 50)];
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
}

- (void) initReciptButton
{
    CGRect buttonFrame = self.pImageButton.frame;
    buttonFrame.size = CGSizeMake(150, 150);
    self.pImageButton.frame = buttonFrame;
    [[self.pImageButton layer] setCornerRadius:70.0f];
    [[self.pImageButton layer] setBorderWidth:1.0f];
    self.pImageButton.contentMode = UIViewContentModeScaleAspectFit;
}

-(void) initEntryData
{
    if(self.pEntry == nil)
    {
        self.pEntry = [[EntryItem alloc] init];
    }
}

// Init initinal value of the input field
-(void) initUIData
{
    [self setTitle:self.pMainCategoryName];
    self.currencyLabel.text = self.currency;
    [self.repeatSwitch setOn:self.pEntry.bRepat];
    
    self.pDescriptionField.text = self.pEntry.description;
    self.pCategory.text = self.pEntry.categoryName;
    if(self.pEntry.fAmountSpent > 0) self.pAmountField.text = [NSString stringWithFormat:@"%.2f", self.pEntry.fAmountSpent];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDateString = [dateFormatter stringFromDate:self.pEntry.entryDate];
    self.pEntryDate.text = formattedDateString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
        return;
    }
    
    
    return;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)descriptionChanged:(id)sender {
     self.pEntry.description = self.pDescriptionField.text;
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
}

- (IBAction)amountSpecified:(id)sender {
    [self.pAmountField resignFirstResponder];
    self.pEntry.fAmountSpent = [self.pAmountField.text doubleValue];
    [self.view endEditing:YES];
    if ([self.pEntry validEntry])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;

    
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

}

-(void)tap:(id)sender
{
    self.pEntry.description = self.pDescriptionField.text;
    [self.pAmountField resignFirstResponder];
    self.pEntry.fAmountSpent = [self.pAmountField.text doubleValue];
    self.pEntry.bRepat = [self.repeatSwitch isOn];
    [self.view endEditing:YES];
    if ([self.pEntry validEntry])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;

}

- (IBAction)datePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:self.pDatePicker.date];
    self.pEntryDate.text = formattedDateString;
 
  
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
