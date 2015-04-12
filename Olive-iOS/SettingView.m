//
//  SettingView.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 14..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "SettingView.h"
#import "ChangePasswordView.h"
#import "AppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation ToggleButton
-(id)init{
    self = [super init];
    if(self){
//        self.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setImage:[UIImage imageNamed:@"toggle_off.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"toggle_on.png"] forState:UIControlStateSelected];
    }
    return self;
}
@end
@implementation SettingView
@synthesize thumb;
@synthesize viewCont;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = OLIVE_DEFAULT_COLOR;
        
        CGFloat cWidth = 260.0f;
        CGFloat cHeight = 320.0f;
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - cWidth)/2.0f, (frame.size.height - cHeight)/2.0f, cWidth, cHeight)];
        
        
        thumb = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.0f, 50, 50)];
        [thumb sd_setImageWithURL:[NSURL URLWithString:MEDIA_URL([[OLNetworkManager manager] getProfile:@"picture"])] placeholderImage:[UIImage imageNamed:@"profile.png"]];

        thumb.contentMode = UIViewContentModeScaleAspectFill;
        [container addSubview:thumb];
        
        UIControl *thumbBtn = [[UIControl alloc] initWithFrame:thumb.frame];
        [thumbBtn addTarget:self action:@selector(thumbBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:thumbBtn];
        
        UILabel *myAccount = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 12.0f)];
        myAccount.text = @"My Account";
        myAccount.font = [UIFont systemFontOfSize:12.0f];
        myAccount.textColor = [UIColor whiteColor];
        [container addSubview:myAccount];

        UILabel *myEmail = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, 200, 24.0f)];
        myEmail.text = [[OLNetworkManager manager] getUsername];
        myEmail.font = [UIFont boldSystemFontOfSize:16.0f];
        myEmail.textColor = [UIColor whiteColor];
        [container addSubview:myEmail];

        UILabel *myPhone = [[UILabel alloc] initWithFrame:CGRectMake(60, 36, 200, 12.0f)];
        myPhone.text = @"010-1234-1230";
        myPhone.font = [UIFont systemFontOfSize:12.0f];
        myPhone.textColor = [UIColor whiteColor];
        [container addSubview:myPhone];

        
        CALayer *imageLayer = thumb.layer;
        [imageLayer setCornerRadius:50.0f/2.0f];
        [imageLayer setMasksToBounds:YES];
        [imageLayer setBorderWidth:2];
        [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
        [imageLayer setMasksToBounds:YES];
        
        UIButton *signinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        signinBtn.tag = 1;
        signinBtn.layer.masksToBounds = YES;
        signinBtn.frame = CGRectMake( 20.0f, 80, cWidth -40.0f, 40.0f);
        [signinBtn setTitle:@"Change Password" forState:UIControlStateNormal];
        signinBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [signinBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [signinBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        signinBtn.layer.borderWidth = 1.0f;
        signinBtn.layer.cornerRadius = 5.0f;
        [signinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [signinBtn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateHighlighted];
        
        signinBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [signinBtn addTarget:self action:@selector(changePassBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [container addSubview:signinBtn];
        
        
        UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        createBtn.tag = 1;
        createBtn.layer.masksToBounds = YES;
        createBtn.frame = CGRectMake( 20, 130, cWidth-40, 40.0f);
        [createBtn setTitle:@"Logout" forState:UIControlStateNormal];
        createBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [createBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [createBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        createBtn.layer.borderWidth = 1.0f;
        createBtn.layer.cornerRadius = 5.0f;
        [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [createBtn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateHighlighted];
        createBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [createBtn addTarget:self action:@selector(signoutBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [container addSubview:createBtn];
        
        
        UILabel *noti = [[UILabel alloc] initWithFrame:CGRectMake(0, 195, 140, 40.0f)];
        noti.text = @"Notifications";
        noti.font = [UIFont systemFontOfSize:14.0f];
        noti.textColor = [UIColor whiteColor];
        [container addSubview:noti];
        
        ToggleButton *notiBtn = [[ToggleButton alloc] init];
        notiBtn.selected = YES;
        notiBtn.frame = CGRectMake(170, 197, 120.0f, 36.0f);
        [notiBtn addTarget:self action:@selector(notiBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:notiBtn];
        

        UILabel *pass = [[UILabel alloc] initWithFrame:CGRectMake(0, 235, 140, 40.0f)];
        pass.text = @"Passcode Lock";
        pass.font = [UIFont systemFontOfSize:14.0f];
        pass.textColor = [UIColor whiteColor];
        [container addSubview:pass];

        ToggleButton *passBtn = [[ToggleButton alloc] init];
        passBtn.frame = CGRectMake(170, 237, 120.0f, 36.0f);
        [passBtn addTarget:self action:@selector(passBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:passBtn];

        
        UILabel *loc = [[UILabel alloc] initWithFrame:CGRectMake(0, 275, 140, 40.0f)];
        loc.text = @"Location Services";
        loc.font = [UIFont systemFontOfSize:14.0f];
        loc.textColor = [UIColor whiteColor];
        [container addSubview:loc];

        ToggleButton *locBtn = [[ToggleButton alloc] init];
        locBtn.selected = YES;
        locBtn.frame = CGRectMake(170, 277, 120.0f, 36.0f);
        [locBtn addTarget:self action:@selector(locBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:locBtn];

        
        [self addSubview:container];

    }
    return self;
}

-(void)notiBtnSelected:(ToggleButton *)btn{
    if (btn.selected == NO){
        
    }
    
    [btn setSelected:!btn.selected];

}

-(void)passBtnSelected:(ToggleButton *)btn{
    if (btn.selected == NO){
        
    }
    
    [btn setSelected:!btn.selected];
    
}

-(void)locBtnSelected:(ToggleButton *)btn{
    if (btn.selected == NO){
        
    }
    
    [btn setSelected:!btn.selected];
    
}


-(void)changePassBtnPressed{

    ChangePasswordView *changeView = [[ChangePasswordView alloc] initWithFrame:self.frame];
    changeView.alpha = 0.0f;
    [self.superview addSubview:changeView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    changeView.alpha = 1.0f;
    [UIView commitAnimations];

}

-(void)signoutBtnPressed{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign out" message:@"Your data will be removed. Do you want to sign out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == alertView.cancelButtonIndex){
        return;
    }
    
    //Remove Data
    [[OLNetworkManager manager] signout];

}


-(void)thumbBtnClicked{
    UIActionSheet *actionSheet = nil;
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:@"Delete"
                       otherButtonTitles:@"Camera roll", nil];
    }else{
        actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:@"Delete"
                                      otherButtonTitles:@"Take Picture", @"Camera roll", nil];
    }
    [actionSheet showInView:self];

}

#define DELETE_THUMB 0
#define TAKE_PICTURE 1
#define CAMERA_ROLL 2

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.cancelButtonIndex == buttonIndex) return;

    if(buttonIndex == DELETE_THUMB){
    
    }else if(buttonIndex == TAKE_PICTURE && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        picker.showsCameraControls = YES;
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window.rootViewController presentViewController:picker animated:YES completion:NULL];

    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window.rootViewController presentViewController:picker animated:YES completion:NULL];
    
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"%@",info);
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if(img != nil){
        [thumb setImage:[UIImage imageNamed:@"profile.png"]];
        
        NSData* thumbData = UIImagePNGRepresentation(img);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signupFinished:) name:API_UPDATE_ACCOUNT object:nil];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[[OLNetworkManager manager] getPassword] forKey:@"password"];
        [[OLNetworkManager manager] requestPostAPI:API_UPDATE_ACCOUNT withParameters:dict withToken:YES withFormData:thumbData];

    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)signupFinished:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_UPDATE_ACCOUNT object:nil];
    
    if(noti.object == nil){
        NSLog(@"Something wrong...");
        return;
    }
    
    NSLog(@"%@",noti.object);
    
    if([[noti.object objectForKey:@"success"] integerValue] == 1){
        NSDictionary *data = [noti.object objectForKey:@"data"];
  //       [thumb setImageWithURL:
    //          placeholderImage:[UIImage imageNamed:@"profile@2x.png"]];
        [[OLNetworkManager manager] saveUserProfile:data];
        [thumb sd_setImageWithURL:[NSURL URLWithString:THUMB_URL([data objectForKey:@"picture"])] placeholderImage:[UIImage imageNamed:@"profile.png"]];
        

        NSLog(@"%@",NSStringFromCGRect(thumb.frame));
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Oops:-(" message:[noti.object objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}




@end


