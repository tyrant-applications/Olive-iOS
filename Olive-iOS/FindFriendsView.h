//
//  FindFriendsView.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 2..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindFriendsView : UIView <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *items;
    NSMutableArray *selectedItems;
    
    UITableView *_tableView;
    
    
    
    
}
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *selectedItems;
@end
