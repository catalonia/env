;//
//  AskVC.h
//  TasteSync
//
//  Created by Victor on 2/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRequest.h"
#import "JSONKit.h"

@interface AskVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, RequestDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UIImageView* _cuisineImage;
    __weak IBOutlet UIScrollView* _scrollView;
    __weak IBOutlet UIImageView* _cuisineSelectImage, *neighborhoodSelectImage, *_ambienceSelectImage, *_whoareyouSelectImage, *_priceSelectImage;
    

}

@property (nonatomic, strong) NSMutableArray *arrData, *arrDataRegion, *arrDataFilter;


@end
