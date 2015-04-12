//
//  MainViewController.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 1. 27..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "MainViewController.h"
#import "FriendsTableViewCell.h"
#import "OliveViewController.h"



@implementation MainViewController
@synthesize _tabBar;
@synthesize friends;
@synthesize rooms;
@synthesize _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friends = [[NSMutableArray alloc] init];
    self.rooms = [[NSMutableArray alloc] init];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    self.title = @"";
    //self.title = @"Olive";
    current_type = FRIENDS_LIST;
    [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:0]];
    // Do any additional setup after loading the view.

    [self setTitleView];

    
    
    [self loadFriends];
    [self loadRooms];
    [self loadMyInfo];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFriendsNoLoad) name:API_ADD_FRIENDS_FINISHED object:nil];
    
    [[OLNetworkManager manager] getNewMessages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewMessageFinished:) name:API_GET_NEW_OLIVE_FINISHED object:nil];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;

    
    if(_friendsView == nil){
        _friendsView = [[FindFriendsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - _tabBar.frame.size.height)];
        _friendsView.hidden= YES;
        [self.view addSubview:_friendsView];
    }
    
    if(_settingView == nil){
        _settingView = [[SettingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - _tabBar.frame.size.height)];
        _settingView.hidden = YES;
        [self.view addSubview:_settingView];
    }
    
}

- (void)setTitleView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44.0f)];
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = OLIVE_DEFAULT_COLOR;
    if(_tabBar.selectedItem.tag == FRIENDS_LIST){
        label.text = @"Olive";
    }else if(_tabBar.selectedItem.tag == ADD_FRIENDS){
        //ADD friends view
        label.text = @"Add Friends";
    }else if(_tabBar.selectedItem.tag == SETTINGS){
        label.text = @"Settings";
    }
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.navigationItem.titleView = label;
}


-(void)setFooterView{
    UIView *_tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tabBar.frame.size.width, _tabBar.frame.size.height)];
    CGFloat btnWidth = self.view.frame.size.width/3.0f;
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"footer_add.png"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"footer_add_pressed.png"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(btnWidth, 0, btnWidth, _tabView.frame.size.height);
    [_tabView addSubview:addBtn];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"footer_setting.png"] forState:UIControlStateNormal];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"footer_setting_pressed.png"] forState:UIControlStateNormal];
    
    settingBtn.frame = CGRectMake(btnWidth*2, 0, btnWidth, _tabView.frame.size.height);
    [_tabView addSubview:settingBtn];
    
    [_tabBar addSubview:_tabView];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(current_type == item.tag){
        return;
    }
    current_type = item.tag;
    _friendsView.hidden = YES;
    _settingView.hidden = YES;
    if(item.tag == FRIENDS_LIST){
        //FriendsList

    }else if(item.tag == ADD_FRIENDS){
        //ADD friends view
        _friendsView.hidden = NO;
    }else if(item.tag == SETTINGS){
        _settingView.hidden = NO;
    }
    
    [self setTitleView];
}

-(void)loadRooms{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listRoomsFinished:) name:API_LIST_ROOMS object:nil];
    [[OLNetworkManager manager] requestPostAPI:API_LIST_ROOMS withParameters:nil withToken:YES];
}


-(void)loadFriendsNoLoad{
    [self.friends removeAllObjects];
    [self.friends addObjectsFromArray:[[CoreDataManager manager] getAllFriends]];
    [self._tableView reloadData];
}


-(void)loadFriends{
    [self.friends removeAllObjects];
    [self.friends addObjectsFromArray:[[CoreDataManager manager] getAllFriends]];
    [self._tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listFriendsFinished:) name:API_LIST_FRIENDS object:nil];
    [[OLNetworkManager manager] requestPostAPI:API_LIST_FRIENDS withParameters:nil withToken:YES];
}

-(void)loadMyInfo{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMyInfoFinished:) name:API_LOAD_USER_INFO object:nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[OLNetworkManager manager] getUsername] forKey:@"friends_id"];
    [[OLNetworkManager manager] requestPostAPI:API_LOAD_USER_INFO withParameters:dict withToken:YES];
}


