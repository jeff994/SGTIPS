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

@interface DealTableViewController ()

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
    jsonValue = [jsonParser objectWithString:test];
    NSArray *code = [jsonValue objectForKey:@"code"];
    self.pAllDeals = [jsonValue objectForKey:@"deals"];
    for(id deal in self.pAllDeals)
    {
        NSString * pTitle = [deal objectForKey:@"title"];
        NSString * pDisplayLink = [deal objectForKey:@"displaylink"];
        NSString * pImagePath = [deal objectForKey:@"image"];
    }
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];
    //[self.tableView setSeparatorInset:UIEdgeInsetsZero];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDeals];
    self.pImageArray = [[NSMutableArray alloc] init];
    
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
    return [self.pAllDeals count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListDeals" forIndexPath:indexPath];
    NSString *pDescription =  [self.pAllDeals[indexPath.row] objectForKey:@"title"];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    cell.textLabel.text = pDescription;
    
    NSString * pImageUrl = [self.pAllDeals[indexPath.row] objectForKey:@"image"];

    if([self.pImageArray count] <= indexPath.row)
    {
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pImageUrl]];
        
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        [self.pImageArray addObject:image];
        image = nil;
    }
    UIImage * pImage = [self.pImageArray objectAtIndex:indexPath.row];
    cell.imageView.image = pImage;
    
    return cell;
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
    NSString * pUrl = [self.pAllDeals[ip.row] objectForKey:@"displaylink"];
    
    if([segue.identifier isEqualToString:@"idShowDeal"])
    {
        DealViewController * dest = (DealViewController*)segue.destinationViewController;
        dest.pUrl = pUrl;
    }
    
}

@end
