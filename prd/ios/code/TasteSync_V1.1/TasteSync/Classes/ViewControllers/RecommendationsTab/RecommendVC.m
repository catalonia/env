//
//  RecommendVC.m
//  TasteSync
//
//  Created by Victor on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RecommendVC.h"
#import "CommonHelpers.h"
#import "NotificationCell.h"
#import "AlertCustom.h"
#import "RestaurantRecommendations2.h"

@interface RecommendVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *lbNotifications;
    __weak IBOutlet UITableView *tbvUnread;
    __weak IBOutlet UIButton *notifycationButton, *shuffleButton, *helpButton;
    UserDefault *userDefault;
    GlobalNotification *glNotif ;
    NotificationObj *currentNotif;
    int page,aNumberOfRow;
    BOOL aIsLoadPreviousNotif;
    NotificationObj *fluryObj;
    int flurryIndex;
}
- (IBAction)actionContinueReading:(id)sender;
- (IBAction)actionShowProfile:(id)sender;

@end

#define REFRESH_HEADER_HEIGHT 52.0f

#define PAGE_NUMBER 5

@implementation RecommendVC

@synthesize arrData=_arrData;
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner,refreshFooterView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setupStrings];
    }
    return self;
}

- (id)initWithNotification
{
    self = [super initWithNibName:@"RecommendVC" bundle:nil];
    if (self) {
        [CommonHelpers appDelegate].reloadNotifycation = YES;
        [self setupStrings];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [CommonHelpers setBackgroudImageForView:self.view];
    [self addPullToRefreshHeader];
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    // Do any additional setup after loading the view from its nib.

    glNotif = [[GlobalNotification alloc]initWithALlType];
    glNotif.delegate = self;
    
    
    
    if (delegate.arrayNotification.count>0) {
        debug(@"total notifs -> %d", glNotif.total);
        self.arrData = delegate.arrayNotification;
    }
    page = 1;
    if(_arrData.count == 1)
    {
        [self gotoDetailNotification:[_arrData objectAtIndex:0] atIndex:0 ];
    }
    userDefault = [UserDefault userDefault];
    tbvUnread.separatorStyle = UITableViewCellSelectionStyleNone ;
    
    [self reloadData];
    if (userDefault.loginStatus == NotLogin) {
        [self gotoDetailNotification:glNotif.notifObj atIndex:0];
    }
    else
    {
        if (_arrData.count>1) {
            lbNotifications.text = [NSString stringWithFormat:@"%d NOTIFICATIONS",_arrData.count];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Add flury
    
    NSDictionary *recomentdationhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @""          , @"maxPaginationId",
     @""          ,@"unreadCounter",
     @""          , @"recoNotificationType",
     @""          , @"idBase",
     @""          , @"RecommendationPosition",
     nil];
    [CommonHelpers implementFlurry:recomentdationhomeParams forKey:@"RecommendationsInbox" isBegin:YES];
    
    
    aNumberOfRow = [CommonHelpers appDelegate].numberPageRecomendation;
    NSLog(@"aNumberOfRow: %d",aNumberOfRow);
    if ([CommonHelpers appDelegate].reloadNotifycation) {
        [CommonHelpers appDelegate].reloadNotifycation = NO;
        AppDelegate* deleate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        glNotif.pageLoad = _arrData.count/50;
        deleate.arrayNotification = [[NSMutableArray alloc]init];
        [glNotif reloadDownDataToNotifycation:_arrData.count View:self.view];
        aNumberOfRow = [CommonHelpers appDelegate].numberPageRecomendation;
        NSLog(@"aNumberOfRow: %d",aNumberOfRow);
        //[tbvUnread reloadData];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
 
    NSDictionary *recomentdationhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%d",aNumberOfRow]            , @"maxPaginationId",
     [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber]            , @"unreadCounter",
     [NSString stringWithFormat:@"%d",fluryObj.type]            , @"recoNotificationType",
     fluryObj.linkId            , @"idBase",
      [NSString stringWithFormat:@"%d",flurryIndex]            , @"RecommendationPosition",
     nil];
    [CommonHelpers implementFlurry:recomentdationhomeParams forKey:@"RecommendationsInbox" isBegin:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData
{
    glNotif.isSend = FALSE;
    //[glNotif reOrder];
    lbNotifications.text = [NSString stringWithFormat:@"%d NOTIFICATIONS",_arrData.count];
    [tbvUnread reloadData];
    
}

#pragma mark - IBAction Define

- (IBAction)actionAllButton:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.arrData = delegate.arrayNotification;
    [tbvUnread reloadData];
}
- (IBAction)actionShuffleButton:(id)sender
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //isLoadShuffle = YES;
    
    if (delegate.arrayShuffle.count == 0) {
        [glNotif requestData:self.view Type:RecommendationShuffle];
    }
    
    CustomDelegate* customdelegate = [[CustomDelegate alloc]init];
    customdelegate.recomendationDelegate = self;
    RecommendDetail2 *vc = [[RecommendDetail2 alloc] initWithShuffle];
    vc.global = customdelegate;
    vc.delegate = self;
    vc.notificationObj = [delegate.arrayShuffle objectAtIndex:delegate.currentShuffle];
    vc.indexOfNotification=index;
    vc.totalNotification= glNotif.unread;
    [self.navigationController pushViewController:vc animated:NO];
    
}
- (IBAction)actionHelpButton:(id)sender
{
    
}
- (IBAction)actionOthersTab:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionOthers];
}
- (IBAction)actionNewsfeedTab:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];

}

