//
//  ResPhotoVC.m
//  TasteSync
//
//  Created by Victor on 1/10/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResPhotoVC.h"
#import "CommonHelpers.h"
#import "ResQuestionVC.h"
#import "PhotoVC.h"
#import "TSPhotoRestaurantObj.h"
#import "RateCustom.h"

@interface ResPhotoVC ()<UITableViewDataSource,UITableViewDelegate,ResPhotoCellDelegate>
{
    __weak IBOutlet UILabel *lbResName;
    __weak IBOutlet UILabel *lbResDetail;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel* lbTimeOpen;
    NSString* _urlImage;
    BOOL isRequest;
    
}
- (IBAction)actionBack:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionQuestion:(id)sender;

@end

@implementation ResPhotoVC

@synthesize arrData=_arrData,
restaurantObj=_restaurantObj;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithArrayPhoto:(RestaurantObj*)restaurant
{
    self = [super initWithNibName:@"ResPhotoVC" bundle:nil];
    if (self) {
        self.restaurantObj = restaurant;
        self.arrData = [[NSMutableArray alloc] init];
        NSLog(@"count2: %d", [self.arrData count]);
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @""           , @"RestaurantID",
     nil];
    [CommonHelpers implementFlurry:params forKey:@"RestaurantPhoto" isBegin:YES];
    
    if (isRequest == NO) {
        NSString* photo_link = [NSString stringWithFormat:@"photos?userid=%@&restaurantid=%@",[UserDefault userDefault].userID, self.restaurantObj.uid];
        CRequest* photo_request = [[CRequest alloc]initWithURL:photo_link RQType:RequestTypeGet RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:2 WithView:self.view];
        photo_request.delegate = self;
        [photo_request startFormRequest];
        isRequest = YES;
    }
    
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     _restaurantObj.uid           , @"RestaurantID",
     nil];
    [CommonHelpers implementFlurry:params forKey:@"RestaurantPhoto" isBegin:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CommonHelpers setBackgroudImageForViewRestaurant:self.view];
    if (_restaurantObj.isOpenNow)
        lbTimeOpen.text = @"Open Now";
    else
        lbTimeOpen.text = @"Closed Now";
    
    RateCustom *rateCustom = [[RateCustom alloc] initWithFrame:CGRectMake(20, 100, 30, 4)];
    if (_restaurantObj.rates != 0) {
        [rateCustom setRateMedium:_restaurantObj.rates];
        [self.view addSubview:rateCustom];
        rateCustom.allowedRate = NO;
    }
    
    [self configView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configView
{
    if (_restaurantObj) {
        lbResName.text = _restaurantObj.name;
        lbResDetail.text = [CommonHelpers getInformationRestaurant:_restaurantObj];
    }
}

# pragma mark - IBAction's Define

- (IBAction)actionBack:(id)sender
{
    for (TSPhotoRestaurantObj* photo in self.arrData) {
        photo.photoURL = nil;
    }
    for (TSPhotoRestaurantObj* obj in self.arrData) {
        obj.image = nil;
    }
    [self.arrData removeAllObjects];
    [_tableView reloadData];
    [_tableView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionShare:(id)sender
{
    [CommonHelpers showShareView:nil andObj:_restaurantObj];
}

- (IBAction)actionQuestion:(id)sender
{
    ResQuestionVC *vc = [[ResQuestionVC alloc] initWithNibName:@"ResQuestionVC" bundle:nil];
    vc.restaurantObj = _restaurantObj;
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_arrData.count %3 == 0) {
        return _arrData.count/3;
    }
    else
        
    {
        return _arrData.count/3 +1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIndentifier = @"ResPhotoCell";
    
    ResPhotoCell *cell = (ResPhotoCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        cell =(ResPhotoCell *) [[[NSBundle mainBundle ] loadNibNamed:@"ResPhotoCell" owner:self options:nil] objectAtIndex:0];
    }
    
    
    TSPhotoRestaurantObj *photoImage1,*photoImage2,*photoImage3;
    
    if (_arrData.count > indexPath.row*3) {
        photoImage1 = [_arrData objectAtIndex:indexPath.row*3];
    }
    if (_arrData.count > indexPath.row*3+1) {
        photoImage2 = [_arrData objectAtIndex:indexPath.row*3+1];
    }
    if (_arrData.count > indexPath.row*3 + 2) {
        photoImage3 = [_arrData objectAtIndex:indexPath.row*3+2];
    }
    
    [cell initForCell:photoImage1 Index1:indexPath.row*3 image2:photoImage2 Index2:(indexPath.row*3+1) image3:photoImage3 Index3:(indexPath.row*3+2)];
    
    cell.delegate = self;
    
    return cell;
    
    
}

- (void) resPhotoCell:(ResPhotoCell *) resPhotoCell tag:(int) anTag
{
    
    PhotoVC *vc = [[PhotoVC alloc] initWithArrayPhotos:self.arrData AtIndex:anTag];
    vc.restaurantObj = self.restaurantObj;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray* dicPhoto = [response objectFromJSONString];
    for (NSDictionary* dic in dicPhoto) {
        TSPhotoRestaurantObj* obj = [[TSPhotoRestaurantObj alloc]init];
        obj.uid                              = [dic objectForKey:@"restaurantId"];
        obj.photoId                       = [dic objectForKey:@"photoId"];
        obj.prefix                          = [dic objectForKey:@"prefix"];
        obj.suffix                           = [dic objectForKey:@"suffix"];
        obj.width                           = [[dic objectForKey:@"width"] intValue];
        obj.height                          = [[dic objectForKey:@"height"] intValue];
        obj.ultimateSourceName = [dic objectForKey:@"ultimateSourceName"];
        obj.ultimateSourceUrl      = [dic objectForKey:@"ultimateSourceUrl"];
        obj.photoSource              = [dic objectForKey:@"photoSource"];
        [self.arrData addObject:obj];
    }
    
    int i = 0;
    for (TSPhotoRestaurantObj* photo in self.arrData) {
        //NSArray *extraParams = [NSArray arrayWithObjects:[NSNumber numberWithInt:i], nil];
        _urlImage = [NSString stringWithFormat:@"%@%dx%d%@", photo.prefix, photo.width, photo.height, photo.suffix];

        //_urlImage = [NSString stringWithFormat:@"%@160x160%@", photo.prefix, photo.suffix];
        photo.photoURL = _urlImage;
        
        i++;
    }
    [_tableView reloadData];
}
@end
