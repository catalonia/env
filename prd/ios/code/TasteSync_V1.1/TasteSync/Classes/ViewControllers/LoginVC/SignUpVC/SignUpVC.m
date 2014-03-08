//
//  SignUpVC.m
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "SignUpVC.h"
#import "GlobalVariables.h"
#import "UserObj.h"
#import "UserDefault.h"
#import "CommonHelpers.h"
#import "ConfigProfileVC.h"

@interface SignUpVC ()<UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    __weak IBOutlet UIScrollView *scrollViewSignUp;
    __weak IBOutlet UITextField *tfemail,*tfpassword,*tfConfirmPassword,*tfFirstName,*tfLastName,*tfCity,*tfState;
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UISegmentedControl *segCtrGender;
    UserObj *userObj;
    UIImagePickerController  *imagePicker;
    
    UserDefault *userDefault;

    
}
//@property (nonatomic, strong) IBOutlet UIView *tapView;
- (IBAction)actionSignUp:(id)sender;

- (IBAction)actionSegment:(id)sender;

- (IBAction)actionTakeAPhoto:(id)sender;

- (IBAction)actionGallery:(id)sender;

- (IBAction)actionBack:(id)sender;

- (IBAction)actionHideKeypad:(id)sender;

@end

@implementation SignUpVC

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
    [CommonHelpers setBackgroudImageForView:self.view];
    userDefault = [UserDefault userDefault];
    // Do any additional setup after loading the view from its nib.
    
    [scrollViewSignUp setContentSize:CGSizeMake(320, 700)];
    
    [segCtrGender addTarget:self action:@selector(actionSegment:) forControlEvents:UIControlEventValueChanged];

    if (userDefault.emailID != nil) {
        tfemail.text = userDefault.emailID;
    }
    if (userDefault.password != nil) {
        tfpassword.text = userDefault.password;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
    
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Define
- (void) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)actionSignUp:(id)sender
{
    debug(@"actionSignUp");
    [self hideKeyBoard];
    userObj = [[UserObj alloc] init];
    userObj.avatar = ivAvatar.image;
    userObj.email = [CommonHelpers trim:tfemail.text];
    userObj.password = [CommonHelpers trim:tfpassword.text];
    userObj.lastname = [CommonHelpers trim:tfLastName.text];
    userObj.firstname = [CommonHelpers trim:tfFirstName.text];
    userObj.city = [CommonHelpers trim:tfCity.text];
    userObj.state = [CommonHelpers trim:tfState.text];
    userObj.gender = segCtrGender.selectedSegmentIndex;
    
    if (![CommonHelpers validateEmail:userObj.email]) {
        [CommonHelpers showInfoAlertWithTitle:APP_NAME message:@"Email is invalid." delegate:nil tag:0];
    }else if(userObj.password.length ==0 )
    {
        [CommonHelpers showInfoAlertWithTitle:APP_NAME message:@"Password is required." delegate:nil tag:1];
    }else if(userObj.firstname.length ==0 )
    {
        [CommonHelpers showInfoAlertWithTitle:APP_NAME message:@"Firstname is required." delegate:nil tag:1];
    }else if(userObj.lastname.length ==0 )
    {
        [CommonHelpers showInfoAlertWithTitle:APP_NAME message:@"Lastname is required." delegate:nil tag:1];
    }else if(userObj.city.length ==0 )
    {
        [CommonHelpers showInfoAlertWithTitle:APP_NAME message:@"City is required." delegate:nil tag:1];
    }else if(userObj.state.length ==0 )
    {
        [CommonHelpers showInfoAlertWithTitle:APP_NAME message:@"State is required." delegate:nil tag:1];
    }
    else
    {
        //    if sign up successed
        
        userDefault.user = userObj;
        userDefault.loginStatus = LoginViaEmailId;
        userDefault.city = userObj.city;
        userDefault.state = userObj.state;
        [UserDefault update];
        
        ConfigProfileVC *vc = [[ConfigProfileVC alloc] initWithNibName:@"ConfigProfileVC" bundle:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i=0; i<20; i++) {
            UserObj *obj = [[UserObj alloc] init];
            obj.firstname = @"User";
            obj.lastname = [NSString stringWithFormat:@"%d",i];
            obj.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
            [arr addObject:obj];
        }
        
//        [CommonHelpers appDelegate].arrDataFBFriends = arr;
        
    }

}

- (IBAction)actionSegment:(id)sender
{
    NSLog(@"segm index -> %d",segCtrGender.selectedSegmentIndex);
//    [self hideKeyBoard];
    
}
- (IBAction)actionTakeAPhoto:(id)sender
{
    imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera ;
        [imagePicker setDelegate:self];
        imagePicker.allowsEditing = YES ;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)actionGallery:(id)sender
{
    imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary ;
        [imagePicker setDelegate:self];
        imagePicker.allowsEditing = YES ;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)actionHideKeypad:(id)sender
{
    [self hideKeyBoard];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn -> textField ->%@",textField.text);
    if (textField == tfemail) {
        [tfpassword becomeFirstResponder];
    }
    else if (textField==tfpassword)
    {
//        [tfConfirmPassword becomeFirstResponder];
        [tfFirstName becomeFirstResponder];

    }
    else if (textField==tfConfirmPassword)
    {
        [tfFirstName becomeFirstResponder];
    }
    else if (textField == tfFirstName)
    {
        [tfLastName becomeFirstResponder];
    }
    else if (textField== tfLastName)
    {
        [tfCity becomeFirstResponder];
    }
    else if (textField == tfCity)
    {
        [tfState becomeFirstResponder];
    }
    else
    {
        [tfState resignFirstResponder];
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == tfemail) {
        if ([CommonHelpers validateEmail:[CommonHelpers trim:tfemail.text]]) {
            userDefault.emailID = [CommonHelpers trim:tfemail.text];
            [userDefault update];
        }
    }
    else if (textField == tfpassword)
    {
        if ([CommonHelpers validateEmail:[CommonHelpers trim:tfpassword.text]]) {
            userDefault.password = [CommonHelpers trim:tfpassword.text];
            [userDefault update];

        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    int offset = 0;
    // [scvLogin setContentSize:CGSizeMake(320, 520)];
    if (textField == tfemail) {
//        offset = 150;
    }
    else if (textField==tfpassword)
    {
//        offset = 200;

    }
    else if (textField==tfConfirmPassword)
    {
//        offset = 180;

    }
    else if (textField == tfFirstName)
    {
        offset = 50;

    }
    else if (textField== tfLastName)
    {
        offset = 100;

    }
    else if (textField == tfCity)
    {
        offset = 150;

    }
    else
    {
        offset = 200;

    }

    [scrollViewSignUp setContentOffset:CGPointMake(0, offset) animated:YES];
}
#pragma mark -Others


- (void) hideKeyBoard
{
    NSLog(@"Hide key board");
    [tfCity resignFirstResponder];
    [tfConfirmPassword resignFirstResponder];
    [tfemail resignFirstResponder];
    [tfFirstName resignFirstResponder];
    [tfLastName resignFirstResponder];
    [tfpassword resignFirstResponder];
    [tfState resignFirstResponder];
    [scrollViewSignUp setContentOffset:CGPointZero];
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (image!=nil) {        
        ivAvatar.image = image;        
        
    }else
    {
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
