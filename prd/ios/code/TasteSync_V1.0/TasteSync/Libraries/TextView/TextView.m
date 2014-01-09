//
//  TextView.m
//  TestTextfield
//
//  Created by HP on 9/16/13.
//  Copyright (c) 2013 Mobioneer HV 02. All rights reserved.
//

#import "TextView.h"

#define OPENTAG @"<u>"
#define CLOSETAG @"</u>"

@interface TextView ()
{
    UITextView* _textView;
    //NSMutableArray* _array;
    NSMutableArray* _arrayItem;
    NSString* htmlStr;
}
@end
@implementation TextView

@synthesize textView = _textView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textView = [[UITextView alloc]initWithFrame:frame];
        [self addSubview:_textView];
        _textView.delegate = self;
        self.specialCharacter = @"#";
        _arrayItem = [[NSMutableArray alloc]init];
        htmlStr = @"";
        [_textView setValue: htmlStr forKey:@"contentToHTMLString"];
        _textView.text = @"Tip: Use # before restaurant name";
    }
    return self;
}
#pragma mark TextView Delegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _textView.text = @"";
    _textView.textColor = [UIColor blackColor];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate beginEditting];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self.delegate enterCharacter:text];
    //NSLog(@"%d, %d, %@",range.location, range.length, text);
    if ([text isEqualToString:@""]){
        for (HighlightText* high in _arrayItem) {
            if (high.endLocation - 1  == range.location) {
                _textView.text = [NSString stringWithFormat:@"%@%@", [_textView.text substringToIndex:high.beginLocation], [_textView.text substringFromIndex:high.endLocation]];
                int a = high.beginLocation;
                int lenght = high.text.length;
                [self.delegate removeObject:high];
                [_arrayItem removeObject:high];
                for (HighlightText* obj in _arrayItem) {
                    if (a < obj.beginLocation) {
                        obj.beginLocation -= lenght;
                        obj.endLocation -= lenght;
                    }
                }
                [self setHTML:a];
                return NO;
            }
        }
        [self removeString:range.location Lenght:range.length];
        return NO;
    }
    if (range.length == 0) {
        [self addNewString:text location:range.location];
    }
    
    return NO;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
   
    //NSLog(@"- %d, %d", _textView.selectedRange.location, _textView.selectedRange.length);
    NSString* str = _textView.text;
    NSArray* array = [str componentsSeparatedByString:self.specialCharacter];
    int count = 0;
    for (int i = 0; i < _textView.selectedRange.location && _textView.selectedRange.location < 6000; i++) {
        unichar c = [str characterAtIndex:i];
        if (c == [self.specialCharacter characterAtIndex:0]) {
            count++;
        }
    }
    if (count != 0) {
        [self.delegate enterSearchObject:[array objectAtIndex:count]];
    }
    
    if ([self checkLocation:_textView.selectedRange.location]) {
        [_textView setSelectedRange:NSMakeRange([self getLocation:_textView.selectedRange.location],0)];
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"here");
    textView.contentOffset = CGPointMake(textView.contentOffset.x, textView.contentSize.height - 48);
}
-(void)addRestaurant:(RestaurantObj*)obj
{
    HighlightText* hight = [[HighlightText alloc]init];
    hight.beginLocation = _textView.selectedRange.location;
    hight.text = obj.name;
    hight.userObj = obj;
    hight.endLocation = _textView.selectedRange.location +obj.name.length;
    //NSLog(@"end Location: %d",hight.endLocation);
    hight.isInsert = NO;
    int i = 0;
    for (i = 0; i < _arrayItem.count; i++) {
        HighlightText* obj = [_arrayItem objectAtIndex:i];
        if (obj.beginLocation < hight.beginLocation) {
            [self.delegate addNewObject:hight];
            [_arrayItem insertObject:hight atIndex:i];
            break;
        }
    }
    if (i == _arrayItem.count) {
        [self.delegate addNewObject:hight];
        [_arrayItem addObject:hight];
    }
    
    NSArray* array = [_textView.text componentsSeparatedByString:self.specialCharacter];
    int count = 0;
    int location;
    for (int i = 0; i < _textView.selectedRange.location && _textView.selectedRange.location < 6000; i++) {
        unichar c = [_textView.text characterAtIndex:i];
        if (c == [self.specialCharacter characterAtIndex:0]) {
            location = i;
            count++;
        }
    }
    NSString* string = [array objectAtIndex:count];
    NSLog(@"location: %d - length: %d", location, string.length);
    [self removeString:location Lenght:string.length + 1];
    
    int index = hight.endLocation;
    [self setHTML:index];
    for (HighlightText* obj in _arrayItem) {
        if (obj.beginLocation >= hight.beginLocation && obj != hight ) {
            obj.beginLocation += hight.text.length;
            obj.endLocation += hight.text.length;
        }
    }
    [_textView setSelectedRange:NSMakeRange(index,0)];
    //[htmlStr insertString:[self getHTMLString:s] atIndex:_textView.selectedRange.location];
    //NSLog(@"%@", _textView.text);
}

