//
//  ProfileVC.m
//  TasteSync
//
//  Created by Victor on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "ProfileVC.h"
#import "CommonHelpers.h"
#import "SelfProfileVC.h"
#import "UsersFollowing.h"
#import "RestaurantDetailVC.h"
#import "FacebookFriendsVC.h"
#import "TasteSyncFriends.h"
#import "blogger.h"
#import "PromptSignUpVC.h"
#import "DetailedStoryVC.h"
#import "EditAboutMeVC.h"
#import "RestaurantListsVC.h"
#import "UserActivityProfileCell.h"
@interface ProfileVC ()<UIAlertViewDelegate>
{
    
    BOOL trusted,follow;
    
    NSString* facebookURL, *twiterURL, *blogURL;
    RestaurantObj *_restaurantObj1;
    RestaurantObj *_restaurantObj2;
    RestaurantObj *_restaurantObj3;
    NSMutableArray *_arrayData;
    NSMutableArray *_arryRestaurantsVisible;
    NSMutableArray *_arryListRestaurantShort;
    
    NSMutableArray* _arrayFollowing;
    NSMutableArray* _arrayFriendUser;
    
    __weak IBOutlet UITableView *tbvResult;
    __weak IBOutlet UIActivityIndicatorView* activity1;
    __weak IBOutlet UIActivityIndicatorView* activity2;
    __weak IBOutlet UIActivityIndicatorView* activity3;
    __weak IBOutlet UIView* actionView;
    TextView* _textView;
}
- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;
- (IBAction)actionCountinueReading:(id)sender;

@end

@implementation ProfileVC
@synthesize user=_user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textView = [[TextView alloc]initWithFrame:CGRectMake(8, 26, 272, 60)];
    _textView.textView.font = [UIFont fontWithName:@"Avenir Medium" size:12.0];
    [_textView.textView setBackgroundColor:[UIColor clearColor]];
    [tvSendMsg removeFromSuperview];
    _textView.delegate = self;
    [viewSendMsg addSubview:_textView];
    tbvResult.hidden = YES;
    facebookURL     = @"";
    twiterURL       = @"";
    blogURL    = @"";
    lbYouFollow.text = [NSString stringWithFormat:@"You follow %@",_user.name];
    lbAboutTitle.text = [NSString stringWithFormat:@"About %@", _user.name];
    
    _restaurantObj1 = [[RestaurantObj alloc]init];
    _restaurantObj2 = [[RestaurantObj alloc]init];
    _restaurantObj3 = [[RestaurantObj alloc]init];
    _arrayData = [[NSMutableArray alloc]init];
    _arryRestaurantsVisible = [[NSMutableArray alloc]init];
    _arryListRestaurantShort = [[NSMutableArray alloc]init];
    
    [CommonHelpers setBackgroudImageForView:self.view];
    [self.navigationController setNavigationBarHidden:YES];
    [scrollView setContentSize:CGSizeMake(320, 750)];
    recentlyView.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CRequest* request = [[CRequest alloc]initWithURL:@"getHomeProfile" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:1 WithView:self.view];
    request.delegate = self;
    [request setFormPostValue:self.userID forKey:@"userId"];
    [request startFormRequest];
    
    CRequest* request2 = [[CRequest alloc]initWithURL:@"showFollowStatus" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:2 WithView:self.view];
    request2.delegate = self;
    [request2 setFormPostValue:[UserDefault userDefault].userID forKey:@"followerUserId"];
    [request2 setFormPostValue:self.userID forKey:@"followeeUserId"];
    [request2 startFormRequest];
    
    CRequest* request3 = [[CRequest alloc]initWithURL:@"showTrustedFriend" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:3 WithView:self.view];
    request3.delegate = self;
    [request3 setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
    [request3 setFormPostValue:self.userID forKey:@"destUserId"];
    [request3 startFormRequest];
    
    CRequest* request4 = [[CRequest alloc]initWithURL:@"showProfileFollowers" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:7 WithView:self.view];
    request4.delegate = self;
    [request4 setFormPostValue:self.userID forKey:@"userId"];
    [request4 startFormRequest];
    
    CRequest* request5 = [[CRequest alloc]initWithURL:@"showProfileFriends" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:8 WithView:self.view];
    request5.delegate = self;
    [request5 setFormPostValue:self.userID forKey:@"userId"];
    [request5 startFormRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 

}

- (void) configView
{
    lbName.text = [NSString stringWithFormat:@"%@", _user.name];
    lbAboutTitle.text = [NSString stringWithFormat:@"About %@", _user.name];
    
    if (_user.city == nil) {
        _user.city = self.user.hometown_location;
    }
    if (_user.state == nil) {
        _user.state = self.user.location;
    }
    if (_user.avatar == nil) {
        [NSThread detachNewThreadSelector:@selector(loadAvatar) toTarget:self withObject:nil];
    }
    else
        ivAvatar.image = _user.avatar;
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        lbYouFollow.hidden = YES;
    }
}

