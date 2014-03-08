//
//  ResReserveVC.m
//  TasteSync
//
//  Created by Victor on 1/10/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResReserveVC.h"
#import "CommonHelpers.h"

@interface ResReserveVC ()<UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *webView;
}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionShare:(id)sender;


@end

@implementation ResReserveVC

@synthesize restaurantObj=_restaurantObj;

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
    NSURL *url = [NSURL URLWithString:reserveURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    [_loadingView show];
    [webView loadRequest:request];
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

- (IBAction)actionShare:(id)sender
{
    [CommonHelpers showShareView:nil andObj:_restaurantObj];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    if ( request == UIWebViewNavigationTypeLinkClicked ) {
//        [[UIApplication sharedApplication] openURL:[request URL]];
//        return NO;
//    }
    return  YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [_loadingView show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [_loadingView hide];
//    _isLoading = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [_loadingView hide];
//    //    [Common showAlert:error.localizedDescription];
//    _isLoading = NO;
}


@end
