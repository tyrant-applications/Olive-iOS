//
//  MainViewController.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 1. 27..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindFriendsView.h"

typedef enum {
    FRIENDS_LIST = 0,
    ADD_FRIENDS = 1,
    SETTINGS = 2
} TABBAR_TYPE;

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDataSource, UITabBarDelegate>{
    TABBAR_TYPE current_type;
    IBOutlet UITabBar *_tabBar;
    
    FindFriendsView *_friendsView;
}

@property (nonatomic, retain) IBOutlet UITabBar *_tabBar;
@end