# pragma mark - IBAction's define

- (IBAction)actionReportUser:(id)sender
{
    debug(@"report msg -> %@", _textView.textView.text);
    if (tvReportUser.text.length > 0) {
        
        CRequest* request = [[CRequest alloc]initWithURL:@"submitUserReport" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm WithView:self.view];
        request.delegate = self;
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
        [request setFormPostValue:self.userID forKey:@"reportedUserId"];
        [request setFormPostValue:tvReportUser.text forKey:@"reason"];
        [request startFormRequest];
        
        viewReportUser.hidden = YES;
        [tvReportUser resignFirstResponder];
    }
   
}

- (IBAction)actionCancel:(id)sender
{
    viewReportUser.hidden = YES;
    [tvReportUser resignFirstResponder];
    [tvReportUser resignFirstResponder];

}

- (IBAction)actionCancelSendMsg:(id)sender
{
    [_textView.textView resignFirstResponder];
    viewSendMsg.hidden = YES;
}

- (IBAction)actionSendMsg:(id)sender
{
    NSLog(@"report msg -> %@",  _textView.textView.text);
    if (_textView.textView.text.length > 0) {
        CRequest* request = [[CRequest alloc]initWithURL:@"sendMessageToUser" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm WithView:self.view];
        request.delegate = self;
         [request setFormPostValue:[UserDefault userDefault].deviceToken forKey:@"devicetoken"];
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"senderID"];
        [request setFormPostValue:self.userID forKey:@"recipientID"];
        [request setFormPostValue:_textView.textView.text forKey:@"content"];
        [request startFormRequest];
        
        [_textView.textView resignFirstResponder];
        viewSendMsg.hidden = YES;
    }
}

