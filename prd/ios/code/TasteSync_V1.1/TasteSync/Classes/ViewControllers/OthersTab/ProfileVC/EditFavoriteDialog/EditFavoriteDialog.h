//
//  EditFavoriteDialog.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/25/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditFavoriteDialog;
@protocol EditFavoriteDialogDelegate <NSObject>
@optional
- (void)EditFavoriteDialogDidShow:(EditFavoriteDialog *)dialog;
- (void)EditFavoriteDialogDidCancel:(EditFavoriteDialog *)dialog;
- (void)EditFavoriteDialogItemTableSearchIsclick:(NSString *)nameRestaurant;
@end

@interface EditFavoriteDialog : UIView <UIActionSheetDelegate,UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,assign) id <EditFavoriteDialogDelegate> delegate;
@property (nonatomic, strong) UITableView *tableResultSearch;
@property (nonatomic, strong) NSMutableArray *arryContent;

- (void)show;
- (void)cancel;
- (void)showTableForSearchString: (NSString *)string;
- (void)hiddenTableSearch;
- (void) moveDialogUpWithLevel:(NSInteger)level;
@end
