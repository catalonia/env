//
//  RateThisApp.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/28/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "RateThisApp.h"
#import "CommonHelpers.h"

@interface RateThisApp ()
{
    __weak IBOutlet UIWebView* _webview;
}
- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;
@end

@implementation RateThisApp

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
    
    NSString* url = @"http://www.apple.com";
    
    NSURL* nsUrl = [NSURL URLWithString:url];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [_webview loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- IBAction's Define

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNewsfeed:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}
@end