-(int)getLocation:(int)location
{
    for (HighlightText* highlightText in _arrayItem) {
        if (location > highlightText.beginLocation && location < highlightText.endLocation) {
            return highlightText.endLocation;
        }
    }
    return location;
}

-(BOOL)checkLocation:(int)location
{
    for (HighlightText* highlightText in _arrayItem) {
        if (location > highlightText.beginLocation && location < highlightText.endLocation) {
            return YES;
        }
    }
    return NO;
}

-(NSString*)getHTMLString:(NSString*)str
{
    return [NSString stringWithFormat:@"%@%@%@", OPENTAG,str,CLOSETAG];
}
-(void)setHTML:(int)index
{
    //NSLog(@"Array: %d", _arrayItem.count);
    htmlStr = _textView.text;
    for (int i = 0; i < [_arrayItem count]; i++) {
        HighlightText* obj = [_arrayItem objectAtIndex:i];
        if (obj.isInsert == NO) {
            NSString* str1 = [htmlStr substringToIndex:obj.beginLocation];
            NSString* str2 = [htmlStr substringFromIndex:obj.beginLocation];
//            htmlStr = [NSString stringWithFormat:@"%@%@%@",str1, [self getHTMLString:obj.text],str2];
            htmlStr = [NSString stringWithFormat:@"%@%@%@",str1, obj.text,str2];
            obj.isInsert = YES;
        }
//        else
//        {
//            NSString* str11 = [htmlStr substringToIndex:obj.endLocation];
//            NSString* str21 = [htmlStr substringFromIndex:obj.endLocation];
//            htmlStr = [NSString stringWithFormat:@"%@%@%@",str11, CLOSETAG,str21];
//            
//            NSString* str1 = [htmlStr substringToIndex:obj.beginLocation];
//            NSString* str2 = [htmlStr substringFromIndex:obj.beginLocation];
//            htmlStr = [NSString stringWithFormat:@"%@%@%@",str1, OPENTAG,str2];
//        }
    }
//    if ([htmlStr characterAtIndex:(htmlStr.length - 1)] == ' ') {
//        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
//        //htmlStr = [htmlStr stringByReplacingCharactersInRange:NSMakeRange(htmlStr.length - 1, 1) withString:@"&nbsp;"];
//    }
    
    //htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"\n" withString:@"<br></br>"];
//    [_textView setValue: htmlStr forKey:@"contentToHTMLString"];
    _textView.text = htmlStr;
    //_textView.contentOffset = CGPointMake(_textView.contentOffset.x, _textView.contentSize.height - 48);
    NSLog(@"htmlStr: %@, %@, %d",htmlStr, _textView.text, index);
    [_textView setSelectedRange:NSMakeRange(index,0)];
    [_textView becomeFirstResponder];
}

-(void)addNewString:(NSString*)str location:(int)location
{
    NSString* str1 = [_textView.text substringToIndex:location];
    //NSLog(@"str1 %@", str1);
    NSString* str2 = [_textView.text substringFromIndex:location];
    //NSLog(@"str2 %@", str2);
    _textView.text = [NSString stringWithFormat:@"%@%@%@",str1, str,str2];
    
    for (HighlightText* obj in _arrayItem) {
        if (obj.beginLocation >= location) {
            obj.beginLocation += str.length;
            obj.endLocation += str.length;
        }
    }
    [self setHTML:(location + str.length)];
}
-(void)removeString:(int)location Lenght:(int)lenght
{
    NSString* str1 = [_textView.text substringToIndex:location];
    NSString* str2 = [_textView.text substringFromIndex:location + lenght];
    _textView.text = [NSString stringWithFormat:@"%@%@",str1,str2];
    
    for (HighlightText* obj in _arrayItem) {
        if (( location < obj.endLocation && location > obj.beginLocation ) || ((location + lenght) < obj.endLocation && (location + lenght) > obj.beginLocation) || ( (location + lenght) >= obj.endLocation && location <= obj.beginLocation ) ) {
            [self.delegate removeObject:obj];
            [_arrayItem removeObject:obj];
            break;
        }
        if (location < obj.beginLocation) {
            obj.beginLocation -= lenght;
            obj.endLocation    -= lenght;
        }
    }
    [self setHTML:location];
}

-(void)addSpecialCharacter:(NSString *)character
{
    self.specialCharacter = character;
}

@end