-(void)loadMyInfoFinished:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_LOAD_USER_INFO object:nil];
    
    if(noti.object == nil){
        NSLog(@"Something wrong...");
        return;
    }
    if([[noti.object objectForKey:@"success"] integerValue] == 1){
        NSArray *data = [noti.object objectForKey:@"data"];
        if([data count] == 1)
            [[OLNetworkManager manager] saveUserProfile:[data objectAtIndex:0]];
    }
}


-(void)getNewMessageFinished:(NSNotification *)noti{
    
    [self._tableView reloadData];
//    [[OLNetworkManager manager] performSelector:@selector(getNewMessages) withObject:nil afterDelay:1.0f];
}

-(void)listRoomsFinished:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_LIST_ROOMS object:nil];

    //NSLog(@"%@",noti);
    
    if([noti.object isKindOfClass:[NSDictionary class]]){
        NSArray *data = [noti.object objectForKey:@"data"];
        for(NSDictionary *room_info in data){
            NSDate* dateFromString = [[CoreDataManager manager] getNSDateFromServerDate:[room_info objectForKey:@"create_date"]];
            
            Rooms *room = [[CoreDataManager manager] getOrCreateRoomsObject:[[room_info objectForKey:@"id"] integerValue]];
            room.create_date = dateFromString;
            room.attendants_list = [room_info objectForKey:@"room_attendants"];
            
            
            if([[room_info objectForKey:@"last_msg"] isKindOfClass:[NSDictionary class]]){
                room.last_msg = [[room_info objectForKey:@"last_msg"] objectForKey:@"contents"];
            }else{
                room.last_msg = @"";
            }
            
            
        }
    
        [[CoreDataManager manager] save];
        
        [self.rooms removeAllObjects];
        [self.rooms addObjectsFromArray:[[CoreDataManager manager] getAllRooms]];
        [self._tableView reloadData];
    }

}
-(void)listFriendsFinished:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_LIST_FRIENDS object:nil];
    NSLog(@"%@",noti);
    
    if([noti.object isKindOfClass:[NSDictionary class]]){
        NSArray *data = [noti.object objectForKey:@"data"];
        for(NSDictionary *friendInfo in data){
            NSDate* dateFromString = [[CoreDataManager manager] getNSDateFromServerDate:[friendInfo objectForKey:@"update_date"]];

            Friends *friend = [[CoreDataManager manager] getOrCreateFriendsObject:[friendInfo objectForKey:@"username"]];
            
            if([friend.update_date compare:dateFromString] == NSOrderedAscending){
                //Do Update
                if([friendInfo objectForKey:@"phone"] != nil && [[friendInfo objectForKey:@"phone"] isKindOfClass:[NSString class]])
                    friend.phone = [friendInfo objectForKey:@"phone"];
                friend.picture = [friendInfo objectForKey:@"picture"];
                friend.update_date = dateFromString;
            }
            
        }
    }
    [[CoreDataManager manager] save];
    
    [self.friends removeAllObjects];
    [self.friends addObjectsFromArray:[[CoreDataManager manager] getAllFriends]];
    [self._tableView reloadData];

}


#pragma mark -
#pragma mark TableView Related
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friends count];
}

#define CELL_HEIGHT 60.0f
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

