//
//  TagView.m
//  TagViewCustom
//
//  Created by Victor NGO on 3/14/13.
//  Copyright (c) 2013 Mobioneer Co.Ltd. All rights reserved.
//

#import "TagView.h"
#import "TagObj.h"

@interface TagView ()
{
    TagDefault *tagDefault;
    TagObj *tagObjAdd;
    UIGestureRecognizer *gesRecognizer ;
}

@end

@implementation TagView

@synthesize width=width,
heigh = heigh,
delegate=_delegate,
owidth=owidth, oheigh = oheigh;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"TagView" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}
- (id) initWithArray:(NSMutableArray *) anArray option :(int) anOption delegate:(id<TagObjDelegate>) aDelegate;
{
    self = [self initWithFrame:CGRectZero];
    self.delegate = aDelegate;
    width =0, heigh = 0;    
    gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTouchOnView:)];
    
    switch (anOption) {
        case TagViewEnumData:
        {
            for (TSGlobalObj *global in anArray) {
                
                TagObj *tagObj = [[TagObj alloc] initWithString:global option:TagObjEnumDefault delegate:aDelegate];
                CGRect tagObjFrame = tagObj.frame;
                        
                if ((width + tagObjFrame.size.width) >280) {
                    heigh += tagObjFrame.size.height;
                    width =0;
                    tagObjFrame.origin.y += heigh;
//                    NSLog(@">280 width - heigh -> %f - %f",width, heigh);
                    width += tagObjFrame.size.width;


                }else {
                    width += tagObjFrame.size.width;
                    tagObjFrame.origin.x = width - tagObjFrame.size.width;
                    tagObjFrame.origin.y = heigh;
//                    NSLog(@"< 280 width - heigh -> %f - %f",width, heigh);

                }
                
                
                [tagObj setFrame:tagObjFrame];                
                [tagObj setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin];
                [tagObj addGestureRecognizer:gesRecognizer];
            
            [self addSubview:tagObj];
                
            
            }
            
            [self setFrame:CGRectMake(0, 0, 280, heigh+ TagObjFrameDefault.size.height)];
   
            owidth = width, oheigh = heigh;

            
        }
            break;
        case TagViewEnumDefault:
        {
            NSLog(@"TagView - addDefault");

            [self addTagDefault];

        }
            break;
            
        default:
            break;
    }
    
    
    return self;
}

- (IBAction)actionTouchOnView:(id)sender
{
    
    if (tagObjAdd != nil) {
        NSLog(@"TagView-> actionTouchOnView return");

        return;
    }
        
    if (tagDefault !=nil) {

        if (width >= tagDefault.frame.size.width) {
            width -= tagDefault.frame.size.width;
        }
        else {
            width -= tagDefault.frame.size.width;
            heigh -= TagDefaultSize.height;
        }
       
        [tagDefault removeFromSuperview];   
        tagDefault = nil;
        tagDefault.hidden =YES;
        
        width = owidth, heigh = oheigh;


    }
    
    owidth = width, oheigh = heigh;

    
    TSGlobalObj* gloabal = [[TSGlobalObj alloc]init];
    gloabal.name = @"";
    tagObjAdd = [[TagObj alloc] initWithString:gloabal option:TagObjEnumAdd delegate:self.delegate];
   
    
    CGRect tagObjFrame = tagObjAdd.frame;
    if (width + tagObjFrame.size.width >280) {
        width = 0;
        heigh += tagObjFrame.size.height;
        tagObjFrame.origin.y = heigh;
        width = tagObjFrame.size.width;

        
    }
    else {        
        tagObjFrame.origin.x = width;
        tagObjFrame.origin.y = heigh;
        width += tagObjFrame.size.width;

    }
    
    [tagObjAdd setFrame:tagObjFrame];
    
    [tagObjAdd setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin];
    
    [self addSubview:tagObjAdd];  
    
    [tagObjAdd becomeFirstResponder];    
    
    [self setFrame:CGRectMake(0, 0, 280, heigh + TagObjFrameDefault.size.height)];
    
    NSLog(@"TagView-> actionTouchOnView frame change (width,heigh) ->(%d,%f)",280,heigh + TagObjFrameDefault.size.height);

    [self.tagViewDelegate tagView:self shouldBeginEditingTagObj:tagObjAdd];
}

- (void) addTagDefault
{
    
    NSLog(@"TagView - addDefault");
    
    if (tagDefault != nil) {
        return;
    }
    
    if (tagObjAdd !=nil) {
       
        if (width > TagObjFrameDefault.size.width) {
            width -= TagObjFrameDefault.size.width;
        }
        else {
            heigh -= (TagObjFrameDefault.size.height +9);
        }

        [tagObjAdd removeFromSuperview];
        tagObjAdd = nil;
        width = owidth, heigh = oheigh;

    }
    
    owidth = width, oheigh = heigh;

    
    tagDefault = [[TagDefault alloc] initWithFrame:CGRectZero];
    CGRect tagDefaultFrame = tagDefault.frame;
    if (width + TagDefaultSize.width >280) {
        width = 0;
        heigh += TagDefaultSize.height ;
        tagDefaultFrame.origin.y = heigh;
        width += TagDefaultSize.width;
        
    }
    else {
        tagDefaultFrame.origin.x = width;
        tagDefaultFrame.origin.y = heigh ;
        width += TagDefaultSize.width;

    }
    
    [tagDefault setFrame:tagDefaultFrame];
     [tagDefault setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin];
    
    [tagDefault addGestureRecognizer:gesRecognizer];
    [self addSubview:tagDefault];   
    
    [self setFrame:CGRectMake(0, 0, 280, heigh+ TagDefaultSize.height)];

    
    NSLog(@"AddTagDefault -> added change frame  width - heigh -> %f - %f", width, heigh);
}

