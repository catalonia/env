//
//  ResMoreInfoVC.m
//  TasteSync
//
//  Created by Victor on 1/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResMoreInfoVC.h"
#import "CommonHelpers.h"
#import "ResQuestionVC.h"
#import "RateCustom.h"

@interface ResMoreInfoVC ()<MKMapViewDelegate>
{
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UIView *viewInfo;
    __weak IBOutlet UILabel* lbName;
    __weak IBOutlet UILabel* _phone;
    __weak IBOutlet UILabel* _address;
    __weak IBOutlet UILabel* _website;
    __weak IBOutlet UILabel* _lblTitle;
    __weak IBOutlet UIButton* gotolink;
    __weak IBOutlet UIScrollView* flagScroll;
    CLLocationCoordinate2D coordRestaurant;
    NSString* nameRestaurant;
    NSString* actionClick;
}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionQuestion:(id)sender;

@end


@implementation ResMoreInfoVC

@synthesize restaurantObj=_restaurantObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRestaurantObj:(RestaurantObj*)restaurantObj
{
    self = [super initWithNibName:@"ResMoreInfoVC" bundle:nil];
    if (self) {
        self.restaurantObj = restaurantObj;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    actionClick = @"";
    _restaurantObj.website = @"";
    //self.navigationController.navigationBar.translucent = NO;
    [CommonHelpers setBackgroudImageForViewRestaurant:self.view];
    // Do any additional setup after loading the view from its nib.
    lbName.text = self.restaurantObj.name ;
    _lblTitle.text = [CommonHelpers getInformationRestaurant:self.restaurantObj];
    
    RateCustom *rateCustom = [[RateCustom alloc] initWithFrame:CGRectMake(10, 63, 30, 4)];
    if (_restaurantObj.rates != 0) {
        [rateCustom setRateMedium:_restaurantObj.rates];
        [flagScroll addSubview:rateCustom];
        rateCustom.allowedRate = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @""            , @"restaurant_id",
     @""            , @"Click",
     nil];
    [CommonHelpers implementFlurry:params forKey:@"RestaurantMore" isBegin:YES];
    
    NSString* link = [NSString stringWithFormat:@"extendedinfo?userid=%@&restaurantid=%@",[UserDefault userDefault].userID, self.restaurantObj.uid];
    CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:1 WithView:self.view];
    request.delegate = self;
    [request startFormRequest];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     _restaurantObj.uid            , @"restaurant_id",
     actionClick            , @"Click",
     nil];
    [CommonHelpers implementFlurry:params forKey:@"RestaurantMore" isBegin:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction's Define

- (IBAction)actionBack:(id)sender
{
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

-(void) displayLocation : (AddressAnnotation *) addAnnotation
{
    actionClick = @"Map";
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    
    region.span = span;
    region.center = addAnnotation.coordinate;
    
    [mapView addAnnotation:addAnnotation];
    [mapView setRegion:region];
    [mapView regionThatFits:region];
    
    
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    
    MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                           initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    customPinView.pinColor = MKPinAnnotationColorRed;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self
                    action:@selector(showDetails:)
          forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = rightButton;
    
    UIImageView *memorialIcon = [[UIImageView alloc] initWithImage:[CommonHelpers getImageFromName:@"googlemaps_pin.png"]];
    customPinView.leftCalloutAccessoryView = memorialIcon;
    
    return customPinView;
    
    
}

-(IBAction)showDetails:(id)sender
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(coordRestaurant.latitude, coordRestaurant.longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:nameRestaurant];
        [mapItem openInMapsWithLaunchOptions:nil];
    }
}

-(IBAction)callAction:(id)sender
{
    NSLog(@"%@",self.restaurantObj.phone);
    actionClick = @"Call";
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.restaurantObj.phone]];
    [[UIApplication sharedApplication] openURL:URL];
}
-(IBAction)gotoWebsite:(id)sender
{
    actionClick = @"Website";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_restaurantObj.website]];
}