#define SidePadding 2.0f
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    FriendsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[FriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    
    cell.detailTextLabel.text = @"";
    Friends *friend = [self.friends objectAtIndex:indexPath.row];
    Rooms *room = [self findRoomWithFriend:friend];
    if(room){
        cell.detailTextLabel.text = room.last_msg;
        //NSLog(@"%@",room);
    }
    
    Messages *last_msg = [[CoreDataManager manager] getLastMessageInRoomID:room.room_id];
    if(last_msg){
        if([last_msg.msg_type integerValue] == OLIVE_TEXT)
            cell.detailTextLabel.text = last_msg.contents;
        else if([last_msg.msg_type integerValue] == OLIVE_IMAGE)
            cell.detailTextLabel.text = @"(Photo)";
        else if([last_msg.msg_type integerValue] == OLIVE_LOCATION)
            cell.detailTextLabel.text = @"(Location)";
    }
    //NSLog(@"DB LAST : %@",last_msg.reg_date);

    int unread_cnt = 0;
    NSMutableArray *unreads = [[OLNetworkManager manager] unreadMessages];
    if(room != nil){
        for(Messages *unread in unreads){
            if([unread.room_id isEqualToNumber:room.room_id]){
                unread_cnt++;
            }
        }
    }
    
    if(unread_cnt){
        UIView *accView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, 32, 24)];
        UILabel *count = [[UILabel alloc] initWithFrame:CGRectZero];
        count.backgroundColor = OLIVE_DEFAULT_COLOR;
        count.text = [NSString stringWithFormat:@"%d",unread_cnt];
        count.font = [UIFont systemFontOfSize:14.0f];
        count.adjustsFontSizeToFitWidth = YES;
        count.textAlignment = NSTextAlignmentCenter;
        count.textColor = [UIColor whiteColor];
        count.frame = CGRectMake(8, 0, 24, 24);
        [accView addSubview:count];
        cell.accessoryView = accView;
        
        CALayer *imageLayer = count.layer;
        [imageLayer setCornerRadius:12.0f];
        [imageLayer setMasksToBounds:YES];
        //[imageLayer setBorderWidth:1];
        //[imageLayer setBorderColor:RGB(0,0,0).CGColor];
        [imageLayer setMasksToBounds:YES];

        //cell.contentView.backgroundColor = OLIVE_DEFAULT_COLOR;
        //cell.backgroundColor = OLIVE_DEFAULT_COLOR;
    }else{
        cell.accessoryView = nil;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.textLabel.text = friend.username;
    cell.img = friend.picture;
//    cell.detailTextLabel.text = [room.room_id stringValue];
//    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UITableViewCell *cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    Friends *friend = [self.friends objectAtIndex:indexPath.row];

    
    Rooms *room = [self findRoomWithFriend:friend];
    if(room){
        OliveViewController *viewContr = [[OliveViewController alloc] initWithUser:friend.username roomID:room.room_id];
        [self.navigationController pushViewController:viewContr animated:YES];
        return;
    }
    
    // Create Rooms
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomCreateFinished:) name:API_CREATE_ROOMS object:nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:friend.username forKey:@"friends_id"];
    [[OLNetworkManager manager] requestPostAPI:API_CREATE_ROOMS withParameters:dict withToken:YES];

}

-(void)roomCreateFinished:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_LIST_ROOMS object:nil];
    
    NSLog(@"%@",noti);

    if([noti.object isKindOfClass:[NSDictionary class]]){
        NSDictionary *data = [noti.object objectForKey:@"data"];
        NSDictionary *room_info = [data objectForKey:@"room"];
        NSDate* dateFromString = [[CoreDataManager manager] getNSDateFromServerDate:[room_info objectForKey:@"create_date"]];
            
        Rooms *room = [[CoreDataManager manager] getOrCreateRoomsObject:[[room_info objectForKey:@"id"] integerValue]];
        room.create_date = dateFromString;
        room.attendants_list = [room_info objectForKey:@"room_attendants"];
        
        if([[room_info objectForKey:@"last_msg"] isKindOfClass:[NSDictionary class]]){
            room.last_msg = [[room_info objectForKey:@"last_msg"] objectForKey:@"contents"];
        }else{
            room.last_msg = @"";
        }

        [[CoreDataManager manager] save];
        
        [self.rooms removeAllObjects];
        [self.rooms addObjectsFromArray:[[CoreDataManager manager] getAllRooms]];
        [self._tableView reloadData];
        
        NSString *username = nil;
        for(NSDictionary *attendant in (NSArray *)[data objectForKey:@"room_attentdants"]){
            if(![[attendant objectForKey:@"username"] isEqualToString:[[OLNetworkManager manager] getUsername]]){
                username = [attendant objectForKey:@"username"];
                break;
            }
        }
        if(username != nil){
            OliveViewController *viewContr = [[OliveViewController alloc] initWithUser:@"" roomID:room.room_id];
            [self.navigationController pushViewController:viewContr animated:YES];
        }
        
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



-(Rooms *)findRoomWithFriend:(Friends *)friend{
    for(Rooms *room in self.rooms){
        NSArray *attendants = [room.attendants_list componentsSeparatedByString:@","];
        if ([attendants containsObject:friend.username]) {
            return room;
        }
    }
    return nil;
}



// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        
//        Friends *friend = [self.friends objectAtIndex:indexPath.row];
//        Rooms *room = [self findRoomWithFriend:friend];

    }
}


@end
