//
//  MainViewController.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 1. 27..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDataSource>{
    IBOutlet UITabBar *_tabBar;
}

@property (nonatomic, retain) IBOutlet UITabBar *_tabBar;
@end
