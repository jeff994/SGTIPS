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
    self.pCategoryArray  = [[NSArray alloc]         initWithObjects:@"Blue",@"Green",@"Orange",@"Purple",@"Red",@"Yellow" , nil];
    self.pCategoryPicker.dataSource = self;
    self.pCategoryPicker.delegate = self;
    self.pCategoryPicker.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     self.pCategory.frame.size.height-50, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    self.pCategory.inputView = self.pCategoryPicker;
    self.pCategory.inputAccessoryView = toolBar;
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
                                   target:self action:@selector(done:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     self.pCategory.frame.size.height-50, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    self.pEntryDate.inputView = self.pDatePicker;
    self.pEntryDate.inputAccessoryView = toolBar;
}

- (void) initAmountField
{
    [self.pAmountField setDelegate:self];
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect buttonFrame = self.pImageButton.frame;
    buttonFrame.size = CGSizeMake(150, 150);
    self.pImageButton.frame = buttonFrame;
    [[self.pImageButton layer] setCornerRadius:70.0f];
    [[self.pImageButton layer] setBorderWidth:1.0f];
    self.pScrollView.layer.borderWidth = 1;
    //self.view.layer.borderWidth =1 ;
    //self.view.layer.borderColor = [UIColor blackColor].CGColor;
    self.pScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.pDescriptionField setDelegate:self];
    [self initCategoryPicker];
    [self initDatePicker];
    [self initAmountField];
    self.pImageButton.contentMode = UIViewContentModeScaleAspectFit;
    [self.pImageButton setBackgroundImage:[UIImage imageNamed:@"money.png"]
                                 forState:UIControlStateNormal];
           // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.pDescriptionField resignFirstResponder];
    [self.pAmountField resignFirstResponder];
    [self.pEntryDate resignFirstResponder];
    return YES;
}

- (void)viewDidLayoutSubviews {
    [self.pScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.pScrollView.contentSize = CGSizeMake(320, 400);

}

- (IBAction)beginEditingDate:(id)sender {
    self.pDatePicker.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 6;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.pCategoryArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    self.pCategory.text = [self.pCategoryArray objectAtIndex:row];
}

-(void)done:(id)sender
{
    self.pCategoryPicker.hidden = YES;
    [self.pCategory resignFirstResponder];
    [self.pEntryDate resignFirstResponder];
}

-(void)tap:(id)sender
{
    [self.view endEditing:YES];
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
    [self.pImageButton setBackgroundImage:chosenImage
                        forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
