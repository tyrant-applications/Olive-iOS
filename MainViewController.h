//
//  MainViewController.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 1. 27..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindFriendsView.h"
#import "SettingView.h"

typedef enum {
    FRIENDS_LIST = 0,
    ADD_FRIENDS = 1,
    SETTINGS = 2
} TABBAR_TYPE;

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDataSource, UITabBarDelegate>{
    TABBAR_TYPE current_type;
    IBOutlet UITabBar *_tabBar;
    IBOutlet UITableView *_tableView;
    
    FindFriendsView *_friendsView;
    SettingView *_settingView;
    
    
    
    NSMutableArray *friends;
    NSMutableArray *rooms;
}

@property (nonatomic, retain) IBOutlet UITabBar *_tabBar;
@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, retain) NSMutableArray *friends;
@property (nonatomic, retain) NSMutableArray *rooms;
@end
