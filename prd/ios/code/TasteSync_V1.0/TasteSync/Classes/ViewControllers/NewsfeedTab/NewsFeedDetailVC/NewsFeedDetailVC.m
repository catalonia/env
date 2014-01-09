//
//  NewsFeedDetailVC.m
//  TasteSync
//
//  Created by Victor NGO on 12/23/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "NewsFeedDetailVC.h"
#import "FeedObj.h"
#import "UserDefault.h"
#import "FeedCell.h"
#import "FeedDetailCell.h"
#import "CommentCell.h"
#import "CommonHelpers.h"
#import "ListLikesVC.h"

@interface NewsFeedDetailVC ()<UITableViewDataSource,UITableViewDelegate,FeedCellDelegate,FeedDetailCellDelegate,CommentCellDelegate>
{
    __weak IBOutlet UITableView *tbvFeeds;
}
- (IBAction)actionBack:(id)sender;


@end

@implementation NewsFeedDetailVC

@synthesize arrData = _arrData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arrData = [[NSMutableArray alloc] init];
        for (int i=0 ; i<10; i++) {
            FeedObj *feedObj = [[FeedObj alloc] init];
            UserObj *user = [[UserObj alloc] init];
            user.firstname = @"Leo";
            user.lastname = @"Messi";
            user.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
            feedObj.user = user;
            feedObj.timestamp = [NSString stringWithFormat:@"%d minutes ago",i];
            feedObj.message = @"What do you like .... xasl ss ss sasllsl sallalsaslasla saa";
            feedObj.numberOfLikes = 10+i;
            feedObj.numberOfComments = i;
            
            [self.arrData addObject:feedObj];
        }
        
        NSLog(@"self.arrData.count -> %d",self.arrData.count);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CommonHelpers setBackgroudImageForView:self.view];

    

   
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
  
}

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_arrData) {
        return _arrData.count+2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"feed_cell";
    static NSString *CellIdentifier2 = @"feed_detail_cell";
    static NSString *CellIdentifier3 = @"comment_cell";


    if (indexPath.row ==0) {
        FeedCell *cell = (FeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell==nil) {
            NSLog(@"cell is nil");
            cell =(FeedCell *) [[[NSBundle mainBundle ] loadNibNamed:@"FeedCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
                
        
        FeedObj *feedObj = [_arrData objectAtIndex:indexPath.row];      
        cell.delegate = self;  
        cell.tag = indexPath.row;
        cell.flag = TRUE;
        [cell initForView:feedObj];
      

        return cell;

    }
    else if (indexPath.row < _arrData.count) {
        FeedDetailCell *cell = (FeedDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (cell==nil) {
            NSLog(@"cell is nil");
            cell =(FeedDetailCell *) [[[NSBundle mainBundle ] loadNibNamed:@"FeedDetailCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        FeedObj *feedObj = [_arrData objectAtIndex:indexPath.row];
        [cell initForView:feedObj];
        cell.delegate = self;
        cell.tag = indexPath.row;
        return cell;
    }
    
    else if(indexPath.row == _arrData.count)
      {
          CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
          
          if (cell==nil) {
              NSLog(@"cell is nil");
              cell =(CommentCell *) [[[NSBundle mainBundle ] loadNibNamed:@"CommentCell" owner:self options:nil] objectAtIndex:0];
              
              
          }
          cell.delegate =self;
          
          [cell initForView];
          return cell;

      }
    else
    {
        static NSString *CellIdentifier4 = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier4];
        }
        
        return cell;
    }
    
    return nil;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if ((indexPath.row<_arrData.count)) {
        FeedObj *obj = [_arrData objectAtIndex:indexPath.row];
        int msgLength = obj.message.length;
        
        debug(@"heightForRowAtIndexPath -> %d with msg length -> %d",( 90+ (msgLength/40 +1)*12),msgLength);

        return ( 90+ (msgLength/40 +1 )*12);

    }
    
    return 140;
   
}

# pragma mark - FeedCellDelegate

- (void) feedCellDidActionComment:(FeedObj *)feedObj
{

    [self scrollToCommentCell];
   
}

- (void) feedCellDidActionShowUsersLike:(FeedObj *)feedObj
{
    ListLikesVC *vc = [[ListLikesVC alloc] initWithNibName:@"ListLikesVC" bundle:nil];
    vc.numberOfLikes = feedObj.numberOfLikes;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) feedCellDidActionProfile:(UserObj *)userObj
{
//    ProfileVC *vc = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
//    vc.user = userObj;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.navigationController.navigationBarHidden = NO;

}

#pragma mark - FeedDetailCellDelegate

- (void) feedDetailCellDidShowLikes:(FeedObj *) feedobj
{
    ListLikesVC *vc = [[ListLikesVC alloc] initWithNibName:@"ListLikesVC" bundle:nil];
    vc.numberOfLikes = feedobj.numberOfLikes;
    [self.navigationController pushViewController:vc animated:YES];

}



- (void) feedDetailCellDidActionProfile:(UserObj *)userObj
{
//    ProfileVC *vc = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
//    vc.user = userObj;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.navigationController.navigationBarHidden = NO;
}

# pragma mark - CommentCellDelegate

- (void) commenCellDidStartComment
{
    debug(@"commenCellDidStartComment");
//    [tbvFeeds setContentOffset:CGPointMake(0, 300) animated:YES];
    [self scrollToCommentCell];

}

- (void) commentCellDidSendMessage:(NSString *)msg
{
    debug(@"commentCellDidSendMessage");
    FeedObj *feedObj = [[FeedObj alloc] init];
    feedObj.user = [UserDefault userDefault].user;    
    feedObj.timestamp = @"Just now";
    feedObj.message = msg;
    feedObj.numberOfLikes = 0;
    feedObj.numberOfComments = 0;
    
    [self.arrData addObject:feedObj];
    
    [tbvFeeds reloadData];

}

# pragma mark - Others

- (void) scrollToCommentCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_arrData.count+1) inSection:0];
    [tbvFeeds scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewRowAnimationTop animated:YES];
    
       
}




@end
