//
//  RecommendationCell.m
//  TasteSync
//
//  Created by Phu Phan on 10/25/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "RecommendationCell.h"
@interface RecommendationCell()
{
    __weak IBOutlet UILabel* name;
    __weak IBOutlet UILabel* content;
    __weak IBOutlet UIImageView* avatar;
    ReplyRecomendationObj* _replyRecomendationObj;
}
@end
@implementation RecommendationCell

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

    
}
-(void)setUI:(ReplyRecomendationObj*)obj
{
    _replyRecomendationObj = obj;
    name.text = _replyRecomendationObj.userObj.name;
    content.text = _replyRecomendationObj.replyText;
    if (_replyRecomendationObj.userObj.avatar != nil) {
        avatar.image = _replyRecomendationObj.userObj.avatar;
    }
    else
    {
        [NSThread detachNewThreadSelector:@selector(loadAvatar) toTarget:self withObject:nil];
    }
}
-(void)loadAvatar
{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_replyRecomendationObj.userObj.avatarUrl]]];
    avatar.image = image;
    _replyRecomendationObj.userObj.avatar = image;
}
@end
