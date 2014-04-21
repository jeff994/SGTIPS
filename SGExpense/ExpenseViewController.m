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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.pEntryDate.inputView = self.pDatePicker;
    CGRect buttonFrame = self.pImageButton.frame;
    buttonFrame.size = CGSizeMake(150, 150);
    self.pImageButton.frame = buttonFrame;
    [[self.pImageButton layer] setCornerRadius:60.0f];
    [[self.pImageButton layer] setBorderWidth:1.0f];
    self.pScrollView.layer.borderWidth = 1;
    //self.view.layer.borderWidth =1 ;
    //self.view.layer.borderColor = [UIColor blackColor].CGColor;
    self.pScrollView.layer.borderColor = [UIColor blackColor].CGColor;
           // Do any additional setup after loading the view.
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
}

- (IBAction)datePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:self.pDatePicker.date];
    self.pEntryDate.text = formattedDateString;
  
}



@end
