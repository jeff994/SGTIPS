//
//  ViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 18/4/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)linkDropBox:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }else
    {
        //[[DBSession sharedSession] unlinkAll];
        [self.pButtonLinkDropbox setTitle:@"Sync" forState:UIControlStateNormal];
        // Load meta data of root table
        [self uploadData];
    }
}

-(void) uploadData
{
    [self.restClient loadMetadata:@"/"];

}

- (void) saveDBFile
{
    [self.restClient loadMetadata:@"/account.db"];

}

- (void) saveCfgFile
{
    NSMutableArray * pCFGFile = [[DBManager getSharedInstance] getCfgFilePath];
    //NSString *destDir = @"/cfgimg/";
    [[self restClient] createFolder:@"/cfgimg"];
    for(NSString * cfgImg in pCFGFile)
    {
        NSString *filename = [cfgImg lastPathComponent];
        NSString *key = [NSString stringWithFormat:@"/cfgimg/%@", filename];
        [self.restClient loadMetadata:key];
        //NSString *filename = [cfgImg lastPathComponent];
        //[self.restClient uploadFile:filename toPath:destDir fromPath:cfgImg];
    }
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path
{
    return;
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
{
    return;
}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
    // 1. First time when there's no data in dropbox
    NSString * pRoot = [[DBManager getSharedInstance] getDocumentDirectory];
    NSString * dbFile = [[[DBManager getSharedInstance] getDatabasePath] lastPathComponent];
    NSString* root = @"/";
    NSString* cfg = @"cfgimg";
    NSString* receipts = @"receipts";
    // First time when user connects drop box
    if([metadata.contents count] == 0 && [metadata.path isEqualToString:root])
    {
        if([self.pUploadingDictationary objectForKey:metadata.filename ] == nil)
        {
            [self.restClient uploadFile:dbFile toPath:root
                      withParentRev:nil fromPath:[pRoot stringByAppendingPathComponent:dbFile]];
             [self.pUploadingDictationary setValue:[pRoot stringByAppendingPathComponent:dbFile] forKey:metadata.filename ];
        }
        NSString * pServerCfgPath =[root stringByAppendingPathComponent:cfg];
        NSString * pServerReceiptPath = [root stringByAppendingString:receipts];
        [[self restClient] createFolder:pServerCfgPath];
        [[self restClient] createFolder:pServerReceiptPath];
        return;
    }
    else if ([metadata.contents count] < 3  && [metadata.path isEqualToString:root])
    {
        NSString * pServerCfgPath =[root stringByAppendingPathComponent:cfg];
        NSString * pServerReceiptPath = [root stringByAppendingString:receipts];
        [[self restClient] createFolder:pServerCfgPath];
        [[self restClient] createFolder:pServerReceiptPath];
        return;
    }
    
    for(DBMetadata* pChildMeta in metadata.contents)
    {
        NSString * pName = pChildMeta.filename;
        if(pChildMeta.isDirectory)
        {
            [self.restClient loadMetadata:pChildMeta.path];
        }
        else
        {
            [self.pMetadataDictionary setValue:pChildMeta forKey:pChildMeta.path];
            NSString * pLocalPath = [pRoot stringByAppendingPathComponent:pChildMeta.path];
            NSString * destDir = [pChildMeta.path stringByDeletingLastPathComponent];
            NSString * pUploading = [self.pUploadingDictationary objectForKey:metadata.filename ];
            if(pUploading == nil)
            {
                [self.pUploadingDictationary setValue:pLocalPath forKey:metadata.filename];
                if([metadata.path isEqualToString:root])
                {
                    NSString * sRev = [[DBManager getSharedInstance] getLastVersion];
                    if([sRev isEqualToString:pChildMeta.rev])
                    {
                        [self.restClient uploadFile:pName toPath:destDir withParentRev:pChildMeta.rev fromPath:pLocalPath];
                    }else
                    {
                        [self.pButtonLinkDropbox setTitle:@"Version conflit: editing at two ios device" forState:UIControlStateNormal];
                    }
                }else
                {
                    if(pChildMeta.rev != nil) [self.restClient uploadFile:pName toPath:destDir withParentRev:pChildMeta.rev fromPath:pLocalPath];
                }
            }
        }
    }
    if([metadata.path isEqualToString:root]) return;
    
    NSString *localDirectory = [pRoot stringByAppendingPathComponent:metadata.path];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *localList = [manager contentsOfDirectoryAtPath:localDirectory error:nil];
    for(NSString * pFileName in localList)
    {
        NSString *key = [metadata.path stringByAppendingPathComponent:pFileName];
        NSString * pPathFound = [self.pMetadataDictionary objectForKey:key];
        NSString * pLocalPath = [localDirectory stringByAppendingPathComponent:pFileName];
        
        BOOL isDir;
        if ([manager fileExistsAtPath:pLocalPath isDirectory:&isDir] && isDir)
            continue;
        
        if(pPathFound == nil ) // File not in the server
        {
            // Upload file to server
            
            if([self.pUploadingDictationary objectForKey:pFileName] == nil)
            {
                if(self.pUploadingDictationary == nil)
                     self.pUploadingDictationary = [[NSMutableDictionary alloc]init];
                [self.pUploadingDictationary setValue:pLocalPath forKey:pFileName];
                [self.restClient uploadFile:pFileName toPath:metadata.path withParentRev:nil fromPath:pLocalPath];
            }
        }
    }
    return;
    //if(metadata.revision ! )
}

// Folder is the metadata for the newly created folder
- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder{
    NSLog(@"Created Folder Path %@",folder.path);
    NSLog(@"Created Folder name %@",folder.filename);
    NSString * pRoot = [[DBManager getSharedInstance] getDocumentDirectory];
    NSString * pLocalPath = [pRoot stringByAppendingPathComponent:folder.path];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:pLocalPath error:nil];
    for(NSString * filename in fileList)
    {
        NSString * localPath = [pLocalPath stringByAppendingPathComponent:filename];
        [self.restClient uploadFile:filename toPath:folder.path  withParentRev:nil fromPath:localPath];
    }
}

