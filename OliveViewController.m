//
//  OliveViewController.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 2. 22..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "OliveViewController.h"
#import "AppDelegate.h"
#import "OliveMapViewController.h"

@implementation OliveViewController
@synthesize _userID;
@synthesize _roomID;
-(id)initWithUser:(NSString *)userid roomID:(NSNumber *)roomid{
    self = [super init];
    if(self){
        NSLog(@"Room ID: %@",roomid);
        self._userID = userid;
        self._roomID = roomid;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//OLIVE_BUTTON_TAPPED_CAMERA
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postOliveStarted:) name:OLIVE_BUTTON_TAPPED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postOliveLocationStarted:) name:OLIVE_BUTTON_TAPPED_LOCATION object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postOliveFinished:) name:API_POST_OLIVE object:nil];

    self.title = self._userID;
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_GET_NEW_OLIVE_FINISHED object:nil];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewMessageFinished) name:API_GET_NEW_OLIVE_FINISHED object:nil];

    
    self.navigationController.navigationBarHidden = NO;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 44.0f)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self._userID]]];
    imageView.frame = CGRectMake(12, 6, 32, 32);

    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CALayer *imageLayer = imageView.layer;
    [imageLayer setCornerRadius:32.0f/2.0f];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderWidth:1];
    [imageLayer setBorderColor:RGB(0,0,0).CGColor];
    [imageLayer setMasksToBounds:YES];

    [container addSubview:imageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:container];

    [self setupViews];
}

-(void)readMessage{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self._roomID forKey:@"room_id"];
    
    Messages *lastMSG = nil;
    NSArray *msgs = [[CoreDataManager manager] getAllMessagesInRoomID:self._roomID];
    if(msgs.count > 0){
        lastMSG = [msgs lastObject];
        [dict setObject:[lastMSG.message_id stringValue] forKey:@"last_msg_id"];
    }
    [[OLNetworkManager manager] requestPostAPI:API_READ_OLIVE withParameters:dict withToken:YES];
}


-(void)setupViews{
    //Olive Detail View
    if(_detailView == nil){
        _detailView = [[OliveDetailView alloc] initWithFrame:CGRectMake(0, [ViewSettings getOliveTableViewHeight], self.view.frame.size.width, self.view.frame.size.height - [ViewSettings getOliveTableViewHeight] - [ViewSettings getOliveKeyboardHeight])];
        _detailView.delegate = self;
        [self.view addSubview:_detailView];
    }
    
    //Olive Table View
    if(_tableView == nil){
        _tableView = [[OliveTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [ViewSettings getOliveTableViewHeight])];
        [_tableView setOlives:[[CoreDataManager manager] getAllMessagesInRoomID:self._roomID]];
        [self.view addSubview:_tableView];
    }
    
    [self readMessage];
    
    

    
    //Olive Keyboard View
    if(_keyboardView == nil){
        _keyboardView = [[OliveKeyboardContainerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [ViewSettings getOliveKeyboardHeight], self.view.frame.size.width, [ViewSettings getOliveKeyboardHeight])];
        _keyboardView.delegate = self;
        [self.view addSubview:_keyboardView];
    
    }

    
}

-(void)postOliveLocationStarted:(NSNotification *)noti{
    CLLocation *loc = noti.object;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%.8f,%.8f",loc.coordinate.latitude, loc.coordinate.longitude] forKey:@"contents"];
    
    [[OLNetworkManager manager] postOlive:OLIVE_LOCATION inRoom:self._roomID withInfo:dict];

}
-(void)postOliveStarted:(NSNotification *)noti{
    NSString *text = noti.object;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:text forKey:@"contents"];
    [[OLNetworkManager manager] postOlive:OLIVE_TEXT inRoom:self._roomID withInfo:dict];

}

-(void)postOliveFinished:(NSNotification *)noti{
    NSLog(@"%@",noti);
    
    if([noti.object isKindOfClass:[NSDictionary class]]){
        if([[noti.object objectForKey:@"success"] integerValue] == 1){
            NSDictionary *data = [noti.object objectForKey:@"data"];
            
            Messages *message = [[CoreDataManager manager] createMessagesObject];
            message.author = [data objectForKey:@"author"];
            message.contents = [data objectForKey:@"contents"];
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            message.msg_type = [f numberFromString:[data objectForKey:@"msg_type"]];
            message.reg_date = [[CoreDataManager manager] getNSDateFromServerDateForPostOlive:[data objectForKey:@"reg_date"]];
            message.room_id = [data objectForKey:@"room_id"];
            NSLog(@"%@",message.reg_date);
            [[CoreDataManager manager] save];
            
            [_tableView addOlive:message];
        }

    }
}

-(void)getNewMessageFinished{
    NSArray *unreads = [[OLNetworkManager manager] unreadMessages];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reg_date"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedUnreads = [unreads sortedArrayUsingDescriptors:sortDescriptors];

    for(Messages *message in sortedUnreads){
        if([message.room_id isEqualToNumber:self._roomID]){
            [_tableView addOlive:message];
        }
    }
    
    [self readMessage];

}


-(void)openCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.tintColor = OLIVE_DEFAULT_COLOR;

    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    picker.showsCameraControls = YES;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController:picker animated:YES completion:NULL];

}

-(void)openPhotoAlbum{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.tintColor = OLIVE_DEFAULT_COLOR;
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController:picker animated:YES completion:NULL];

}


- (void)openMapViewController{
    OliveMapViewController *vc = [[OliveMapViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController:nav animated:YES completion:NULL];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"%@",info);
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if(img != nil){
        NSData* imgData = UIImageJPEGRepresentation(img , 1.0);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:imgData forKey:@"img"];
        [[OLNetworkManager manager] postOlive:OLIVE_IMAGE inRoom:self._roomID withInfo:dict];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



-(void)showImageFullScreen:(UIImageView *)imageView{
    return;

}


@end
