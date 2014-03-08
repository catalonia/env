//
//  SocialNetworks.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "SocialNetworksVC.h"
#import "CommonHelpers.h"


@interface SocialNetworksVC ()
{
    UIImage *_imageOn;
    UIImage *_imgageOff;
    __weak IBOutlet UIScrollView *scrollViewMain;
}
- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;

@end

@implementation SocialNetworksVC

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
    [CommonHelpers setBackgroudImageForView:self.view];

    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    self.listCheckStateOfAllConnections = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
    
    self.listCheckStateOfAllPublishing = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
    
    _imageOn = [CommonHelpers getImageFromName:@"on.png"];
    _imgageOff = [CommonHelpers getImageFromName:@"off.png"];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CRequest* request = [[CRequest alloc]initWithURL:@"showSettingsSocial" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm WithView:self.view];
    request.delegate = self;
    [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
    [request startFormRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI
{
    [scrollViewMain setContentSize:CGSizeMake(320, 200)];
}

- (void)setStateForSwitchs:(NSMutableArray *)arrayState
{
    if (arrayState.count < 4) {
        return;
    }

    [self.btn_Facebook setImage:([(NSNumber *)arrayState[0] boolValue] == YES)?_imageOn:_imgageOff forState:UIControlStateNormal];
    [self.btn_Twitter setImage:([(NSNumber *)arrayState[1] boolValue] == YES)?_imageOn:_imgageOff forState:UIControlStateNormal];
    [self.btn_FourSquare setImage:([(NSNumber *)arrayState[2] boolValue] == YES)?_imageOn:_imgageOff forState:UIControlStateNormal];
    [self.btn_Tumblr setImage:([(NSNumber *)arrayState[3] boolValue] == YES)?_imageOn:_imgageOff forState:UIControlStateNormal];
    
    NSLog(@"list array state switch: %d",arrayState.count);

}

- (void)setStateForbuttonsCheck:(NSMutableArray *)arrayState
{
    UIButton *button = nil;
    NSLog(@"count array: %d",arrayState.count);
    for (int i = 0; i < arrayState.count; i++) {
        NSNumber *statechecked = arrayState[i];
        
        button = (UIButton *) [self.view viewWithTag:i + 1];
        if ([statechecked boolValue] == YES) {
             NSLog(@" checked %d = YES", i+1);
            [button setImage:[CommonHelpers getImageFromName:@"ic_check_on"] forState:UIControlStateNormal];
        }
        else{ // ischecked = NO
            NSLog(@" checked %d = NO", i+1);
            [button setImage:[CommonHelpers getImageFromName:@"ic_check"] forState:UIControlStateNormal];
        }

    }
    
}

- (IBAction)buttonSwitchTapper:(UIButton *)button
{
    NSNumber *item = self.listCheckStateOfAllConnections[button.tag - 100];
    BOOL ischecked;
    ischecked = [item boolValue];
    ischecked = !ischecked;
    
    // save change sate of connections
    [self.listCheckStateOfAllConnections removeObjectAtIndex:button.tag - 100];
    item = [NSNumber numberWithBool:ischecked];
    [self.listCheckStateOfAllConnections insertObject:item atIndex:button.tag - 100];
    
    if (ischecked == YES) {
        [button setImage:_imageOn forState:UIControlStateNormal];
    }
    else{ // ischecked = NO
        [button setImage:_imgageOff forState:UIControlStateNormal];
    }

#ifdef DEBUG
    NSLog(@"switch %d is %@",button.tag - 100,([self.listCheckStateOfAllConnections[button.tag - 100] boolValue] == YES)?@"YES":@"NO");
#endif
    
}

- (IBAction)buttonCheckTapper:(UIButton *)button
{
    NSNumber *item = self.listCheckStateOfAllPublishing[button.tag - 1];
    BOOL ischecked;
    ischecked = [item boolValue];
    ischecked = !ischecked;
    
#ifdef DEBUG
    NSLog(@"listCount buttonCheck %d", self.listCheckStateOfAllPublishing.count);
    NSLog(@"button %d checked = %@",button.tag,(ischecked == YES)?@"YES":@"NO");
#endif    
    //change state check for button in array for save after
   // [self.arraylistCheckStateOfFavoriteSpot removeObject:statechecked];
    [self.listCheckStateOfAllPublishing removeObjectAtIndex:button.tag - 1];
    item = [NSNumber numberWithBool:ischecked];
    [self.listCheckStateOfAllPublishing insertObject:item atIndex:button.tag - 1];
    
    if (ischecked == YES) {
        [button setImage:[CommonHelpers getImageFromName:@"ic_check_on"] forState:UIControlStateNormal];
    }
    else{ // ischecked = NO
        [button setImage:[CommonHelpers getImageFromName:@"ic_check"] forState:UIControlStateNormal];
    }
}

- (void)savelistCheckStateOfAllConnections
{
  // save array self.listCheckStateOfAllConnections nay
}

- (void)savelistCheckStateOfAll
{
  // save array self.listCheckStateOfAllPublishing nay
}


#pragma mark- IBAction's Define

- (IBAction)actionBack:(id)sender
{
    
    NSMutableDictionary *nameElements = [NSMutableDictionary dictionary];
    
    [nameElements setObject:[UserDefault userDefault].userID forKey:@"userId"];
    
    NSMutableArray* dictionnary = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.listCheckStateOfAllConnections count]; i++) {
        NSMutableDictionary* dicConnection = [NSMutableDictionary dictionary];
        [dicConnection setObject:[NSString stringWithFormat:@"%d",(i + 1)] forKey:@"usncORDER"];
        [dicConnection setObject:[CommonHelpers getStringValue:[self.listCheckStateOfAllConnections objectAtIndex:i]] forKey:@"usncYN"];
        
        NSMutableArray* arrayConnection = [[NSMutableArray alloc]init];
        for (int j = 0; j < [self.listCheckStateOfAllPublishing count]/4; j++) {
            
            NSMutableDictionary* dicPublishing = [NSMutableDictionary dictionary];
            [dicPublishing setObject:[NSString stringWithFormat:@"%d",(j + 1)] forKey:@"usncORDER"];
            if (i != 3) {
                [dicPublishing setObject:[CommonHelpers getStringValue:[self.listCheckStateOfAllPublishing objectAtIndex:j*3 + i]] forKey:@"usncYN"];
            }
            [arrayConnection addObject:dicPublishing];
        }
        
        [dicConnection setObject:arrayConnection forKey:@"auto_publishing"];
        
        [dictionnary addObject:dicConnection];
    }
    
    [nameElements setObject:dictionnary forKey:@"socialSettings"];
    
    NSString* jsonString = [nameElements JSONString];
    
    NSLog(@"JSON STRING: %@", jsonString);
    
    CRequest* request = [[CRequest alloc]initWithURL:@"submitSettingsSocial" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationJson WithView:self.view];
    request.delegate = self;
    [request setHeader:HeaderTypeJSON];
    [request setJSON:jsonString];
    [request startRequest];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNewsfeed:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    
    NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response: %@", response);
    
    if (response != NULL) {

        NSDictionary* dic = [response objectFromJSONString];
        NSArray* array = [dic objectForKey:@"socialSettings"];
        for (NSDictionary* dic2 in array) {
            int index = [[dic2 objectForKey:@"usncORDER"] intValue] - 1;
            [self.listCheckStateOfAllConnections replaceObjectAtIndex:index withObject:[CommonHelpers getBoolValue:[dic2 objectForKey:@"usncYN"]]];
            NSArray* array2 = [dic2 objectForKey:@"auto_publishing"];
            for (NSDictionary* dic3 in array2) {
                if (dic3 != NULL) {
                    int index2 = [[dic3 objectForKey:@"usncORDER"] intValue] - 1;
                    if (index != 3) {
                         [self.listCheckStateOfAllPublishing replaceObjectAtIndex:(index2*3 + index) withObject:[CommonHelpers getBoolValue:[dic3 objectForKey:@"usncYN"]]];
                    }
                }
                
            }
        }
    }
    [self setStateForSwitchs:self.listCheckStateOfAllConnections];
    [self setStateForbuttonsCheck:self.listCheckStateOfAllPublishing];
}

@end