-(void)addFlag:(NSString*)name Key:(NSString*)key
{
    NSString* str = [NSString stringWithFormat:@"%@",name];
    if ([str isEqualToString:@"true"]) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, flagScroll.contentSize.height+5, 300, 14)];
        label.font = [UIFont fontWithName:@"Avenir" size:12];
        label.text = [NSString stringWithFormat:@"%@: Yes", key];
        label.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
        label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        [flagScroll addSubview:label];
        flagScroll.contentSize = CGSizeMake(flagScroll.contentSize.width, flagScroll.contentSize.height + 29);
    }
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    NSDictionary* dic = [response objectFromJSONString];
    _phone.text = [NSString stringWithFormat:@"Phone: %@",[dic objectForKey:@"callPhoneNumber"]];
    _restaurantObj.phone = [dic objectForKey:@"callPhoneNumber"];
    _address.text = [dic objectForKey:@"address"];
    _restaurantObj.address = [dic objectForKey:@"address"];
    NSString* website = [NSString stringWithFormat:@"%@",[dic objectForKey:@"website"]];
    if (![website isEqualToString:@""]) {
        mapView.frame = CGRectMake(mapView.frame.origin.x, 90, mapView.frame.size.width, mapView.frame.size.height);
        _restaurantObj.website = website;
        _website.text = @"Visit Restaurant Website";
        flagScroll.contentSize = CGSizeMake(flagScroll.frame.size.width, 300);
    }
    else{
        mapView.frame = CGRectMake(mapView.frame.origin.x, 90, mapView.frame.size.width, mapView.frame.size.height);
        //viewInfo.frame = CGRectMake(viewInfo.frame.origin.x, 0, viewInfo.frame.size.width, viewInfo.frame.size.height);
        gotolink.enabled = NO;
        flagScroll.contentSize = CGSizeMake(flagScroll.frame.size.width, 300);
    }
    [self addFlag:[dic objectForKey:@"healthyOptionsFlag"] Key:@"Healthy Options"];
    [self addFlag:[dic objectForKey:@"wifiFlag"] Key:@"Wifi"];
    [self addFlag:[dic objectForKey:@"payCashonlyFlag"] Key:@"Cash Only"];
    [self addFlag:[dic objectForKey:@"reservationsFlag"] Key:@"Takes Reservations"];
    [self addFlag:[dic objectForKey:@"open24HoursFlag"] Key:@"Open 24 Hours"];
    [self addFlag:[dic objectForKey:@"parkingFlag"] Key:@"Parking"];
    [self addFlag:[dic objectForKey:@"parkingValetFlag"] Key:@"Valet Parking"];
    [self addFlag:[dic objectForKey:@"parkingFreeFlag"] Key:@"Free Parking"];
    [self addFlag:[dic objectForKey:@"parkingGarageFlag"] Key:@"Close to parking garage"];
    [self addFlag:[dic objectForKey:@"parkingLotFlag"] Key:@"Close to parking lot"];
    [self addFlag:[dic objectForKey:@"parkingStreetFlag"] Key:@"Street Parking"];
    [self addFlag:[dic objectForKey:@"parkingValidatedFlag"] Key:@"Parking Validated"];
    [self addFlag:[dic objectForKey:@"smokingFlag"] Key:@"Smoking"];
    [self addFlag:[dic objectForKey:@"accessibleWheelchairFlag"] Key:@"Wheel Chair Accessible"];
    [self addFlag:[dic objectForKey:@"alcoholFlag"] Key:@"Alcohol"];
    [self addFlag:[dic objectForKey:@"alcoholBarFlag"] Key:@"Alcohol Bar"];
    [self addFlag:[dic objectForKey:@"alcoholBeerWineFlag"] Key:@"Alcohol Beer Wine"];
    [self addFlag:[dic objectForKey:@"alcoholByobFlag"] Key:@"Alcohol Byob"];
    [self addFlag:[dic objectForKey:@"groupsGoodForFlag"] Key:@"Good for Groups"];
    [self addFlag:[dic objectForKey:@"kidsGoodForFlag"] Key:@"Kid Friendly"];
    [self addFlag:[dic objectForKey:@"kidsMenuFlag"] Key:@"Kids Menu"];
    [self addFlag:[dic objectForKey:@"mealBreakfastFlag"] Key:@"Meal Breakfast"];
    [self addFlag:[dic objectForKey:@"mealCaterFlag"] Key:@"Catering"];
    [self addFlag:[dic objectForKey:@"mealDeliverFlag"] Key:@"Delivery "];
    [self addFlag:[dic objectForKey:@"mealDinnerFlag"] Key:@"Open for Dinner"];
    [self addFlag:[dic objectForKey:@"mealLunchFlag"] Key:@"Open for Lunch"];
    [self addFlag:[dic objectForKey:@"mealTakeoutFlag"] Key:@"Takeout"];
    [self addFlag:[dic objectForKey:@"optionsGlutenfreeFlag"] Key:@"Gluten-free"];
    [self addFlag:[dic objectForKey:@"optionsLowfatFlag"] Key:@"Low fat options"];
    [self addFlag:[dic objectForKey:@"optionsOrganicFlag"] Key:@"Organic options"];
    [self addFlag:[dic objectForKey:@"optionsVeganFlag"] Key:@"Vegan friendly"];
    [self addFlag:[dic objectForKey:@"optionsVegetarianFlag"] Key:@"Vegetarian options"];
    [self addFlag:[dic objectForKey:@"roomPrivateFlag"] Key:@"Private Room"];
    [self addFlag:[dic objectForKey:@"seatingOutdoorFlag"] Key:@"Outdoor seating"];
    
    
    CLLocationCoordinate2D coordi = CLLocationCoordinate2DMake(self.restaurantObj.lattitude, self.restaurantObj.longtitude);
    coordRestaurant = coordi;
    nameRestaurant = [dic objectForKey:@"address"];
    AddressAnnotation *restaurantPlace = [[AddressAnnotation alloc] initWithName:self.restaurantObj.name details:[dic objectForKey:@"address"] coordinate:coordi];
    [self displayLocation:restaurantPlace];
}


@end