- (IBAction)actionContinueReading:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    debug(@"btn tag -> %d",btn.tag);
    NotificationObj *obj = [_arrData objectAtIndex:btn.tag];
    [self gotoDetailNotification:obj atIndex:btn.tag];
}

- (IBAction)actionShowProfile:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    debug(@"btn tag -> %d",btn.tag);
    NotificationObj *obj = [_arrData objectAtIndex:btn.tag];
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:obj.user];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"NotificationCell";
    
    if (indexPath.row < _arrData.count) {
        NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(NotificationCell *) [[[NSBundle mainBundle ] loadNibNamed:@"NotificationCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        cell.tag = indexPath.row;
        [cell initForView:[_arrData objectAtIndex:indexPath.row]];
        
        
        return cell;
    }
    else
    {
        static NSString *CellIndentifier2 = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier2];
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Load previous Notification";
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
        
        return cell;

    }

   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"NotificationCell";
    
    if (indexPath.row < _arrData.count) {
        NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell==nil) {
            cell =(NotificationCell *) [[[NSBundle mainBundle ] loadNibNamed:@"NotificationCell" owner:self options:nil] objectAtIndex:0];
        }
        
        
        return cell.frame.size.height;
    }
    else
    {
        static NSString *CellIndentifier2 = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier2];
        }
        return cell.frame.size.height;
        
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d, %d", indexPath.row, aNumberOfRow);
    if (indexPath.row < _arrData.count) {
        NotificationObj *obj = [_arrData objectAtIndex:indexPath.row];
        fluryObj = obj;
        flurryIndex = indexPath.row;
        [self gotoDetailNotification:obj atIndex:indexPath.row];
    }
    else
    {
        aIsLoadPreviousNotif = TRUE;
        [tbvUnread reloadData];
    }
   
}


// load more cell automatic when scroll to bottom of table view

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y) - (scrollView.contentSize.height - scrollView.frame.size.height);
        if (offset >=0  && page < aNumberOfRow) {
            debug(@"Load More Data");
            page++;
            [self loadMoreData];
        }
}

- (void)loadMoreData
{
    [glNotif reloadDownData:self.view Type:RecommendationNotification];
    [tbvUnread reloadData];
    
}

