//
//  CommentCell.m
//  TasteSync
//
//  Created by Victor on 12/24/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "CommentCell.h"
#import "CommonHelpers.h"

@interface CommentCell ()<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UITextView *tvComment;
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UIImageView *ivtext_bg;
    __weak IBOutlet UIButton *btSend;
    __weak IBOutlet UILabel *lbholdtext;
    __weak IBOutlet UIView *viewTap;
}

- (IBAction)actionSend:(id)sender;

@end

@implementation CommentCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

# pragma mark - IBAction Define

- (IBAction)actionSend:(id)sender
{
    debug(@"actionSend");
    if (tvComment.text.length) {
        [self.delegate commentCellDidSendMessage:tvComment.text];

    }

    [tvComment resignFirstResponder];
    tvComment.text = nil;    
    lbholdtext.hidden = NO;
    
}

#pragma mark - Others

- (void) initForView
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [viewTap addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer *gestureSend = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSend:)];
    [btSend addGestureRecognizer:gestureSend];
    
    
   
}

- (void) startComment
{
    debug(@"startComment");
    [self.delegate commenCellDidStartComment];

    [tvComment becomeFirstResponder];
}

- (void) hideKeyBoard
{
    [tvComment resignFirstResponder];
}
# pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        return NO;
    }
    
    [self startComment];
    lbholdtext.hidden = YES;
    return YES;
}




@end
