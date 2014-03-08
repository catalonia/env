//
//  ContentAboutUsVC.m
//  TasteSync
//
//  Created by HP on 7/27/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ContentAboutUsVC.h"
#import "CommonHelpers.h"
#import "JSONKit.h"

@interface ContentAboutUsVC ()
{
    __weak IBOutlet UIWebView* _webView;
    int _index;
}
@end

@implementation ContentAboutUsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithId:(int)index
{
    self = [super initWithNibName:@"ContentAboutUsVC" bundle:nil];
    if (self) {
        _index = index;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    CRequest* request = [[CRequest alloc]initWithURL:@"showAboutTastesync" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm];
//    [request setFormPostValue:[NSString stringWithFormat:@"%d",_index] forKey:@"AboutId"];
//    request.delegate = self;
//    [request startFormRequest];
    
    if (_index == 2) {
        NSString* url = @"http://v02.tastesync.com/terms.html";
        NSURL* nsUrl = [NSURL URLWithString:url];
        NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
        [_webView loadRequest:request];
    }
    if (_index == 3) {
        NSString* url = @"http://v02.tastesync.com/privacy.html";
        NSURL* nsUrl = [NSURL URLWithString:url];
        NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
        [_webView loadRequest:request];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNewsfeed:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}
-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (response != NULL) {
        NSDictionary* dic = [response objectFromJSONString];
        NSString* successStr = [dic objectForKey:@"content"];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scalesPageToFit = YES;
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [_webView loadHTMLString:successStr baseURL:[NSURL URLWithString:@""]];
    }
}
@end
