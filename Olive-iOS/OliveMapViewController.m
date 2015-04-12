//
//  OliveMapViewController.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 4. 12..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "OliveMapViewController.h"

@interface OliveMapViewController ()

@end

@implementation OliveMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Your Location";
    
    //[self.navigationController.navigationBar setTintColor:OLIVE_DEFAULT_COLOR];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    //[self.navigationController.navigationBar setTranslucent:NO];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //self.navigationController.navigationBar.tintColor = OLIVE_DEFAULT_COLOR;
    
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [mapView setShowsUserLocation:YES];
    
    mapView.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];

    }
    [locationManager startUpdatingLocation];
    
    mapView.showsUserLocation = NO;
    mapView.showsPointsOfInterest = NO;
    
    [self.view addSubview:mapView];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(longPress:)];
    lpgr.minimumPressDuration = .5; //user needs to press for 2 seconds
    [mapView addGestureRecognizer:lpgr];

}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}
-(void)post{
    [[NSNotificationCenter defaultCenter] postNotificationName:OLIVE_BUTTON_TAPPED_LOCATION object:[[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude]];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

- (void)longPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    [self getAddress:[[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude]];
    
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];

    CLLocation *currentLocation = newLocation;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 800, 800);
    [mapView setRegion:[mapView regionThatFits:region] animated:NO];

    [self getAddress:currentLocation];
}

-(void)getAddress:(CLLocation *)currentLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Failed to reverse-geocode: %@", [error localizedDescription]);
            return;
        }
        
        for (CLPlacemark *placemark in placemarks) {
            if(point != nil){
                [mapView removeAnnotation:point];
            }
            point = [[MKPointAnnotation alloc] init];
            point.coordinate = currentLocation.coordinate;
            point.subtitle = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] firstObject];
            point.title = @"Location";
            [mapView addAnnotation:point];
            [mapView selectAnnotation:point animated:YES];
        }
    }];

}
/*
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        CLLocationCoordinate2D coordinate = location.coordinate;
        NSString *longitude = [NSString stringWithFormat:@"%.8f", coordinate.longitude];
        NSString *latitude = [NSString stringWithFormat:@"%.8f", coordinate.latitude];
        NSLog(@"%@ %@",latitude,longitude);
        
    }
}*/

@end
