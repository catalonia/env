//
//  blogger.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 1/17/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "blogger.h"
#import "CommonHelpers.h"
@interface blogger ()
{
    
}
- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;
@end

@implementation blogger

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
    // Do any additional setup after loading the view from its nib.
    [CommonHelpers setBackgroudImageForView:self.view];

    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   

}

# pragma mark - IBAction's Define

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNewsfeed:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}


- (void)shareProfile
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", @"Tumblr",@"Email", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    //  [actionSheet showInView:self.view];
}

@end
