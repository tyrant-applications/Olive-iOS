//
//  OliveDetailView.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@protocol OliveDetailViewDelegate <NSObject>

@required
-(void)showImageFullScreen:(UIImageView *)imageView;

@end

@interface OliveDetailView : UIView{
    UILabel *textDetail;
    UIImageView *imageDetail;
    MKMapView *mapDetail;
    MKPointAnnotation *point;
    id<OliveDetailViewDelegate> delegate;
}

@property (nonatomic, assign) id<OliveDetailViewDelegate> delegate;


@end
