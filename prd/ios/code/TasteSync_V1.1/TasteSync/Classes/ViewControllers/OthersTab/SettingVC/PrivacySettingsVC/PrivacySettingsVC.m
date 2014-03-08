//
//  PrivacySettingsVC.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "PrivacySettingsVC.h"
#import "CommonHelpers.h"

@interface PrivacySettingsVC ()
{
    
}
- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;
@end

@implementation PrivacySettingsVC

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
    
        self.listCheckStatePrivacySettings = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CRequest* request = [[CRequest alloc]initWithURL:@"showSettingsPrivacy" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm WithView:self.view];
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
    [scrollViewMain setContentSize:CGSizeMake(320, 400)];
}

#pragma mark- IBAction's Define

- (IBAction)actionBack:(id)sender
{
    NSMutableDictionary *nameElements = [NSMutableDictionary dictionary];
    
    [nameElements setObject:[UserDefault userDefault].userID forKey:@"userId"];
    
    //NSMutableArray* array= [[CommonHelpers appDelegate] arrDataFBFriends];
    NSMutableArray* dictionnary = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.listCheckStatePrivacySettings count]; i++){
        
        NSMutableDictionary* mdictionary = [NSMutableDictionary dictionary];
        [mdictionary setObject:[NSString stringWithFormat:@"%d", (i + 1)] forKey:@"privacy_id_order"];
        [mdictionary setObject:[CommonHelpers getStringValue:[self.listCheckStatePrivacySettings objectAtIndex:i]] forKey:@"privacy_flag"];
        [dictionnary addObject:mdictionary];
    }
    
    [nameElements setObject:dictionnary forKey:@"privacy"];
    
    NSString* jsonString = [nameElements JSONString];
    
    NSLog(@"JSON STRING: %@", jsonString);
    
    CRequest* request = [[CRequest alloc]initWithURL:@"submitSettingsPrivacy" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationJson WithView:self.view];
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

- (void)setStateForbuttonsCheck:(NSMutableArray *)arrayState
{
    UIButton *button = nil;
    NSLog(@"count array: %d",arrayState.count);
    for (int i = 0; i < arrayState.count; i++) {
        NSNumber *statechecked = arrayState[i];
        
        button = (UIButton *) [self.view viewWithTag:i + 1];
        if ([statechecked boolValue] == YES) {
            NSLog(@" checked %d = YES", i+1);
            [button setImage:[CommonHelpers getImageFromName:@"ic_check_on.png"] forState:UIControlStateNormal];
        }
        else{ // ischecked = NO
            NSLog(@" checked %d = NO", i+1);
            [button setImage:[CommonHelpers getImageFromName:@"ic_check.png"] forState:UIControlStateNormal];
        }
        
    }
    
}

- (IBAction)buttonCheckTapper:(UIButton *)button;
{
    NSNumber *item = self.listCheckStatePrivacySettings[button.tag - 1];
    BOOL ischecked;
    ischecked = [item boolValue];
    ischecked = !ischecked;
    
    NSLog(@"listCount buttonCheck %d", self.listCheckStatePrivacySettings.count);
    NSLog(@"button %d checked = %@",button.tag,(ischecked == YES)?@"YES":@"NO");
    
    //change state check for button in array for save after
    // [self.arraylistCheckStateOfFavoriteSpot removeObject:statechecked];
    [self.listCheckStatePrivacySettings removeObjectAtIndex:button.tag - 1];
    item = [NSNumber numberWithBool:ischecked];
    [self.listCheckStatePrivacySettings insertObject:item atIndex:button.tag - 1];
    
    if (ischecked == YES) {
        [button setImage:[CommonHelpers getImageFromName:@"ic_check_on.png"] forState:UIControlStateNormal];
    }
    else{ // ischecked = NO
        [button setImage:[CommonHelpers getImageFromName:@"ic_check.png"] forState:UIControlStateNormal];
    }

}
- (void)savelistCheckStateOfAll
{
   //save array self.listCheckStatePrivacySettings nay
}
 
-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response: %@", response);
    
    if (response != NULL) {
        
        NSDictionary* dic = [response objectFromJSONString];
        NSArray* array = [dic objectForKey:@"privacy"];
        for (NSDictionary* dic2 in array) {
            int index = [[dic2 objectForKey:@"privacy_id_order"] intValue] - 1;
            [self.listCheckStatePrivacySettings replaceObjectAtIndex:index withObject:[CommonHelpers getBoolValue:[dic2 objectForKey:@"privacy_flag"]]];
        }
    }
    
    [self setStateForbuttonsCheck:self.listCheckStatePrivacySettings];
}


@end
