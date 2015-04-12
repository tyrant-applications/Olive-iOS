//
//  OliveMapViewController.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 4. 12..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface OliveMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>{
    MKMapView *mapView;
    CLLocationManager *locationManager;
    
    MKPointAnnotation *point;
}

@end
