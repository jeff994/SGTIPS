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
    NSString * pValue = response1 ;
    NSString *test = @"{\"code\": 200, \"deals\":[{\"title\":\"Only S$19.90 (Original S$105.9) for Prada Pink Candy Clutch Bag: Fashionable Clutch Bag for Fab Ladies!\",\"displaylink\":\"http://sgtips.com/deal/s19-90-original-s105-9-prada-pink-candy-clutch-bag-fashionable-clutch-bag-fab-ladies\",\"image\":\"https://www.alldealsasia.com/sites/default/files/deals/prada-pink-candy-clutch-main.jpg\"},{\"title\":\"Only S$38 (Original S$122.00) for Silky Hair Rebonding OR Perming at Rapunzel Hair, Somerset - Includes Wash + Blow Dry (H2O or MUCOTA Option Available)\",\"displaylink\":\"http://sgtips.com/deal/s38-original-s122-00-silky-hair-rebonding-perming-rapunzel-hair-somerset-includes-wash-blow-dry-h2o-mucota-option-available\",\"image\":\"http://static.deal.com.sg/sites/default/files/watermark_main/Rapunzel-Hair.jpg\"}]}";
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    jsonValue = [jsonParser objectWithString:rawJson];
    NSArray *code = [jsonValue objectForKey:@"code"];
    
    
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

@end