- (IBAction)actionTrusted:(id)sender
{
    
    BOOL cantrust = NO;
    for (UserObj*obj in _arrayFriendUser) {
        if ([[NSString stringWithFormat:@"%@",self.userID] isEqualToString:[NSString stringWithFormat:@"%@",obj.uid]]) {
            cantrust = YES;
        }
    }
    if (cantrust) {
        NSString* trustedFriend;
        if (trusted) {
            trustedFriend = @"0";
        }else
        {
            trustedFriend = @"1";
        }
        
        CRequest* request = [[CRequest alloc]initWithURL:@"submitTrustedFriendStatusChange" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:5 WithView:self.view];
        request.delegate = self;
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
        [request setFormPostValue:self.userID forKey:@"destUserId"];
        [request setFormPostValue:trustedFriend forKey:@"trustedFriendStatus"];
        [request startFormRequest];
    }
    else
    {
        [CommonHelpers showConfirmAlertWithTitle:@"TasteSync" message:@"To trust your friend, this user is your facebook friend." delegate:nil tag:0];
    }
    
    
}
- (IBAction)actionReport:(id)sender
{
    debug(@"actionReport");
    
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [self alertSignUp];
    }
    else
    {
        
        debug(@"report view appear");        
        viewReportUser.hidden = NO;
        [tvReportUser becomeFirstResponder];
    }
}
- (IBAction)actionUnfollow:(id)sender
{
    NSString* followStatus;
    if (follow) {
        followStatus = @"0";

    }else
    {
        followStatus = @"1";
    }
    
    CRequest* request = [[CRequest alloc]initWithURL:@"submitFollowUserStatusChange" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:4 WithView:self.view];
    request.delegate = self;
    [request setFormPostValue:[UserDefault userDefault].userID forKey:@"followerUserId"];
    [request setFormPostValue:self.userID forKey:@"followeeUserId"];
    [request setFormPostValue:followStatus forKey:@"statusFlag"];
    [request startFormRequest];
}
- (IBAction)actionSend:(id)sender
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [self alertSignUp];
    }
    else
    {
        BOOL canSend = NO;
        for (UserObj*obj in _arrayFollowing) {
            if ([[NSString stringWithFormat:@"%@",self.userID] isEqualToString:[NSString stringWithFormat:@"%@",obj.uid]]) {
                canSend = YES;
            }
        }
        for (UserObj*obj in _arrayFriendUser) {
            if ([[NSString stringWithFormat:@"%@",self.userID] isEqualToString:[NSString stringWithFormat:@"%@",obj.uid]]) {
                canSend = YES;
            }
        }
        if (canSend) {
            [_textView removeFromSuperview];
            _textView = [[TextView alloc]initWithFrame:CGRectMake(8, 26, 272, 60)];
            _textView.textView.font = [UIFont fontWithName:@"Avenir Medium" size:12.0];
            [_textView.textView setBackgroundColor:[UIColor clearColor]];
            [tvSendMsg removeFromSuperview];
            _textView.delegate = self;
            [viewSendMsg addSubview:_textView];
            viewSendMsg.hidden = NO;
            lbHoverSendMsg.hidden = NO;
            [_textView.textView becomeFirstResponder];
        }
        else
        {
            [CommonHelpers showConfirmAlertWithTitle:@"TasteSync" message:@"To sent message, this user should follow you or this is your facebook friend." delegate:nil tag:0];
        }
    }

}
- (IBAction)actionFollowing:(id)sender
{
    UsersFollowing *vc = [[UsersFollowing alloc]initWithNibName:@"UsersFollowing" bundle:nil];
   
    vc.viewFollowing = YES;
    vc.user = _user;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)actionFollowers:(id)sender
{
    UsersFollowing *vc = [[UsersFollowing alloc]initWithNibName:@"UsersFollowing" bundle:nil];
    vc.viewFollowing = NO;
    vc.user = _user;
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)actionFriends:(id)sender
{
    TasteSyncFriends *vc = [[TasteSyncFriends alloc]initWithNibName:@"TasteSyncFriends" bundle:nil];
    vc.user = self.user;
    vc.userID = self.userID;
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (IBAction)actionRestaurant:(id)sender
{
    debug(@"actionRestaurant");
    /*
    RestaurantObj *obj = [[RestaurantObj alloc] init];
    obj.name = @"Test Restaurant";
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionSelectRestaurant:obj checkBack:YES];
     
     */
    RestaurantListsVC *vc = [[RestaurantListsVC alloc] initWithNibName:@"RestaurantListsVC" bundle:nil];
    vc.userObj = _user;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)actionMoreRestaurant:(id)sender
{
    RestaurantListsVC *vc = [[RestaurantListsVC alloc] initWithNibName:@"RestaurantListsVC" bundle:nil];
    vc.userObj = _user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionFacebook:(id)sender
{
    if (![facebookURL isEqualToString:@""] && facebookURL != NULL) {
        NSURL *url = [ [ NSURL alloc ] initWithString: facebookURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
- (IBAction)actionTwitter:(id)sender
{
    if (![twiterURL isEqualToString:@""] && twiterURL != NULL) {
        NSURL *url = [ [ NSURL alloc ] initWithString: twiterURL ];
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (IBAction)actionBlog:(id)sender
{
    if (![blogURL isEqualToString:@""] && blogURL != NULL) {
        NSURL *url = [ [ NSURL alloc ] initWithString: blogURL ];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (IBAction)actionCountinueReading:(id)sender
{
    EditAboutMeVC *vc = [[EditAboutMeVC alloc] initWithNibName:@"EditAboutMeVC" bundle:nil];
    vc.isYourProfile = NO;
    vc.aboutText = lbAboutDetail.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNewsfeed:(id)sender
{
//    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
    
    [self shareProfile];
}



- (IBAction)promptSignUp:(id)sender
{
    PromptSignUpVC *promtpSignUpVC = [[PromptSignUpVC alloc]initWithNibName:@"PromptSignUpVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:promtpSignUpVC animated:NO];
}


#pragma mark - MFMessageDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"message Cancelled");
			break;
		case MessageComposeResultFailed:
            NSLog(@"message Faild");
			break;
		case MessageComposeResultSent:
            NSLog(@"message Result Sent");
			break;
		default:
            NSLog(@"message state other");
			break;
	}
    
	[self dismissViewControllerAnimated:YES  completion:nil];
}


- (void)shareProfile
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:APP_NAME delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", @"Tumblr",@"Email", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}





#pragma mark - UITableViewDataSource, UITableViewDelegate

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 10;
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"user_activity_profile_cell";
//    UserActivityProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        
//     
//      cell = (UserActivityProfileCell *) [[[NSBundle mainBundle] loadNibNamed:@"UserActivityProfileCell" owner:self options:nil] objectAtIndex:0];
//    }
//    
//    UserActivityObj *obj = [[UserActivityObj alloc] init];
//    UserObj *user = [[UserObj alloc] init];
//    user.firstname = @"Victor";
//    user.lastname = @"Ngo";
//    user.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
//    obj.user = user;
//    obj.content = @"recommended ...";    
//    
//    [cell initCell:obj];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DetailedStoryVC *detailStoryVC = [[DetailedStoryVC alloc]initWithNibName:@"DetailedStoryVC" bundle: [NSBundle mainBundle]];
//    [self.navigationController pushViewController:detailStoryVC animated:YES];
//}

- (void) alertSignUp
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Please sign-up to use this function." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    alertView.tag = 100;
    [alertView show];
}

# pragma mark - UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag ==100) {
            [[CommonHelpers appDelegate] showLoginDialog];

        }
    }
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    debug(@"actionSheetDelegate - buttonIndex -> %d", buttonIndex);

    switch (buttonIndex) {
        case 0:
        {
        }
            break;
            
        default:
            break;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tvReportUser resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if (textView.text.length != 0) {
       
    }
    else
    {
        if (textView == tvReportUser) {
            lbHoverReport.hidden = NO;
        }else if (textView == _textView.textView)
        {
            lbHoverSendMsg.hidden = NO;
        }

    }

    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == tvReportUser) {
        lbHoverReport.hidden = YES;
    }else if (textView == _textView.textView)
    {
        lbHoverSendMsg.hidden = YES;
    }
    
    return YES;
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (key == 1) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@",response);
        if (response != NULL) {
            NSDictionary* dic = [response objectFromJSONString];
            lbFollowing.text = [dic objectForKey:@"numFollowers"];
            lbFollowers.text = [dic objectForKey:@"numFollowees"];
            lbFriends.text = [dic objectForKey:@"numFriendsOnTs"];
            lbPoints.text = [dic objectForKey:@"numPoints"];
            lbAboutDetail.text = [dic objectForKey:@"aboutMeText"];
            lbDetail.text = [dic objectForKey:@"facebookCity"];
            
            facebookURL = [dic objectForKey:@"facebookUrl"];
            twiterURL   = [dic objectForKey:@"twitterUrl"];
            blogURL     = [dic objectForKey:@"blogUrl"];
            
            NSArray* restaurantArray = [dic objectForKey:@"restaurantList"];
            if ([restaurantArray count] == 0) {
                lbRestaurant1.hidden = YES;
                lbRestaurant2.hidden = YES;
                lbRestaurant3.hidden = YES;
                btRestaurant1.hidden = YES;
                btRestaurant2.hidden = YES;
                btRestaurant3.hidden = YES;
                activity1.hidden = YES;
                activity2.hidden = YES;
                activity3.hidden = YES;
                
                
            }
            if ([restaurantArray count] == 1) {
                lbRestaurant2.hidden = YES;
                lbRestaurant3.hidden = YES;
                btRestaurant2.hidden = YES;
                btRestaurant3.hidden = YES;
                activity2.hidden = YES;
                activity3.hidden = YES;
                
                NSDictionary* dicRes = [restaurantArray objectAtIndex:0];
                _restaurantObj1.uid = [dicRes objectForKey:@"id"];
                
                NSDictionary* dicInformation = [dicRes objectForKey:@"information"];
                _restaurantObj1.name = [dicInformation objectForKey:@"restaurantName"];
                _restaurantObj1.cuisineTier2 = [dicInformation objectForKey:@"cuisineTier2Name"];
                _restaurantObj1.price = [dicInformation objectForKey:@"price"];
                _restaurantObj1.cityObj.cityName = [dicInformation objectForKey:@"restaurantCity"];
                _restaurantObj1.lattitude = [[dicInformation objectForKey:@"restaurantLat"] floatValue];
                _restaurantObj1.longtitude = [[dicInformation objectForKey:@"restaurantLong"] floatValue];
                _restaurantObj1.rates = [[dicInformation objectForKey:@"restaurantRating"] floatValue];
                
                NSDictionary* photo = [dicRes objectForKey:@"photo"];
                NSString* str = [photo objectForKey:@"prefix"];
                if (![str isKindOfClass:([NSNull class])]) {
                    _restaurantObj1.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo objectForKey:@"prefix"],[photo objectForKey:@"width"],[photo objectForKey:@"height"],[photo objectForKey:@"suffix"]];
                    
                    NSLog(@"restaurantObj1.imageUrl: %@", _restaurantObj1.imageUrl);
                    [NSThread detachNewThreadSelector:@selector(loadImageRestaurant1) toTarget:self withObject:nil];
                    [activity1 startAnimating];
                }
                else
                {
                    activity1.hidden = YES;
                }
                
                lbRestaurant1.text = _restaurantObj1.name;
                
                [_arryRestaurantsVisible addObject:_restaurantObj1];
                
                
            }
            if ([restaurantArray count] == 2) {
                lbRestaurant3.hidden = YES;
                btRestaurant3.hidden = YES;
                activity3.hidden = YES;
                
                NSDictionary* dicRes = [restaurantArray objectAtIndex:0];
                _restaurantObj1.uid = [dicRes objectForKey:@"id"];
                
                NSDictionary* dicInformation = [dicRes objectForKey:@"information"];
                _restaurantObj1.name = [dicInformation objectForKey:@"restaurantName"];
                _restaurantObj1.cuisineTier2 = [dicInformation objectForKey:@"cuisineTier2Name"];
                _restaurantObj1.price = [dicInformation objectForKey:@"price"];
                _restaurantObj1.cityObj.cityName = [dicInformation objectForKey:@"restaurantCity"];
                _restaurantObj1.lattitude = [[dicInformation objectForKey:@"restaurantLat"] floatValue];
                _restaurantObj1.longtitude = [[dicInformation objectForKey:@"restaurantLong"] floatValue];
                _restaurantObj1.rates = [[dicInformation objectForKey:@"restaurantRating"] floatValue];
                
                NSDictionary* photo = [dicRes objectForKey:@"photo"];
                NSString* str = [photo objectForKey:@"prefix"];
                if (![str isKindOfClass:([NSNull class])]) {
                    _restaurantObj1.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo objectForKey:@"prefix"],[photo objectForKey:@"width"],[photo objectForKey:@"height"],[photo objectForKey:@"suffix"]];
                    NSLog(@"restaurantObj1.imageUrl: %@", _restaurantObj1.imageUrl);
                    [NSThread detachNewThreadSelector:@selector(loadImageRestaurant1) toTarget:self withObject:nil];
                    [activity1 startAnimating];
                }
                else
                {
                    activity1.hidden = YES;
                }
                lbRestaurant1.text = _restaurantObj1.name;
                NSLog(@"lbRestaurant1.text: %@", [dicRes objectForKey:@"name"]);
                [_arryRestaurantsVisible addObject:_restaurantObj1];
                
                NSDictionary* dicRes2 = [restaurantArray objectAtIndex:1];
                _restaurantObj2.uid = [dicRes2 objectForKey:@"id"];
                
                NSDictionary* dicInformation2 = [dicRes2 objectForKey:@"information"];
                _restaurantObj2.name = [dicInformation2 objectForKey:@"restaurantName"];
                _restaurantObj2.cuisineTier2 = [dicInformation2 objectForKey:@"cuisineTier2Name"];
                _restaurantObj2.price = [dicInformation2 objectForKey:@"price"];
                _restaurantObj2.cityObj.cityName = [dicInformation2 objectForKey:@"restaurantCity"];
                _restaurantObj2.lattitude = [[dicInformation2 objectForKey:@"restaurantLat"] floatValue];
                _restaurantObj2.longtitude = [[dicInformation2 objectForKey:@"restaurantLong"] floatValue];
                _restaurantObj2.rates = [[dicInformation2 objectForKey:@"restaurantRating"] floatValue];
                
                NSDictionary* photo2 = [dicRes2 objectForKey:@"photo"];
                NSString* str2 = [photo2 objectForKey:@"prefix"];
                if (![str2 isKindOfClass:([NSNull class])]) {
                    _restaurantObj2.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo2 objectForKey:@"prefix"],[photo2 objectForKey:@"width"],[photo2 objectForKey:@"height"],[photo2 objectForKey:@"suffix"]];
                    NSLog(@"restaurantObj1.imageUrl: %@", _restaurantObj2.imageUrl);
                    [NSThread detachNewThreadSelector:@selector(loadImageRestaurant2) toTarget:self withObject:nil];
                    [activity2 startAnimating];
                }
                else
                {
                    activity2.hidden = YES;
                }
                lbRestaurant2.text = _restaurantObj2.name;
                [_arryRestaurantsVisible addObject:_restaurantObj2];
                
            }
            if ([restaurantArray count] == 3) {
                NSDictionary* dicRes = [restaurantArray objectAtIndex:0];
                _restaurantObj1.uid = [dicRes objectForKey:@"id"];
                
                NSDictionary* dicInformation = [dicRes objectForKey:@"information"];
                _restaurantObj1.name = [dicInformation objectForKey:@"restaurantName"];
                _restaurantObj1.cuisineTier2 = [dicInformation objectForKey:@"cuisineTier2Name"];
                _restaurantObj1.price = [dicInformation objectForKey:@"price"];
                _restaurantObj1.cityObj.cityName = [dicInformation objectForKey:@"restaurantCity"];
                _restaurantObj1.lattitude = [[dicInformation objectForKey:@"restaurantLat"] floatValue];
                _restaurantObj1.longtitude = [[dicInformation objectForKey:@"restaurantLong"] floatValue];
                _restaurantObj1.rates = [[dicInformation objectForKey:@"restaurantRating"] floatValue];
                
                NSDictionary* photo = [dicRes objectForKey:@"photo"];
                NSString* str = [photo objectForKey:@"prefix"];
                if (![str isKindOfClass:([NSNull class])]) {
                    _restaurantObj1.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo objectForKey:@"prefix"],[photo objectForKey:@"width"],[photo objectForKey:@"height"],[photo objectForKey:@"suffix"]];
                    NSLog(@"restaurantObj1.imageUrl: %@", _restaurantObj1.imageUrl);
                    [NSThread detachNewThreadSelector:@selector(loadImageRestaurant1) toTarget:self withObject:nil];
                    [activity1 startAnimating];
                }
                else
                {
                    activity1.hidden = YES;
                }
                lbRestaurant1.text = _restaurantObj1.name;
                [_arryRestaurantsVisible addObject:_restaurantObj1];
                
                NSDictionary* dicRes2 = [restaurantArray objectAtIndex:1];
                _restaurantObj2.uid = [dicRes2 objectForKey:@"id"];
                
                NSDictionary* dicInformation2 = [dicRes2 objectForKey:@"information"];
                _restaurantObj2.name = [dicInformation2 objectForKey:@"restaurantName"];
                _restaurantObj2.cuisineTier2 = [dicInformation2 objectForKey:@"cuisineTier2Name"];
                _restaurantObj2.price = [dicInformation2 objectForKey:@"price"];
                _restaurantObj2.cityObj.cityName = [dicInformation2 objectForKey:@"restaurantCity"];
                _restaurantObj2.lattitude = [[dicInformation2 objectForKey:@"restaurantLat"] floatValue];
                _restaurantObj2.longtitude = [[dicInformation2 objectForKey:@"restaurantLong"] floatValue];
                _restaurantObj2.rates = [[dicInformation2 objectForKey:@"restaurantRating"] floatValue];
                
                NSDictionary* photo2 = [dicRes2 objectForKey:@"photo"];
                NSString* str2 = [photo2 objectForKey:@"prefix"];
                if (![str2 isKindOfClass:([NSNull class])]) {
                    _restaurantObj2.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo2 objectForKey:@"prefix"],[photo2 objectForKey:@"width"],[photo2 objectForKey:@"height"],[photo2 objectForKey:@"suffix"]];
                    NSLog(@"restaurantObj1.imageUrl: %@", _restaurantObj2.imageUrl);
                    [NSThread detachNewThreadSelector:@selector(loadImageRestaurant2) toTarget:self withObject:nil];
                    [activity2 startAnimating];
                }
                else
                {
                    activity2.hidden = YES;
                }
                lbRestaurant2.text = _restaurantObj2.name;
                [_arryRestaurantsVisible addObject:_restaurantObj2];
                
                NSDictionary* dicRes3 = [restaurantArray objectAtIndex:2];
                _restaurantObj3.uid = [dicRes3 objectForKey:@"id"];
                
                NSDictionary* dicInformation3 = [dicRes3 objectForKey:@"information"];
                _restaurantObj3.name = [dicInformation3 objectForKey:@"restaurantName"];
                _restaurantObj3.cuisineTier2 = [dicInformation3 objectForKey:@"cuisineTier2Name"];
                _restaurantObj3.price = [dicInformation3 objectForKey:@"price"];
                _restaurantObj3.cityObj.cityName = [dicInformation3 objectForKey:@"restaurantCity"];
                _restaurantObj3.lattitude = [[dicInformation3 objectForKey:@"restaurantLat"] floatValue];
                _restaurantObj3.longtitude = [[dicInformation3 objectForKey:@"restaurantLong"] floatValue];
                _restaurantObj3.rates = [[dicInformation3 objectForKey:@"restaurantRating"] floatValue];
                
                NSDictionary* photo3 = [dicRes3 objectForKey:@"photo"];
                NSString* str3 = [photo3 objectForKey:@"prefix"];
                if (![str3 isKindOfClass:([NSNull class])]) {
                    _restaurantObj3.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo3 objectForKey:@"prefix"],[photo3 objectForKey:@"width"],[photo3 objectForKey:@"height"],[photo3 objectForKey:@"suffix"]];
                    NSLog(@"restaurantObj2.imageUrl: %@", _restaurantObj3.imageUrl);
                    [NSThread detachNewThreadSelector:@selector(loadImageRestaurant3) toTarget:self withObject:nil];
                    [activity3 startAnimating];
                }
                else
                {
                    activity3.hidden = YES;
                }
                lbRestaurant3.text = _restaurantObj3.name;
                
                [_arryRestaurantsVisible addObject:_restaurantObj3];
            }
        }
    }
    if (key == 2) {
        NSLog(@"Response2: %@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSString* str = [dic objectForKey:@"successMsg"];
        if (str != (id)[NSNull null] && str != NULL) {
            NSLog(@"UserID_Profile: %@", str);
            
            if ([str isEqualToString:@"1"]) {
                follow = YES;
                lbFollow.text = @"Unfollow";
                lbYouFollow.hidden = NO;
            }
            else
            {
                follow = NO;
                lbFollow.text= @"Follow";
                lbYouFollow.hidden = YES;
            }
        }
    }
    if (key == 3) {
        NSLog(@"Response3: %@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSString* str = [dic objectForKey:@"successMsg"];
        if (str != (id)[NSNull null] && str != NULL) {
            NSLog(@"UserID_Profile: %@", str);
            if ([str isEqualToString:@"trusted"]) {
                trusted = YES;
                lbTrust.text = @"Trusted";
            }
            else
                if ([str isEqualToString:@"not trust"])
                {
                    trusted = NO;
                    lbTrust.text= @"Add Friend";
                }
                else
                {
                    trusted = NO;
                    lbTrust.text= @"Add Friend";
                }
        }
        [self configView];
    }
    if (key == 4) {
        NSLog(@"Response4: %@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSString* str = [dic objectForKey:@"successMsg"];
        if ( str != NULL) {
            if (follow) {
                lbFollow.text= @"Follow";
                follow = NO;
                lbYouFollow.hidden = YES;
                
            }else
            {
                lbFollow.text = @"Unfollow";
                follow = YES;
                lbYouFollow.hidden = NO;
            }
        }
        else
        {
            if (follow) {
                lbFollow.text= @"Follow";
                follow = NO;
                lbYouFollow.hidden = YES;
                
            }else
            {
                lbFollow.text = @"Unfollow";
                follow = YES;
                lbYouFollow.hidden = NO;
            }
        }
    }
    if (key == 5) {
        NSLog(@"Response5: %@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSString* str = [dic objectForKey:@"successMsg"];
        if ( str != NULL) {
            if (trusted) {
                lbTrust.text= @"Add Friend";
                trusted = NO;
            }else
            {
                lbTrust.text = @"Trusted";
                trusted = YES;
            }
        }
        else
        {
            if (trusted) {
                lbTrust.text= @"Add Friend";
                trusted = NO;
            }else
            {
                lbTrust.text = @"Trusted";
                trusted = YES;
            }
        }
    }
    if (key == 6) {
        NSLog(@"Response: %@",response);
        [_arrayData removeAllObjects];
        NSArray* array = [response objectFromJSONString];
        for (NSDictionary* dic in array) {
            
            RestaurantObj* restaurantObj = [[RestaurantObj alloc]init];
            
            restaurantObj.uid                              =  [dic objectForKey:@"restaurantId"];
            restaurantObj.name                          = [dic objectForKey:@"restaurantName"];
            [_arrayData addObject:restaurantObj];
        }
        [tbvResult reloadData];
    }
    if (key == 0) {
        [_textView.textView resignFirstResponder];
        [tvReportUser resignFirstResponder];
    }
    if (key == 7) {
        _arrayFollowing = [[NSMutableArray alloc]init];
        NSArray* array = [response objectFromJSONString];
        for (NSDictionary* dic in array) {
            UserObj* obj = [[UserObj alloc]init];
            obj.name = [dic objectForKey:@"name"];
            obj.uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]];
            obj.avatarUrl = [dic objectForKey:@"photo"];
           
            if (![obj.uid isEqualToString:[NSString stringWithFormat:@"%@",self.userID]]) {
                [_arrayFollowing addObject:obj];
            }
        }
    }
    if (key == 8) {
        _arrayFriendUser = [[NSMutableArray alloc]init];
        NSDictionary* dic = [response objectFromJSONString];
        NSArray* arrayFriend = [dic objectForKey:@"friendTasteSync"];
        //    NSArray* arrayInviteFriend = [dic objectForKey:@"inviteFriend"];
        
        //    NSMutableArray* arrayFriendReload = [[NSMutableArray alloc]init];
        //    int i = 0;
        
        for (NSDictionary* dic in arrayFriend) {
            UserObj* userObject = [[UserObj alloc]init];
            userObject.uid = [dic objectForKey:@"userId"];
            userObject.name = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"tsFirstName"], [dic objectForKey:@"tsLastName"]];
            userObject.avatarUrl = [dic objectForKey:@"photo"];
            [_arrayFriendUser addObject:userObject];
        }
    }
    actionView.hidden = YES;
}
-(void)loadImageRestaurant1
{
    [btRestaurant1 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj1.imageUrl]]] forState:UIControlStateHighlighted];
    [btRestaurant1 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj1.imageUrl]]] forState:UIControlStateNormal];
    [activity1 stopAnimating];
    [activity1 setHidden:YES];
}
-(void)loadImageRestaurant2
{
    [btRestaurant2 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj2.imageUrl]]] forState:UIControlStateHighlighted];
    [btRestaurant2 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj2.imageUrl]]] forState:UIControlStateNormal];
    [activity2 stopAnimating];
    [activity2 setHidden:YES];
}
-(void)loadImageRestaurant3
{
    [btRestaurant3 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj3.imageUrl]]] forState:UIControlStateHighlighted];
    [btRestaurant3 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj3.imageUrl]]] forState:UIControlStateNormal];
    [activity3 stopAnimating];
    [activity3 setHidden:YES];
}

