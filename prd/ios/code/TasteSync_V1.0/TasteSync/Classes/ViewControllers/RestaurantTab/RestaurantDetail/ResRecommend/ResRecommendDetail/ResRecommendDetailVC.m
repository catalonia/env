//
//  ResRecommendDetailVC.m
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResRecommendDetailVC.h"
#import "FriendFilterCell.h"
#import "CommonHelpers.h"
#import "ResQuestionVC.h"
#import "RateCustom.h"
@interface ResRecommendDetailVC ()
{
    __weak IBOutlet UILabel *lbName,*lbDetail;
    __weak IBOutlet UILabel *lbTitle, *lbLikes;
    __weak IBOutlet UITextView *tvDetail;
    __weak IBOutlet UITableView *tbvUser;
    __weak IBOutlet UIButton *btFollow,*btLike;
    __weak IBOutlet UIImageView* _avatar;
    
    TextView* _textView;
    
}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionLike:(id)sender;
- (IBAction)actionFollow:(id)sender;
- (IBAction)actionQuestion:(id)sender;
- (IBAction)actionAvatar:(id)sender;

@end

@implementation ResRecommendDetailVC

@synthesize arrData=_arrData,
resRecommendObj =_resRecommendObj,
restaurantObj=_restaurantObj;

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
    [CommonHelpers setBackgroudImageForViewRestaurant:self.view];
    [self configView];
    if (!self.fromRecomendation) {
        RateCustom *rateCustom = [[RateCustom alloc] initWithFrame:CGRectMake(18, 103, 30, 4)];
        if (_restaurantObj.rates != 0) {
            [rateCustom setRateMedium:_restaurantObj.rates];
            [self.view addSubview:rateCustom];
            rateCustom.allowedRate = NO;
        }
    }
    
    _textView = [[TextView alloc]initWithFrame:CGRectMake(10, 180, 280, 53)];
    _textView.textView.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    [_textView.textView setBackgroundColor:[UIColor whiteColor]];
    [_textView.textView setTextColor:[UIColor blackColor]];
    _textView.delegate = self;
    _textView.textView.hidden = YES;
    [self.view addSubview:_textView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction's define


- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionShare:(id)sender
{
//    [CommonHelpers showShareView:nil andObj:_restaurantObj];
}
- (IBAction)actionSentMessage:(id)sender
{
    NSLog(@"%@",_textView.textView.text);
}
- (IBAction)actionLike:(id)sender
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [[CommonHelpers appDelegate] showLoginDialog];
    }
    else
    {
        if (_resRecommendObj.isLike) {
            _resRecommendObj.isLike = NO;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like.png"] forButton:btLike];
            _resRecommendObj.numberOfLikes --;
        }
        else
        {
            _resRecommendObj.isLike = YES;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like_on.png"] forButton:btLike];
            _resRecommendObj.numberOfLikes ++;
        }
        
        if (_resRecommendObj.numberOfLikes == 0) {
            lbLikes.hidden = YES;
        }
        else if (_resRecommendObj.numberOfLikes ==1)
        {
            lbLikes.hidden = NO;
            lbLikes.text = [NSString stringWithFormat:@"%d Like",_resRecommendObj.numberOfLikes];
            
        }
        else
        {
            lbLikes.hidden = NO;
            lbLikes.text = [NSString stringWithFormat:@"%d Likes",_resRecommendObj.numberOfLikes];
        }


    }
       
}
- (IBAction)actionFollow:(id)sender
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [[CommonHelpers appDelegate] showLoginDialog];
    }
    else
    {
        btFollow.hidden = YES;

    }
}
- (IBAction)actionQuestion:(id)sender
{
    ResQuestionVC *vc = [[ResQuestionVC alloc] initWithNibName:@"ResQuestionVC" bundle:nil];
    vc.restaurantObj = _restaurantObj;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionAvatar:(id)sender
{
    if (_resRecommendObj.tipID != TipFrom4SQ)
        [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:_resRecommendObj.user];
}

# pragma mark - others

- (void) configView
{
    if (self.fromRecomendation) {
        lbName.hidden = YES;
        lbDetail.hidden = YES;
        //lbLikes.text = [NSString stringWithFormat:@"%d people like this.",_resRecommendObj.numberOfLikes];
        
        lbTitle.text = _replyRecomendationObj.userObj.name;
        tvDetail.text = _replyRecomendationObj.replyText;
        
        
        if (_replyRecomendationObj.userObj.avatar != nil) {
            _avatar.image = _replyRecomendationObj.userObj.avatar;
        }
        else
            [NSThread detachNewThreadSelector:@selector(loadimagerecomend) toTarget:self withObject:nil];
    }
    else
    {
        if (_restaurantObj) {
            lbName.text = _restaurantObj.name;
            lbDetail.text = [CommonHelpers getInformationRestaurant:self.restaurantObj];
            //lbLikes.text = [NSString stringWithFormat:@"%d people like this.",_resRecommendObj.numberOfLikes];
            
            if (_resRecommendObj.tipID == TipNone) {
                lbTitle.text = _resRecommendObj.title;
                tvDetail.text = [NSString stringWithFormat:@"%@ \n in response to your question - %@",_resRecommendObj.detail, _resRecommendObj.recotext];
            }
            else
            {
                lbTitle.text = _resRecommendObj.user.name;
                tvDetail.text = _resRecommendObj.detail;
            }
            
            if (_resRecommendObj.user.avatar != nil) {
                _avatar.image = _resRecommendObj.user.avatar;
            }
            else
                [NSThread detachNewThreadSelector:@selector(loadimage) toTarget:self withObject:nil];
        }
    }
    
    
}
-(void)loadimage
{
    _avatar.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_resRecommendObj.user.avatarUrl]]];
}
-(void)loadimagerecomend
{
    _avatar.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_replyRecomendationObj.userObj.avatarUrl]]];
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
    //NSLog(@"Line: %f", _textView.textView.contentSize.height);
}
-(void)enterSearchObject:(NSString *)text
{
    NSLog(@"%@",text);
   // [self searchLocal:text];
}
-(void)beginEditting
{
    //lbHoverSendMsg.hidden = YES;
    
}
@end
