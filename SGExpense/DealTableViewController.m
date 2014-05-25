//
//  DealTableViewController.m
//  SGExpense
//
//  Created by Hu Jianbo on 10/5/14.
//  Copyright (c) 2014 SD. All rights reserved.
//

#import "DealTableViewController.h"
#import "SBJson.h"
#import "DealViewController.h"
#import "IconDownloader.h"
#import "DealRecord.h"

#define kCustomRowCount     7

@interface DealTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation DealTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) loadDeals
{
    NSString * pServerAddress = @"http://sgtips.com/wpmobile/alldeals.php";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pServerAddress]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    id jsonValue = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSString *rawJson = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    jsonValue = [jsonParser objectWithString:rawJson];
    NSString *pCode = [jsonValue objectForKey:@"code"];
    NSInteger nValue = [pCode intValue];
    if(nValue != 200) return;

    NSArray * allDeals = [jsonValue objectForKey:@"deals"];
    self.pAllDeals = [[NSMutableArray alloc] init];
    for(id pObject in allDeals)
    {
        DealRecord *newdeal = [[DealRecord alloc] init];
        newdeal.dealURLString = (NSString *)[pObject objectForKey:@"displaylink"];
        newdeal.imageURLString = (NSString *)[pObject objectForKey:@"image"];
        newdeal.dealDescription = (NSString *)[pObject objectForKey:@"title"];
        [self.pAllDeals addObject:newdeal];
    }
    
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];
    //[self.tableView setSeparatorInset:UIEdgeInsetsZero];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDeals];
    [self setTitle:@"Deals"];
    
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
    if([self.pAllDeals count] == 0)
    {
        [self loadDeals];
        [self.tableView reloadData];
    }
    return;
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
    NSInteger nRows= [self.pAllDeals count];
    if (nRows == 0)
	{
        return 0;
    }
    return nRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListDeals" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];

    NSUInteger nodeCount = [self.pAllDeals count];
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
		cell.detailTextLabel.text = @"Loading…";
		return cell;
    }
    
    if (nodeCount > 0)
	{
        // Set up the cell...
        DealRecord *deaRecord = [self.pAllDeals objectAtIndex:indexPath.row];
        
		cell.textLabel.text = deaRecord.dealDescription;
       	
        // Only load cached images; defer new downloads until scrolling ends
        if (!deaRecord.dealImage)
        {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:deaRecord forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.imageView.image = [UIImage imageNamed:@"Default.jpg"];
        }
        else
        {
            cell.imageView.image = deaRecord.dealImage;
        }
        
    }
    
    return cell;
}

- (void)startIconDownload:(DealRecord *)dealRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.dealRecord = dealRecord;
        [iconDownloader setCompletionHandler:^{
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = dealRecord.dealImage;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

- (void)loadImagesForOnscreenRows
{
    if ([self.pAllDeals count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            DealRecord *dealRecord = [self.pAllDeals objectAtIndex:indexPath.row];
            
            if (!dealRecord.dealImage)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:dealRecord forIndexPath:indexPath];
            }
        }
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
    DealRecord * pRecrod =  [self.pAllDeals objectAtIndex:ip.row];
    NSString * pUrl = pRecrod.dealURLString;
    
    if([segue.identifier isEqualToString:@"idShowDeal"])
    {
        DealViewController * dest = (DealViewController*)segue.destinationViewController;
        dest.pUrl = pUrl;
    }
    
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end
