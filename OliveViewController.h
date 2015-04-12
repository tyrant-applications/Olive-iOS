//
//  OliveViewController.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 2. 22..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OliveTableView.h"
#import "OliveKeyboardContainerView.h"

@interface OliveViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, OliveKeyboardContainerViewDelegate,OliveDetailViewDelegate>{
    NSString *_userID;
    NSNumber *_roomID;
    
    OliveTableView *_tableView;
    OliveDetailView *_detailView;
    OliveKeyboardContainerView *_keyboardView;
}

@property (nonatomic, retain) NSString *_userID;
@property (nonatomic, retain) NSNumber *_roomID;

-(id)initWithUser:(NSString *)userid roomID:(NSNumber *)roomid;

@end