- (void) addTagObj:(TSGlobalObj *) aTxt delegate:(id<TagObjDelegate>) aDelegate
{
    if (tagObjAdd !=nil) {
        
        if (width >= TagObjFrameDefault.size.width) {
            width -= TagObjFrameDefault.size.width;
        }
        else {
            width -= TagObjFrameDefault.size.width;
            heigh -= (TagObjFrameDefault.size.height);
        }
        
        [tagObjAdd removeFromSuperview];
        tagObjAdd = nil;
    }
    
    width = owidth, heigh = oheigh;
    

    
    TagObj *tagObj = [[TagObj alloc] initWithString:aTxt option:TagObjEnumDefault delegate:aDelegate];
    CGRect tagObjFrame = tagObj.frame;    
    NSLog(@"tagObjFrame before (%f,%f,%f,%f)", tagObjFrame.origin.x, tagObjFrame.origin.y, tagObjFrame.size.width, tagObjFrame.size.height);
    
    
      
    
    if ((width + tagObjFrame.size.width) >280) {
        heigh += tagObjFrame.size.height;
        width =0;
        tagObjFrame.origin.y += heigh;
        NSLog(@">280 width - heigh -> %f - %f",width, heigh);
        width += tagObjFrame.size.width;
        
        
    }else {
        width += tagObjFrame.size.width;
        tagObjFrame.origin.x = width - tagObjFrame.size.width;
        tagObjFrame.origin.y = heigh;
        NSLog(@"< 280 width - heigh -> %f - %f",width, heigh);
        
    }
    
    owidth = width, oheigh = heigh;

    
    NSLog(@"tagObjFrame after (%f,%f,%f,%f)", tagObjFrame.origin.x, tagObjFrame.origin.y, tagObjFrame.size.width, tagObjFrame.size.height);
    
    [tagObj setFrame:tagObjFrame];
    
    [tagObj setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin];
    [tagObj addGestureRecognizer:gesRecognizer];
    
    [self addSubview:tagObj];
    
    NSLog(@"TagView -> addTagObj change frame width - heigh -> %f - %f", width, heigh);


    [self actionTouchOnView:nil];
}

- (void) addTagObj:(TSGlobalObj *)aTxt delegate:(id<TagObjDelegate>)aDelegate andTagDefault:(BOOL) aBoolValue
{
    if (aBoolValue) {
        NSLog(@"TagView - addTagObj and tagDefault ");
    }
    else
    {
                      
        if (tagDefault !=nil) {
            NSLog(@"TagView-> addTagObj andTagDefault - width = %f",width);
            
            if (width >= tagDefault.frame.size.width) {
                width -= tagDefault.frame.size.width;
            }
            else {
                width -= tagDefault.frame.size.width;
                heigh -= TagDefaultSize.height;
            }
            
            [tagDefault removeFromSuperview];
            tagDefault = nil;
            
            width = owidth, heigh = oheigh;
            
            
        }
        
        owidth = width, oheigh = heigh;

        
        if (tagObjAdd !=nil) {
            
            if (width >= TagObjFrameDefault.size.width) {
                width -= TagObjFrameDefault.size.width;
            }
            else {
                width -= TagObjFrameDefault.size.width;
                heigh -= (TagObjFrameDefault.size.height);
            }
            
            [tagObjAdd removeFromSuperview];
            tagObjAdd = nil;
        }
        
       
        TagObj *tagObj = [[TagObj alloc] initWithString:aTxt option:TagObjEnumDefault delegate:aDelegate];
        CGRect tagObjFrame = tagObj.frame;
                
        if ((width + tagObjFrame.size.width) >280) {
            heigh += tagObjFrame.size.height;
            width =0;
            tagObjFrame.origin.y += heigh;
            width += tagObjFrame.size.width;
            
            
        }else {
            width += tagObjFrame.size.width;
            tagObjFrame.origin.x = width - tagObjFrame.size.width;
            tagObjFrame.origin.y = heigh;
            
        }
        
        owidth = width, oheigh = heigh;
                        
        [tagObj setFrame:tagObjFrame];
        
        [tagObj setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin];
        [tagObj addGestureRecognizer:gesRecognizer];
        
        [self addSubview:tagObj];
        [self setFrame:CGRectMake(0, 0, 280, heigh+TagObjFrameDefault.size.height)];
        
        [self.tagViewDelegate tagView:self shouldBeginEditingTagObj:tagObjAdd];

    }
}


@end
