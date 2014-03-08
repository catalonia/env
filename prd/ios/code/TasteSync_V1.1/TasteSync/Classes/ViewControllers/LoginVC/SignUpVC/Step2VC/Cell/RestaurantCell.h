//
//  RestaurantCell.h
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RestaurantCellDelegate <NSObject>

- (void) didActionWithTag:(int)Tag atIndex:(int ) index ;

@end

typedef enum _RestaurantCellAction
{
    RestaurantCellActionTagChooseNative     =   1,
    RestaurantCellActionTagChooseOther     =   2,
    RestaurantCellActionTagAddNative     =   3,
    RestaurantCellActionTagAddOther     =   4,
    RestaurantCellActionTagRemoveNative     =   5,
    RestaurantCellActionTagRemoveOther     =  6,



}   RestaurantCellAction;

@interface RestaurantCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lbRestaurant;

@property (nonatomic, strong) IBOutlet UIButton *btAdd,*btRemove;

@property (nonatomic, assign) BOOL isNative;

@property (nonatomic, strong) id<RestaurantCellDelegate> delegate;


@end