// [error userInfo] contains the root and path
- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error{
    NSLog(@"%@",error);
}

-(void) saveReceiptFile
{
    NSMutableArray * pReceiptFile = [[DBManager getSharedInstance] getReceiptFilePath];
    [[self restClient] createFolder:@"/receipts"];
    for(NSString * receiptImg in pReceiptFile)
    {
        NSString *filename = [receiptImg lastPathComponent];
        NSString *key = [NSString stringWithFormat:@"/receipts/%@", filename];
        [self.restClient loadMetadata:key];
        //NSString *filename = [receiptImg lastPathComponent];
        //[self.restClient uploadFile:filename toPath:destDir fromPath:receiptImg];
    }
}

-(void) loadDBFile
{
    
}

-(void) LoadCFGFile
{
    
}

-(void) loadReceiptFile
{
    
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata
{
    NSString * pDbPath = [[[DBManager getSharedInstance] getDatabasePath] lastPathComponent];
    
    if ([metadata.filename isEqualToString:pDbPath])
    {
        [[DBManager getSharedInstance] updateVersion:metadata.rev];
    }
    [self.pUploadingDictationary removeObjectForKey:metadata.filename];
    [self.pMetadataDictionary setValue:metadata forKey:metadata.path];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
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
                         //fromView.frame =CGRectMake((scrollRight ? -320 : 320), viewSize.origin.y, 320, viewSize.size.height);
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
    //[self.tabBarController setSelectedIndex:0];
    //[self animate:0];
}

- (void)handleSwipeRight:(UITapGestureRecognizer *)recognizer {
    [self animate:3];
    // Insert your own code to handle swipe right
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSwiper];
    //self.pHeaderView.layer.borderWidth = 1;
    self.pHeaderView.layer.cornerRadius = 5;
    self.pScrollView.layer.borderWidth = 2;
    //self.pScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    self.pButtonLinkDropbox.layer.cornerRadius = 3;
    //self.pButtonLinkDropbox.layer.borderWidth = 1;
    //self.pButtonLinkDropbox.layer.borderColor = [UIColor blueColor].CGColor;
    if ([[DBSession sharedSession] isLinked])
    {
        [self.pButtonLinkDropbox setTitle:@"Sync" forState:UIControlStateNormal];
    }
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    [self initCurrency];
    // Init the dictionary for metadata
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.m_pViewControler = self;
    self.pMetadataDictionary = [[NSMutableDictionary alloc]init];
    self.pUploadingDictationary = [[NSMutableDictionary alloc]init];
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
