//
//  ViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 18/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)linkDropBox:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }else
    {
        [self.pButtonLinkDropbox setTitle:@"Sync" forState:UIControlStateNormal];
        [self saveDBFile];
        [self saveReceiptFile];
        [self saveCfgFile];
    }
}

- (void) saveDBFile
{
    NSString * pDBPath = [[DBManager getSharedInstance] getDatabasePath];
    NSString *destDir = @"/";
    [self.restClient uploadFile:@"account.db" toPath:destDir fromPath:pDBPath];
}

- (void) saveCfgFile
{
    NSMutableArray * pCFGFile = [[DBManager getSharedInstance] getCfgFilePath];
    NSString *destDir = @"/cfgimg/";
    [[self restClient] createFolder:@"/cfgimg"];
    for(NSString * cfgImg in pCFGFile)
    {
        NSString *filename = [cfgImg lastPathComponent];
       [self.restClient uploadFile:filename toPath:destDir fromPath:cfgImg];
    }
}

// Folder is the metadata for the newly created folder
- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder{
    NSLog(@"Created Folder Path %@",folder.path);
    NSLog(@"Created Folder name %@",folder.filename);
}
// [error userInfo] contains the root and path
- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error{
    NSLog(@"%@",error);
}

-(void) saveReceiptFile
{
    NSMutableArray * pReceiptFile = [[DBManager getSharedInstance] getReceiptFilePath];
    NSString *destDir = @"/receipts/";
    [[self restClient] createFolder:@"/receipts"];
    for(NSString * receiptImg in pReceiptFile)
    {
        NSString *filename = [receiptImg lastPathComponent];
        [self.restClient uploadFile:filename toPath:destDir fromPath:receiptImg];
    }
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.pCategoryArray objectAtIndex:row];
}

-(void) initCurrency
{
    self.pCategoryArray = [[NSMutableArray alloc]init];
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *Code = [theLocale objectForKey:NSLocaleCurrencyCode];
    self.pCurrency.text = Code;
    theLocale = nil;
    [self.pCurrency setUserInteractionEnabled:NO];
}

- (IBAction)beginSetCurrency:(id)sender
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pScrollView.layer.borderWidth = 2;
    self.pScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    if ([[DBSession sharedSession] isLinked])
    {
        [self.pButtonLinkDropbox setTitle:@"Sync" forState:UIControlStateNormal];
    }
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    [self initCurrency];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}



@end
