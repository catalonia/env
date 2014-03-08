//
//  NewsFeedVC.m
//  TasteSync
//
//  Created by Victor on 12/21/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "NewsFeedVC.h"
#import "FeedObj.h"
#import "FeedCell.h"
#import "NewsFeedDetailVC.h"
#import "ListLikesVC.h"
#import "CommonHelpers.h"

@interface NewsFeedVC ()<UITableViewDelegate,UITableViewDataSource,FeedCellDelegate>
{
    __weak IBOutlet UITableView *tbvFeeds;
}

- (IBAction)actionSeeMore:(id)sender;

- (IBAction)actionOthersTab:(id)sender;

@end

@implementation NewsFeedVC

@synthesize feedsDaraArr = _feedsDaraArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.feedsDaraArr = [[NSMutableArray alloc] init];
        for (int i=0 ; i<10; i++) {
            FeedObj *feedObj = [[FeedObj alloc] init];
            UserObj *user = [[UserObj alloc] init];
            user.firstname = @"Leo";
            user.lastname = @"Messi";
            user.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
            feedObj.user = user;
            feedObj.timestamp = [NSString stringWithFormat:@"%d minutes ago",i];
            if (i==0) {
                feedObj.message = @"Bữa nay sinh nhật lư ù ta? co đi chơi đâu không lư? Chúc lư ù sinh nhật vui vẻ, hạnh phúc, mau mau có người ấy cho n ăn đám cưới.hehe";

            }
            else if(i==1)
            {
                feedObj.message = @"What do you like  ";

            }
            else if(i==2)
            {
                feedObj.message = @"Bữa nay sinh nhật lư ù ta? co đi chơi đâu không lư? Chúc lư ù sinh nhật vui vẻ, hạnh phúc, mau mau có người ấy cho n ăn đám cưới.hehe";
                
            }
            else if(i==3)
            {
                feedObj.message = @"Hãy tặng người con yêu thương nụ cười khi họ cảm thấy đau buồn để họ không gục ngã... Hãy tặng họ những giọt nước mắt khi vui để lòng biết ơn xuất hiện trong họ... Hãy tặng họ tình thương để họ không vô cảm trước cuộc sống khó khăn của bao người... Tặng họ những ước mơ, những ước mơ đơn giản giúp họ luôn phấn đấu... Tặng họ niềm vui dù chỉ là nhỏ bé...Tặng họ hy vọng dù chỉ là mong manh... Tặng họ những giấc ngủ an lành, sự yên bình sau những ngày mệt mỏi...";
                
            }
            else if(i==4)
            {
                feedObj.message = @"Hãy tặng người con yêu thương nụ cười khi họ cảm thấy đau buồn để họ không gục ngã... Hãy tặng họ những giọt nước mắt khi vui để lòng biết ơn xuất hiện trong họ... Hãy tặng họ tình thương để họ không vô cảm trước cuộc sống khó khăn của bao người... Tặng họ những ước mơ, những ước mơ đơn giản giúp họ luôn phấn đấu... Tặng họ niềm vui dù chỉ là nhỏ bé...Tặng họ hy vọng dù chỉ là mong manh... Tặng họ những giấc ngủ an lành, sự yên bình sau những ngày mệt mỏi...Hãy tặng người con yêu thương nụ cười khi họ cảm thấy đau buồn để họ không gục ngã... Hãy tặng họ những giọt nước mắt khi vui để lòng biết ơn xuất hiện trong họ... Hãy tặng họ tình thương để họ không vô cảm trước cuộc sống khó khăn của bao người... Tặng họ những ước mơ, những ước mơ đơn giản giúp họ luôn phấn đấu... Tặng họ niềm vui dù chỉ là nhỏ bé...Tặng họ hy vọng dù chỉ là mong manh... Tặng họ những giấc ngủ an lành, sự yên bình sau những ngày mệt mỏi...";
                
            }
            else
            {
                feedObj.message = @"What do you like .... xasl ss ss sasllsl sallalsaslasla saa";

            }
            feedObj.numberOfLikes = 10+i;
            feedObj.numberOfComments = i;
            
            [self.feedsDaraArr addObject:feedObj];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CommonHelpers setBackgroudImageForView:self.view];
   



    // Do any additional setup after loading the view from its nib.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction define

- (IBAction)actionOthersTab:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionOthers];
}

- (IBAction)actionSeeMore:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    debug(@"tag -> %d",btn.tag);
}


# pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_feedsDaraArr) {
        return _feedsDaraArr.count;
    }
    
    NSLog(@"return number row 1");
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForRowAtIndexPath");
    
    static NSString *CellIndentifier = @"feed_cell";
    
    FeedCell *cell = (FeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        cell =(FeedCell *) [[[NSBundle mainBundle ] loadNibNamed:@"FeedCell" owner:self options:nil] objectAtIndex:0];
        cell.delegate = self;
        cell.tag = indexPath.row;
        
        
    }
    
    
    
    FeedObj *feedObj = [_feedsDaraArr objectAtIndex:indexPath.row]; 
    [cell initForView:feedObj];
     
       
    return cell;
}

#pragma mark - Table view delegate



#pragma mark - FeedCellDelegate

- (void) feedCellDidActionComment:(FeedObj *)feedObj
{
    NewsFeedDetailVC *newsFeedDetail = [[NewsFeedDetailVC alloc] initWithNibName:@"NewsFeedDetailVC" bundle:nil];
    newsFeedDetail.arrData = self.feedsDaraArr;
    
        
    [self.navigationController pushViewController:newsFeedDetail animated:YES];
    
    [newsFeedDetail scrollToCommentCell];
}

- (void) feedCellDidActionShowUsersLike:(FeedObj *)feedObj
{
    ListLikesVC *vc = [[ListLikesVC alloc] initWithNibName:@"ListLikesVC" bundle:nil];
    vc.numberOfLikes = feedObj.numberOfLikes;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) feedCellDidActionShowMore:(int) pos
{
    debug(@"indexpath.row - > %d",pos);
    
    NewsFeedDetailVC *newsFeedDetail = [[NewsFeedDetailVC alloc] initWithNibName:@"NewsFeedDetailVC" bundle:nil];
    newsFeedDetail.arrData = self.feedsDaraArr;   
        
    [self.navigationController pushViewController:newsFeedDetail animated:YES];
}

- (void) feedCellDidActionProfile:(UserObj *)userObj
{
//    ProfileVC *vc = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
//    vc.user = userObj;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.navigationController.navigationBarHidden = NO;

}

@end