#pragma mark TableViewDelegate & TableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"UITableViewCell";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
        
    RestaurantObj *obj = [_arrayData objectAtIndex:indexPath.row];
        
    cell.textLabel.text = obj.name;
    NSLog(@"- %@",obj.name);
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
        //        cell.textLabel.textAlignment = UITextAlignmentRight;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
        
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    RestaurantObj *obj = [_arrayData objectAtIndex:indexPath.row];
    [_textView addRestaurant:obj];
    tbvResult.hidden= YES;
    [_arrayData removeAllObjects];
    
}
- (void) searchLocal:(NSString *)txt
{
    //NSString *str = [NSString stringWithFormat:@"name MATCHES[cd] '%@.*'", [CommonHelpers trim:txt]];
    tbvResult.hidden = YES;
    [_arrayData removeAllObjects];
    
    if (txt.length == 0) {
        return;
        
    }
    
    if (txt.length >= 1) {
        {
            tbvResult.hidden = NO;
            TSGlobalObj* region = [CommonHelpers getDefaultCityObj];
            CRequest* request = [[CRequest alloc]initWithURL:@"suggestrestaurantnames" RQType:RequestTypePost RQData:RequestPopulate RQCategory:ApplicationForm withKey:6 WithView:self.view];
            request.delegate = self;
            [request setFormPostValue:txt forKey:@"key"];
            [request setFormPostValue:region.cityObj.uid forKey:@"cityid"];
            [request startFormRequest];
            
            //requestText = txt;
        }
    }
}
#pragma mark TextviewDelegate
-(void)addNewObject:(HighlightText *)object
{
   // [_arrayData addObject:object.userObj];
}
-(void)removeObject:(HighlightText *)object
{
   // [_arrayData removeObject:object.userObj];
}
-(void)enterCharacter:(NSString *)text
{
    NSLog(@"Line: %f", _textView.textView.contentSize.height);
}
-(void)enterSearchObject:(NSString *)text
{
    NSLog(@"%@",text);
    [self searchLocal:text];
}
-(void)beginEditting
{
    lbHoverSendMsg.hidden = YES;
}
-(void)loadAvatar
{
    _user.avatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_user.avatarUrl]]];
    ivAvatar.image = _user.avatar;
}
@end
