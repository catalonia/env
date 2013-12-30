//
//  LoginScreenVC.m
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "LoginScreenVC.h"
#import "SignUpVC.h"
#import "CommonHelpers.h"

@interface LoginScreenVC ()<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *tfEmail,*tfPassword;
    __weak IBOutlet UIView *mainView;
    UITextField *txtEmail;
    
}


- (IBAction)actionLogin:(id)sender;

- (IBAction)actionForgotPassword:(id)sender;

- (IBAction)actionCreateNewUser:(id)sender;
@end

@implementation LoginScreenVC

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
    // Do any additional setup after loading the view from its nib.
    if ([CommonHelpers isPhone5]) {
        mainView.center = self.view.center;
    }
    
    UserDefault *userDefault = [UserDefault userDefault];
    if (userDefault.emailID && userDefault.password) {
        tfEmail.text = userDefault.emailID;
        tfPassword.text = userDefault.password;
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

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionLogin:(id)sender
{
    NSLog(@"actionLogin");
    if (![CommonHelpers validateEmail:tfEmail.text]) {
        [CommonHelpers showInfoAlertWithTitle:APP_NAME message:@"Email is invalided." delegate:nil tag:1];
    }
    else if(tfPassword.text.length==0){
        [CommonHelpers showInfoAlertWithTitle:APP_NAME message:@"Password is required." delegate:nil tag:2];
    }
    else
    {
        NSLog(@"If login successed");
        UserDefault *userDefault = [UserDefault userDefault];
        userDefault.loginStatus = LoginViaEmailId;
        userDefault.emailID = tfEmail.text;
        userDefault.password = tfPassword.text;
        
        UserObj *user = [[UserObj alloc] init];
        user.firstname = @"Penny";
        user.lastname = @"NGO";
        user.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
        user.email = tfEmail.text;
        user.password = tfPassword.text;
        user.gender = 1;
        
        userDefault.user = user;
        [UserDefault update];
        [[CommonHelpers appDelegate] showAskTab];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i=0; i<20; i++) {
            UserObj *obj = [[UserObj alloc] init];
            obj.firstname = @"User";
            obj.lastname = [NSString stringWithFormat:@"%d",i];
            obj.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
            [arr addObject:obj];
        }
        
//    [CommonHelpers appDelegate].arrDataFBFriends = arr;
    }

    
}

- (IBAction)actionForgotPassword:(id)sender
{
    debug(@"actionForgotPassword");
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Enter your email" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done",nil];
    
    if(txtEmail == nil)
        txtEmail = [[UITextField alloc] initWithFrame:CGRectMake(50, 60, 200, 30)];
    
    txtEmail.borderStyle = UITextBorderStyleRoundedRect;
    txtEmail.textColor = [UIColor darkTextColor];
    txtEmail.font = [UIFont systemFontOfSize:14.0];
    txtEmail.textAlignment = NSTextAlignmentLeft;
    txtEmail.placeholder = @"Email";
    [myAlertView addSubview:txtEmail];
    
       
    //Transform to move AlertView up to show keyboard
//    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 130.0);
//    [myAlertView setTransform:myTransform];
    
    [myAlertView show];
    

}

- (IBAction)actionCreateNewUser:(id)sender
{
    debug(@"actionCreateNewUser");
    SignUpVC *signUpVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
    [self.navigationController pushViewController:signUpVC animated:YES];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == tfEmail) {
        [tfPassword becomeFirstResponder];
    }
    else
    {
        [tfPassword resignFirstResponder];
    }
    return YES;
}

#pragma mark - Others

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
}

@end
