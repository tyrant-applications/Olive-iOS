//
//  OliveDetailView.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "OliveDetailView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation OliveDetailView
@synthesize delegate = _delegate;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oliveTapped:) name:OLIVE_TAPPED object:nil];
    }
    return self;
}

-(void)showText:(NSString *)text{
    if(textDetail == nil){
        textDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        textDetail.textAlignment= NSTextAlignmentCenter;
        textDetail.lineBreakMode = NSLineBreakByWordWrapping;
        textDetail.numberOfLines = 0;
        textDetail.font = [UIFont boldSystemFontOfSize:20.0f];
        [self insertSubview:textDetail atIndex:0];
    }
    textDetail.hidden = NO;
    imageDetail.hidden = YES;
    mapDetail.hidden = YES;
    
    textDetail.text = text;
}

-(void)showImage:(NSString *)contents{
    if(imageDetail == nil){
        imageDetail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageDetail.contentMode = UIViewContentModeScaleAspectFit;
        imageDetail.backgroundColor = [UIColor blackColor];
        [self insertSubview:imageDetail atIndex:0];
        
        UIControl *overlay = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [imageDetail addSubview:overlay];
        [overlay addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];

    }
    textDetail.hidden = YES;
    mapDetail.hidden = YES;
    imageDetail.hidden = NO;
    
    //NSLog(@"%@",MEDIA_URL(contents));
    [imageDetail sd_setImageWithURL:[NSURL URLWithString:MEDIA_URL(contents)] placeholderImage:nil];

}

-(void)showLocation:(NSString *)loc{
    if( mapDetail == nil ){
        mapDetail = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [mapDetail setShowsUserLocation:NO];
        [self insertSubview:mapDetail atIndex:0];
    }
    
    textDetail.hidden = YES;
    imageDetail.hidden = YES;
    mapDetail.hidden = NO;

    [mapDetail removeAnnotations:[mapDetail annotations]];
    NSArray * locationArray = [loc componentsSeparatedByString: @","];

    CLLocation *location = [[CLLocation alloc] initWithLatitude: [[locationArray objectAtIndex:0] doubleValue] longitude: [[locationArray objectAtIndex:1] doubleValue]];

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 800, 800);
    [mapDetail setRegion:[mapDetail regionThatFits:region] animated:NO];

    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            if(point != nil){
                [mapDetail removeAnnotation:point];
            }
            point = [[MKPointAnnotation alloc] init];
            point.coordinate = location.coordinate;
            point.subtitle = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] firstObject];
            point.title = @"Location";
            [mapDetail addAnnotation:point];
            [mapDetail selectAnnotation:point animated:YES];
        }
    }];

}

-(void)oliveTapped:(NSNotification *)noti{
    //NSLog(@"%@",[noti object]);
    
    OLIVE_TYPE myType = [[noti.object objectForKey:@"type"] intValue];
    
    if(myType == OLIVE_TEXT){
        UILabel *myText = [noti.object objectForKey:@"contents"];
        [self showText:myText.text];
    }else if(myType == OLIVE_IMAGE){
        NSString *myImage = [noti.object objectForKey:@"contents"];
        [self showImage:myImage];
    }else if(myType == OLIVE_LOCATION){
        UILabel *myLocation = [noti.object objectForKey:@"contents"];
        [self showLocation:myLocation.text];
    }
}

-(void)tapped{
    if(!imageDetail.hidden){
        [_delegate showImageFullScreen:imageDetail];
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
