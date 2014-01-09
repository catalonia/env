//
//  AskContactVC.m
//  TasteSync
//
//  Created by Phu Phan on 11/9/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "AskContactVC.h"
#import "ContactObject.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AskContactCell.h"
#import "UserDefault.h"
#import "Base64.h"
#import "CommonHelpers.h"

@interface AskContactVC ()<AskContactCellDelegate>
{
    NSMutableArray* _arrayData;
    NSMutableArray* _arrayContact;
    NSMutableArray* _arrayTasteSyncUser;
    IBOutlet UITableView* _tableView;
    IBOutlet UITextField* _searchText;
    NSString* _askString;
    NSString* _recorequestID;
    ContactObject* _contactObj;
    BOOL reloaded;
    
    NSMutableArray* arrayTasteSyncID;
    int numberMessage, numberEmail;
    
}
@end

@implementation AskContactVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(id)initWithAsk:(NSString*)askString WithRecoID:(NSString *)recoID
{
    self = [super initWithNibName:@"AskContactVC" bundle:nil];
    if (self) {
        _askString = askString;
        _recorequestID = recoID;
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    NSDictionary *askhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%d",numberEmail]       , @"Email",
     [NSString stringWithFormat:@"%d",numberMessage]       , @"Message",
     [NSString stringWithFormat:@"%@",@""]  , @"TasteSyncID",
     nil];
    [CommonHelpers implementFlurry:askhomeParams forKey:@"Ask_Contact" isBegin:YES];
    
    if (!reloaded) {
        _arrayTasteSyncUser = [[NSMutableArray alloc] init ];
        CRequest* request = [[CRequest alloc]initWithURL:@"showProfileFriends" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:1 WithView:self.view];
        request.delegate = self;
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
        [request startFormRequest];
        
        CRequest* request2 = [[CRequest alloc]initWithURL:@"showProfileFollowers" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:2 WithView:self.view];
        request2.delegate = self;
        [request2 setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
        [request2 startFormRequest];
        
        reloaded = YES;
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    reloaded = NO;
    arrayTasteSyncID = [[NSMutableArray alloc]init];
    numberEmail = 0;
    numberMessage = 0;
    _arrayContact = [[NSMutableArray alloc]init];
    ABAddressBookRef addressBook;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        CFErrorRef error = nil;
        addressBook = ABAddressBookCreateWithOptions(NULL,&error);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // callback can occur in background, address book must be accessed on thread it was created on
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
                } else if (!granted) {
                    
                    
                } else {
                    // access granted
                    [self getPersonOutOfAddressBook];
                    
                    
                }
            });
        });
    } else {
        // iOS 4/5
        
        [self getPersonOutOfAddressBook];
    }
}

