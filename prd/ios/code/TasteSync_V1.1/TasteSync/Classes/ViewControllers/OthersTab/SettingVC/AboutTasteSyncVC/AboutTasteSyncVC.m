//
//  AboutTasteSyncVC.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "AboutTasteSyncVC.h"
#import "CommonHelpers.h"
#import "ContentAboutUsVC.h"
@interface AboutTasteSyncVC ()
{
}
- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;

@end

@implementation AboutTasteSyncVC

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
    tasteSyncVersion.text = [NSString stringWithFormat:@"TasteSync version %@", [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
    [CommonHelpers setBackgroudImageForView:self.view];
    // Do any additional setup after loading the view from its nib.

    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData
{
    self.arrAboutContent = [[NSMutableArray alloc] initWithObjects:/*@"Frequently Asked Questions",*/@"Terms of Service",@"Privacy Policy"/*,@"Attribution"*/, nil];
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

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrAboutContent == nil) {

    }
    return self.arrAboutContent.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellCustomAbout";
    CellCustomAbout *cell = [tbvContent dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
       cell = (CellCustomAbout *) [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] objectAtIndex:0];
       
    }
    
    cell.lbTitle.text = [_arrAboutContent objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
//        case 0:
//        {
//            ContentAboutUsVC* about = [[ContentAboutUsVC alloc] initWithId:1];
//            [self.navigationController pushViewController:about animated:YES];
//        }
//            break;
        case 0:
        {
            ContentAboutUsVC* about = [[ContentAboutUsVC alloc] initWithId:2];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
        case 1:
        {
            ContentAboutUsVC* about = [[ContentAboutUsVC alloc] initWithId:3];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
//        case 1:
//        {
//            ContentAboutUsVC* about = [[ContentAboutUsVC alloc] initWithId:4];
//            [self.navigationController pushViewController:about animated:YES];
//        }
//            break;
            
        default:
            break;
    }
}


@end
