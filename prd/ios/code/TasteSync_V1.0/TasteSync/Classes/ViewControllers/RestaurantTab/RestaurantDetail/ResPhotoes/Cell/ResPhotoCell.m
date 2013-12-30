//
//  ResPhotoCell.m
//  TasteSync
//
//  Created by Victor on 1/10/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResPhotoCell.h"
#import "CommonHelpers.h"

@interface ResPhotoCell ()
{
    __weak IBOutlet UIImageView *iv1,*iv2,*iv3;
    __weak IBOutlet UIActivityIndicatorView *activity1,*activity2,*activity3;
    __weak IBOutlet UIButton *bt1,*bt2,*bt3;
    int _index1, _index2, _index3;
    
    TSPhotoRestaurantObj* photoRestaurant1,*photoRestaurant2,*photoRestaurant3;
    int _location;
}

- (IBAction)actionSelect:(id)sender;

@end

@implementation ResPhotoCell

- (void) initForCell:(TSPhotoRestaurantObj *) image1 Index1:(int)index1 image2:(TSPhotoRestaurantObj *)image2 Index2:(int)index2 image3:(TSPhotoRestaurantObj *) image3 Index3:(int)index3
{
    
    _index1 = index1;
    _index2 = index2;
    _index3 = index3;
    
    if (image1.image != nil) {
        iv1.image = image1.image;
        bt1.enabled = YES;
        [activity1 stopAnimating];
        [activity1 removeFromSuperview];
    }
    else
    {
        bt1.enabled = NO;
        [activity1 startAnimating];
        photoRestaurant1 = image1;
        _location = 1;
        [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:_location]];
    }
    if (image2.image != nil) {
        iv2.image = image2.image;
        bt2.enabled = YES;
        [activity2 stopAnimating];
        [activity2 removeFromSuperview];
    }
    else
    {
        bt2.enabled = NO;
        [activity2 startAnimating];
        photoRestaurant2 = image2;
        _location = 2;
        [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:_location]];
    }
    
    if (image3.image != nil) {
        iv3.image = image3.image;
        bt3.enabled = YES;
        [activity3 stopAnimating];
        [activity3 removeFromSuperview];
    }
    else
    {
        bt3.enabled = NO;
        [activity3 startAnimating];
        photoRestaurant3 = image3;
        _location = 3;
        [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:_location]];
    }
}

- (IBAction)actionSelect:(id)sender
{
    UIButton *bt = (UIButton *) sender;
    switch (bt.tag) {
        case 1:
        {
            [self.delegate resPhotoCell:self tag:_index1];
        }
            break;
        case 2:
        {
            [self.delegate resPhotoCell:self tag:_index2];

        }
            break;
        case 3:
        {
            [self.delegate resPhotoCell:self tag:_index3];

        }
            break;
            
        default:
            break;
    }
}
-(void)loadImage:(NSNumber*)_index
{
    @autoreleasepool {
        UIImage *image;
        if ([_index intValue]== 1) {
            image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoRestaurant1.photoURL]]];
            iv1.image = [CommonHelpers generateThumbnailFromImage:image withSize:CGSizeMake(160, 160)];
            photoRestaurant1.image = image;
            [activity1 stopAnimating];
            [activity1 removeFromSuperview];
            bt1.enabled = YES;
        }
        if ([_index intValue] == 2) {
            image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoRestaurant2.photoURL]]];
            iv2.image = [CommonHelpers generateThumbnailFromImage:image withSize:CGSizeMake(160, 160)];;
            photoRestaurant2.image = image;
            [activity2 stopAnimating];
            [activity2 removeFromSuperview];
            bt2.enabled = YES;
        }
        if ([_index intValue] == 3) {
            image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoRestaurant3.photoURL]]];
            iv3.image = image;
            photoRestaurant3.image = [CommonHelpers generateThumbnailFromImage:image withSize:CGSizeMake(160, 160)];;
            [activity3 stopAnimating];
            [activity3 removeFromSuperview];
            bt3.enabled = YES;
        }
        //[_tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