- (void)getPersonOutOfAddressBook
{
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook =
    ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook != nil)
    {
        NSLog(@"Succesful.");
        
        NSArray *allContacts = (__bridge_transfer NSArray
                                *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++)
        {
            ContactObject *person = [[ContactObject alloc] init];
            person.email = [[NSMutableArray alloc]init];
            person.phone = [[NSMutableArray alloc]init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            NSString *firstName = (__bridge_transfer NSString
                                   *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString
                                   *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *fullName =@"";
            if (![firstName isKindOfClass:[NSNull class]] && firstName.length != 0) {
                fullName = firstName;
                if (![lastName isKindOfClass:[NSNull class]] && lastName.length != 0) {
                    fullName = [fullName stringByAppendingString:[NSString stringWithFormat:@" %@",lastName]];
                }
            }
            else
            {
                fullName = lastName;
            }
            
            person.name = fullName;
            NSLog(@"name = %@ ", fullName);
            //email
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson,
                                                       kABPersonEmailProperty);
            NSUInteger j = 0;
            
            for (j = 0; j < ABMultiValueGetCount(emails); j++)
            {
                NSString *email = (__bridge_transfer NSString
                                   *)ABMultiValueCopyValueAtIndex(emails, j);
                NSLog(@"email = %@ ", email);
                if (j == 0)
                {
                    [person.email addObject:email];
                    
                }                              
                else if (j==1)                     
                    [person.email addObject:email];
            }           
            
            ABMultiValueRef phones = ABRecordCopyValue(contactPerson,kABPersonPhoneProperty);
            for (j = 0; j < ABMultiValueGetCount(phones); j++)
            {
                NSString *phone = (__bridge_transfer NSString
                                   *)ABMultiValueCopyValueAtIndex(phones, j);
                NSString* mobileLabel = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(phones, j);
                if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel] || [mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel] || [mobileLabel isEqualToString:(NSString*)kABPersonPhoneMainLabel]) {
                    NSLog(@"phone = %@ ", phone);
                    [person.phone addObject:phone];
                }
            }
            if (person.email.count != 0 || person.email.count != 0) {
                person.tasteSyncID = NO;
                [_arrayContact addObject:person];
            }
        }     
    }
    _arrayData = [[NSMutableArray alloc]initWithArray:_arrayContact];
    [_tableView reloadData];
    CFRelease(addressBook); 
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [_arrayData removeAllObjects];
    if ([searchText isEqualToString:@""]) {
        _arrayData = [[NSMutableArray alloc]initWithArray:_arrayContact];
        
    }
    else
    {
        for (ContactObject* obj in _arrayContact) {
            if ([[[NSString stringWithFormat:@"%@",obj.name] uppercaseString] rangeOfString:[searchText uppercaseString]].location != NSNotFound) {
                [_arrayData addObject:obj];
            }
        }
    }
    NSLog(@"%@, %@",searchText, _searchText.text);
    [_tableView reloadData];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIndentifier = @"AskContactCell";
    AskContactCell *cell = (AskContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        cell =(AskContactCell *) [[[NSBundle mainBundle ] loadNibNamed:@"AskContactCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.delegate = self;
    ContactObject* obj = [_arrayData objectAtIndex:indexPath.row];
    NSString* imageName = @"Tick mark icon.png";
    if (obj.email.count > 0) {
        if ([self checkUserTasteSync:obj]) {
            cell.buttonleft.enabled = NO;
            cell.buttonright.enabled = YES;
            if (!obj.isSendTasteSync) {
                imageName = @"icon_72.png";
            }
            else
            {
                cell.buttonright.enabled    = NO;
                cell.buttonleft.enabled     = NO;
            }
            [cell.buttonright setImage:[CommonHelpers getImageFromName:imageName] forState:UIControlStateHighlighted];
            [cell.buttonright setImage:[CommonHelpers getImageFromName:imageName] forState:UIControlStateNormal];
        }
        else
        {
            if (obj.phone.count == 0)
            {
                cell.buttonleft.enabled = NO;
                cell.buttonright.enabled = YES;
                if (!obj.isSendEmail) {
                    imageName = @"Message icon 2.png";
                }
                else
                {
                    cell.buttonright.enabled    = NO;
                    cell.buttonleft.enabled     = NO;
                }
                [cell.buttonright setImage:[CommonHelpers getImageFromName:imageName] forState:UIControlStateHighlighted];
                [cell.buttonright setImage:[CommonHelpers getImageFromName:imageName] forState:UIControlStateNormal];
            }
            else
            {
                cell.buttonleft.enabled = YES;
                cell.buttonright.enabled = YES;
                if (!obj.isSendPhone) {
                    imageName = @"Phone text message icon.png";
                }
                else
                {
                    cell.buttonleft.enabled     = NO;
                }
                [cell.buttonleft setImage:[CommonHelpers getImageFromName:imageName] forState:UIControlStateHighlighted];
                [cell.buttonleft setImage:[CommonHelpers getImageFromName:imageName] forState:UIControlStateNormal];
                imageName = @"Tick mark icon.png";
                if (!obj.isSendEmail) {
                    imageName = @"Message icon 2.png";
                }
                else
                {
                    cell.buttonright.enabled    = NO;
                }
                [cell.buttonright setImage:[CommonHelpers getImageFromName:imageName] forState:UIControlStateHighlighted];
                [cell.buttonright setImage:[CommonHelpers getImageFromName:imageName] forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        cell.buttonleft.enabled = NO;
        cell.buttonright.enabled = YES;
        if (!obj.isSendPhone) {
            imageName = @"Phone text message icon.png";
        }
        [cell.buttonright setImage:[CommonHelpers getImageFromName:imageName] forState:UIControlStateHighlighted];
        [cell.buttonright setImage:[CommonHelpers getImageFromName:imageName] forState:UIControlStateNormal];
    }
    
    cell.name.text = obj.name;
    return cell;
}

-(void)sortArray
{
    int n = [_arrayContact count];
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n;  j++) {
            ContactObject* obj1 = [_arrayContact objectAtIndex:i];
            ContactObject* obj2 = [_arrayContact objectAtIndex:j];
            if ([obj1.name compare:obj2.name] == NSOrderedDescending) {
                [_arrayContact removeObjectAtIndex:j];
                [_arrayContact insertObject:obj1 atIndex:j];
                [_arrayContact removeObjectAtIndex:i];
                [_arrayContact insertObject:obj2 atIndex:i];
            }
        }
    }
    
    NSMutableArray* arrayAdd = [[NSMutableArray alloc]init];
    NSMutableArray* arrayRemove = [[NSMutableArray alloc]init];
    for (ContactObject* obj in _arrayContact) {
        if ([self checkUserTasteSync:obj]) {
            ContactObject* contactObj = [[ContactObject alloc]init];
            contactObj.name = obj.name;
            contactObj.phone = [[NSMutableArray alloc]initWithArray:obj.phone];
            contactObj.email = [[NSMutableArray alloc]initWithArray:obj.email];
            contactObj.tasteSyncID = obj.tasteSyncID;
            contactObj.isTasteSyncUser = obj.isTasteSyncUser;
            contactObj.isSendTasteSync = obj.isSendTasteSync;
            contactObj.isSendPhone = obj.isSendPhone;
            contactObj.isSendEmail = obj.isSendEmail;
            [arrayAdd addObject:contactObj];
            [arrayRemove addObject:obj];
        }
    }
    for (ContactObject* obj in arrayRemove) {
        [_arrayContact removeObject:obj];
    }
    for (ContactObject* obj in arrayAdd) {
        [_arrayContact insertObject:obj atIndex:0];
    }
    _arrayData = [[NSMutableArray alloc]initWithArray:_arrayContact];
    
    NSMutableArray* arrayAdd2 = [[NSMutableArray alloc]init];
    NSMutableArray* arrayRemove2 = [[NSMutableArray alloc]init];
    for (ContactObject* obj in _arrayContact) {
        if ([obj.name isKindOfClass:[NSNull class]] || obj.name.length == 0) {
            ContactObject* contactObj = [[ContactObject alloc]init];
            contactObj.name = obj.name;
            contactObj.phone = [[NSMutableArray alloc]initWithArray:obj.phone];
            contactObj.email = [[NSMutableArray alloc]initWithArray:obj.email];
            contactObj.tasteSyncID = obj.tasteSyncID;
            contactObj.isTasteSyncUser = obj.isTasteSyncUser;
            contactObj.isSendTasteSync = obj.isSendTasteSync;
            contactObj.isSendPhone = obj.isSendPhone;
            contactObj.isSendEmail = obj.isSendEmail;
            [arrayAdd2 addObject:contactObj];
            [arrayRemove2 addObject:obj];
        }
    }
    for (ContactObject* obj in arrayRemove2) {
        [_arrayContact removeObject:obj];
    }
    for (ContactObject* obj in arrayAdd2) {
        [_arrayContact insertObject:obj atIndex:(_arrayContact.count)];
    }
    _arrayData = [[NSMutableArray alloc]initWithArray:_arrayContact];
    
    [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIndentifier = @"AskContactCell";
    AskContactCell *cell = (AskContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        cell =(AskContactCell *) [[[NSBundle mainBundle ] loadNibNamed:@"AskContactCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell.frame.size.height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}
- (void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    if (key == 1) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSArray* arrayFriend = [dic objectForKey:@"friendTasteSync"];
        
        
        for (NSDictionary* dic in arrayFriend) {
            UserObj* userObject = [[UserObj alloc]init];
            userObject.uid = [dic objectForKey:@"userId"];
            userObject.name = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"tsFirstName"], [dic objectForKey:@"tsLastName"]];
            userObject.avatarUrl = [dic objectForKey:@"photo"];
            userObject.email = [dic objectForKey:@"tsUserEmail"];
            [_arrayTasteSyncUser addObject:userObject];
        }
        [self sortArray];
    }
    if (key == 2) {
        
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@",response);
        NSArray* arrayFriend = [response objectFromJSONString];
        
        
        for (NSDictionary* dic in arrayFriend) {
            UserObj* userObject = [[UserObj alloc]init];
            userObject.uid = [dic objectForKey:@"userId"];
            userObject.name = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
            userObject.avatarUrl = [dic objectForKey:@"photo"];
            userObject.email = [dic objectForKey:@"emailId"];
            [_arrayTasteSyncUser addObject:userObject];
        }
        [self sortArray];
    }
    
}
-(void)pressButtonAtIndex:(int)index forcell:(UITableViewCell *)cell{
    AskContactCell *_cell = (AskContactCell*)cell;
    NSIndexPath* indexPath = [_tableView indexPathForCell:_cell];
    ContactObject* obj = [_arrayData objectAtIndex:indexPath.row];
    
    
    if (obj.email.count > 0) {
        if (obj.tasteSyncID) {
            CRequest* request = [[CRequest alloc]initWithURL:@"recoreqtscontact" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:3 WithView:self.view];
            request.delegate = self;
            [request setFormPostValue:_recorequestID forKey:@"recorequestid"];
            [request setFormPostValue:obj.tasteSyncID forKey:@"assigneduserid"];
            [request startFormRequest];
            obj.isSendTasteSync = YES;
            [_tableView reloadData];
            
            [arrayTasteSyncID addObject:obj.tasteSyncID];
            
        }
        else
        {
            if (obj.phone.count == 0)
            {
                [self sendEmail:obj];
            }
            else
            {
                switch (index) {
                    case 0:
                        [self sendMessage:obj];
                        
                        break;
                    case 1:
                        [self sendEmail:obj];
                        
                        break;
                    default:
                        break;
                }
            }
        }
    }
    else
    {
        [self sendMessage:obj];
    }
}

-(void)sendEmailWithAddress:(ContactObject*)obj ForIndex:(int)index
{
    NSString* htmlParse = [NSString stringWithFormat:@"%@ Which restaurant would you recommend?<br>%@<br>", _askString, @"Sent via Tastesync"];
    NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@""];
    [emailBody appendString:htmlParse];
    UIImage *emailImage = [CommonHelpers getImageFromName:@"icon_72.png"];
    //Convert the image into data
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(emailImage)];
    NSString *base64String = [imageData base64EncodedString];
    [emailBody appendString:[NSString stringWithFormat:@"<p><b><img src='data:image/png;base64,%@'></b></p>",base64String]];
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Need a restaurant recommendation"];
    [controller setToRecipients:[NSArray arrayWithObjects:[obj.email objectAtIndex:index], nil]];
    [controller setMessageBody:emailBody isHTML:YES];
    if (controller)
        [self presentViewController:controller animated:YES completion:nil];
}
-(void)sendMessageWithPhonenumber:(ContactObject*)obj ForIndex:(int)index
{
    NSArray *recipents = [[NSArray alloc]initWithObjects:[obj.phone objectAtIndex:index], nil];
    NSString *message = _askString;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void)sendEmail:(ContactObject*)obj
{
    if (obj.email.count == 1) {
        [self sendEmailWithAddress:obj ForIndex:0];
        _contactObj = obj;
    }
    else
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choice email" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
        actionSheet.tag = 1;
        for (NSString* str in obj.email) {
            [actionSheet addButtonWithTitle:str];
        }
        _contactObj = obj;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}
-(void)sendMessage:(ContactObject*)obj
{
    if (obj.phone.count == 1) {
        [self sendMessageWithPhonenumber:obj ForIndex:0];
        _contactObj = obj;
    }
    else
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choice phone number" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
        actionSheet.tag = 2;
        for (NSString* str in obj.phone) {
            [actionSheet addButtonWithTitle:str];
        }
        _contactObj = obj;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        _contactObj.isSendEmail = YES;
        numberEmail++;
    }
    if (result == MFMailComposeResultCancelled) {
        NSLog(@"Cancel");
    }
    
    [_tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancel");
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            _contactObj.isSendPhone = YES;
            numberMessage++;
            break;
            
        default:
            break;
    }
    
    [_tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        [self sendEmailWithAddress:_contactObj ForIndex:(buttonIndex - 1)];
    }
    else
    {
        [self sendMessageWithPhonenumber:_contactObj ForIndex:(buttonIndex - 1)];
    }
}
-(IBAction)actionBack
{
    NSString* str = @"";
    int count = 0;
    for (NSString* tastesyncID in arrayTasteSyncID) {
        if (count == 0) {
            str = tastesyncID;
        }
        else
            str = [str stringByAppendingString:tastesyncID];
        count++;
    }
    
    NSLog(@"Email Sent: %d", numberEmail);
    NSLog(@"Message Sent: %d", numberMessage);
    NSLog(@"TasteSync Sent: %@", str);
    
    NSDictionary *askhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%d",numberEmail]       , @"Email",
     [NSString stringWithFormat:@"%d",numberMessage]       , @"Message",
     [NSString stringWithFormat:@"%@",@""]  , str,
     nil];
    [CommonHelpers implementFlurry:askhomeParams forKey:@"Ask_Contact" isBegin:YES];
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionRestaurantViaAskTab:_recorequestID];
}
-(BOOL)checkUserTasteSync:(ContactObject*)contactObj
{
    int i = 0;
    for (NSString* email in contactObj.email) {
        for (UserObj* obj in _arrayTasteSyncUser) {
            if ([[NSString stringWithFormat:@"%@",obj.email] isEqualToString:[NSString stringWithFormat:@"%@",[contactObj.email objectAtIndex:i]]]) {
                contactObj.tasteSyncID = obj.uid;
                contactObj.isTasteSyncUser = YES;
                return YES;
            }
        }
        i++;
    }
    
    return NO;
}
@end
