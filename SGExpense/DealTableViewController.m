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
#import "AppDelegate.h"

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

- (void) initTableHeader
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    headerView.layer.cornerRadius = 5;
    headerView.layer.masksToBounds = YES;
    self.pHeaderField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, self.tableView.frame.size.width - 10, 40)];
    self.pHeaderField.backgroundColor = [UIColor clearColor];
    self.pHeaderField.clearButtonMode = UITextFieldViewModeNever;
    self.pHeaderField.borderStyle =     UITextBorderStyleNone;
    self.pHeaderField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pHeaderField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.pHeaderField.textAlignment = NSTextAlignmentCenter;
    [self.pHeaderField setFont:[UIFont boldSystemFontOfSize:15]];
    self.pHeaderField.backgroundColor = [UIColor clearColor];
    self.pHeaderField.userInteractionEnabled = NO;
    if([self.pAllDeals count] > 0)
        self.pHeaderField.text = @"Featured Deals";
    else
        self.pHeaderField.text = @"Loading data";
    [headerView addSubview:self.pHeaderField];
    CGRect sepFrame = CGRectMake(0, headerView.frame.size.height-1, 320, 1);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
    [headerView addSubview:seperatorView];

    self.tableView.tableHeaderView = headerView;
}

-(void) loadDeals
{
    NSString * pServerAddress = @"http://sgtips.com/wpmobile/alldeals.php";
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //Load the json on another thread
        
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
        //When json is loaded stop the indicator
        if([allDeals count] == 0)
        {
             self.pHeaderField.text = @"Not able to get deals";
        }else
        {
            self.pHeaderField.text = @"Featured Deals";
            [self.tableView reloadData];
        }
    });

    
   /*
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
    */
    //[self.tableView setSeparatorInset:UIEdgeInsetsZero];
    return;
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
    [self animate:4];
}

- (void)handleSwipeRight:(UITapGestureRecognizer *)recognizer {
    [self animate:2];
    // Insert your own code to handle swipe right
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDeals];
    [self initSwiper];
    [self.m_activityView startAnimating];
    self.m_activityView.hidesWhenStopped = YES;
    
    [self initTableHeader];
    [self setTitle:@"Deals"];
    __weak AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.m_pDealTableController = self;
    self.pHeaderField.text = @"Featured Deals";
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

- (IBAction)unwindfromdeal:(UIStoryboardSegue *)segue
{
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

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == [self.pAllDeals count] - 5)
    {
        [self.m_activityView performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
    }
}

- (void)startIconDownload:(DealRecord *)dealRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        IconDownloader *iconDownloader  = [[IconDownloader alloc] init];
        iconDownloader.appRecord = dealRecord;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50; // your dynamic height...
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    DealRecord * pRecrod =  [self.pAllDeals objectAtIndex:ip.row];
    NSString * pUrl = pRecrod.dealURLString;
    
    if([segue.identifier isEqualToString:@"idShowDeal"] || [segue.identifier isEqualToString:@"idShowDeal2"])
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
