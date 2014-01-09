//
//  EditRateReViewDialog.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/25/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditRateReViewDialog;
@protocol EditRateReViewDialogDelegate <NSObject>
@optional
- (void)EditRateReViewDialogDidShow:(EditRateReViewDialog *)dialog;
- (void)EditRateReViewDialogDidCancel:(EditRateReViewDialog *)dialog;
- (void)EditRateReViewDialogItemTableSearchIsClick:(EditRateReViewDialog *)dialog restaurantName:(NSString *)nameRestaurant;

@end

@interface EditRateReViewDialog : UIView <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,assign) id <EditRateReViewDialogDelegate> delegate;

@property (nonatomic, strong) UITableView *tableResultSearch;
@property (nonatomic, strong) NSMutableArray *arryContent;
@property (nonatomic, strong) UITextField  *textfield;
- (void)show;
- (void)showFromFarent:(id)parent;
- (void)cancel;
- (void)setHiddenDialog:(BOOL)hidden;
@end