# pragma mark - Others
-(int)nextReload:(UIView*)view
{
    [glNotif reloadDownData:view Type:RecommendationShuffle];
    return [CommonHelpers appDelegate].arrayShuffle.count;
}
- (void) gotoDetailNotification:(NotificationObj *) obj atIndex:(int) index;
{
    debug(@"gotoDetailNotification");
    glNotif.index = index;
   // index++;
    currentNotif = obj;
    if (obj.type==TYPE_1) {
        CustomDelegate* delegate = [[CustomDelegate alloc]init];
        delegate.recomendationDelegate = self;
        RecommendDetail2 *vc = [[RecommendDetail2 alloc] initWithNibName:@"RecommendDetail2" bundle:nil];
        vc.global = delegate;
        vc.delegate = self;
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (obj.type == TYPE_2)
    {
        debug(@"type 2");
        CustomDelegate* delegate = [[CustomDelegate alloc]init];
        delegate.recomendationDelegate = self;
        RestaurantRecommendations2 *vc = [[RestaurantRecommendations2 alloc] initWithNibName:@"RestaurantRecommendations2" bundle:nil];
        vc.global = delegate;
        vc.notificationObj = obj;
        vc.indexOfNotification = index;
        vc.totalNotification = glNotif.unread;
        obj.read = true;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (obj.type== TYPE_3 || obj.type==TYPE_4)
    {
        CustomDelegate* delegate = [[CustomDelegate alloc]init];
        delegate.recomendationDelegate = self;
        RecommendDetail2 *vc = [[RecommendDetail2 alloc] initWithNibName:@"RecommendDetail2" bundle:nil];
        vc.global = delegate;
        vc.delegate = self;
        vc.notificationObj = obj;
        vc.indexOfNotification = index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (obj.type==TYPE_5)
    {
        CustomDelegate* delegate = [[CustomDelegate alloc]init];
        delegate.recomendationDelegate = self;
        RecommendDetail3 *vc = [[RecommendDetail3 alloc] initWithNibName:@"RecommendDetail3" bundle:nil];
        vc.global = delegate;
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (obj.type==TYPE_6)
    {
        CustomDelegate* delegate = [[CustomDelegate alloc]init];
        delegate.recomendationDelegate = self;
        RecommendDetail4 *vc = [[RecommendDetail4 alloc] initWithNibName:@"RecommendDetail4" bundle:nil];
        vc.global = delegate;
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(obj.type == TYPE_7)
    {
        debug(@"type 7");
        NSString *msg = [NSString stringWithFormat:@"Are you sure to see this detail restaurant?"];
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:msg delegate:self tag:1];
    }
    else if(obj.type == TYPE_8)
    {
        CustomDelegate* delegate = [[CustomDelegate alloc]init];
        delegate.recomendationDelegate = self;
        RecommendDetail7 *vc = [[RecommendDetail7 alloc] initWithNibName:@"RecommendDetail7" bundle:nil];
        vc.global = delegate;
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        
    }
}

# pragma mark - PullDownToRefresh

- (void)setupStrings{
    textPull = @"Pull down to update...";
    textRelease = @"Release to update...";
    textLoading = @"Updating...";
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.textColor = [UIColor whiteColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[CommonHelpers getImageFromName:@"arrow_refresh.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [tbvUnread addSubview:refreshHeaderView];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
        {
            tbvUnread.contentInset = UIEdgeInsetsZero;
        }
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
        {
            tbvUnread.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    debug(@"startLoading");
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        tbvUnread.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        tbvUnread.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
//    [self reloadData];
    [glNotif reloadUpData:1 view:nil Type:RecommendationNotification];
   [self performSelector:@selector(stopLoading) withObject:nil afterDelay:6.0];
}

-(void)getDataSuccess:(RecommendationType)type
{
    AppDelegate* deleate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (type == RecommendationNotification) {
        _arrData = [NSMutableArray arrayWithArray:deleate.arrayNotification];
        [tbvUnread reloadData];
    }
    lbNotifications.text = [NSString stringWithFormat:@"%d NOTIFICATIONS",_arrData.count];
    [self stopLoading];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0) {
        currentNotif.read = TRUE;
        [self gotoDetailNotification:[glNotif gotoNextNotification] atIndex:glNotif.index];
    }
    else
    {
        if (buttonIndex==1) {
            currentNotif.read = TRUE;
            RestaurantObj *obj = [[RestaurantObj alloc] init];
            obj.name = @"Nanking";
            obj.nation = @"American";
            obj.rates = 4;
            
            [[[CommonHelpers appDelegate] tabbarBaseVC] actionSelectRestaurant:obj selectedIndex:1];
        }
        else
        {
            [self gotoDetailNotification:[glNotif gotoNextNotification] atIndex:glNotif.index];
        }
    }
    
    
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData{
    
}

-(void)gotoNextNotify:(NotificationObj *)obj index:(int)index
{
    [self gotoDetailNotification:obj atIndex:index];
}
#pragma mark Recomendation Delegate
-(void)reloadRecomendation
{
    [CommonHelpers appDelegate].reloadNotifycation = YES;
    //[glNotif reloadDownDataToNotifycation:[CommonHelpers appDelegate].arrayNotification View:self.view Type:RecommendationNotification];
    NSLog(@"abcieruodfiasdfhioasydfio");
}


@end
