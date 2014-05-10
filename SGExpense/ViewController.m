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
        //[[DBSession sharedSession] unlinkAll];
        [self.pButtonLinkDropbox setTitle:@"Sync" forState:UIControlStateNormal];
        // Load meta data of root table
        [self.restClient loadMetadata:@"/"];
    }
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
        [self.restClient uploadFile:dbFile toPath:root
                      withParentRev:nil fromPath:[pRoot stringByAppendingPathComponent:dbFile]];
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
            if(pChildMeta.rev != nil) [self.restClient uploadFile:pName toPath:destDir withParentRev:pChildMeta.rev fromPath:pLocalPath];
        }
    }
    
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
            [self.restClient uploadFile:pFileName toPath:metadata.path withParentRev:nil fromPath:pLocalPath];
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
    /*
    NSString * pLocalReceiptPath = [pRoot stringByAppendingPathComponent:receipts];
    for(NSString * filename in pReceiptFile)
    {
        NSString * localPath = [pLocalReceiptPath stringByAppendingPathComponent:filename];
        [self.restClient uploadFile:filename toPath:pServerCfgPath  withParentRev:nil fromPath:localPath];
    }*/
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
    [self.pMetadataDictionary setValue:metadata forKey:metadata.path];
    DBMetadata * pData = [self.pMetadataDictionary objectForKey:metadata.path];
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
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
    // Init the dictionary for metadata
    self.pMetadataDictionary = [[NSMutableDictionary alloc]init];
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
