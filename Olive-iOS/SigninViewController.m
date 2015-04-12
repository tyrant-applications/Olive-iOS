//
//  SigninViewController.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 15..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "SigninViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

#import "SignupViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface SigninViewController ()

@end

@implementation SigninViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = OLIVE_DEFAULT_COLOR;
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([[OLNetworkManager manager] getToken] == nil){
        [self setupContainer];
    }else{
        UIView *checkContainer = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 340.0f)/2.0f, self.view.frame.size.width, 110.0f)];
        [self.view addSubview:checkContainer];
        
        UIImageView *olive = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_logo.png"]];
        olive.frame = CGRectMake((self.view.frame.size.width - 200.0f)/2.0f, 0, 200, 40);
        olive.contentMode = UIViewContentModeScaleAspectFit;
        [checkContainer addSubview:olive];
        
        UIImageView *thumb = [[UIImageView alloc] init];
        [thumb sd_setImageWithURL:[NSURL URLWithString:MEDIA_URL([[OLNetworkManager manager] getProfile:@"picture"])] placeholderImage:[UIImage imageNamed:@"profile.png"]];

        thumb.frame = CGRectMake((self.view.frame.size.width - 50.0f)/2.0f, 60, 50, 50);
        thumb.contentMode = UIViewContentModeScaleAspectFill;
        [checkContainer addSubview:thumb];
        
        CALayer *imageLayer = thumb.layer;
        [imageLayer setCornerRadius:50.0f/2.0f];
        [imageLayer setMasksToBounds:YES];
        [imageLayer setBorderWidth:2];
        [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
        [imageLayer setMasksToBounds:YES];

        checkContainer.center = self.view.center;

        [self performSelector:@selector(goToMain) withObject:nil afterDelay:1.0f];
    }
}

-(void)goToMain{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nav = (UINavigationController *)[sb instantiateViewControllerWithIdentifier:@"main-nav-controller"];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate goToMain:nav];
    
}

- (void)setupContainer{
    if(container != nil){
        return;
    }
    container = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 340.0f)/2.0f, self.view.frame.size.width, 340.0f)];
    
    
    UIImageView *olive = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_logo.png"]];
    olive.frame = CGRectMake((self.view.frame.size.width - 200.0f)/2.0f, 0, 200, 40);
    olive.contentMode = UIViewContentModeScaleAspectFit;
    [container addSubview:olive];
    
    _thumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.png"]];
    _thumb.frame = CGRectMake((self.view.frame.size.width - 50.0f)/2.0f, 80.0f, 50, 50);
    _thumb.contentMode = UIViewContentModeScaleAspectFill;
    [container addSubview:_thumb];
    
    CALayer *imageLayer = _thumb.layer;
    [imageLayer setCornerRadius:50.0f/2.0f];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderWidth:2];
    [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
    [imageLayer setMasksToBounds:YES];

    
    email = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 180.0f)/2.0f, 160.0f, 180.0f, 30.0f)];
    email.keyboardType = UIKeyboardTypeEmailAddress;
    email.returnKeyType = UIReturnKeyDone;
    email.delegate = self;
    email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    email.text = @"ujlikes@naver.com";
    email.textColor = [UIColor whiteColor];
    email.borderStyle = UITextBorderStyleNone;
    email.font = [UIFont systemFontOfSize:14.0f];
    [container addSubview:email];
    
    CALayer *borderLayer = [CALayer layer];
    borderLayer.backgroundColor = [UIColor whiteColor].CGColor;
    borderLayer.frame = CGRectMake(0, 29.0f, 180.0f, 1);
    [email.layer addSublayer:borderLayer];

    
    password = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 180.0f)/2.0f, 200.0f, 180.0f, 30.0f)];
    password.secureTextEntry = YES;
    password.keyboardType = UIKeyboardTypeAlphabet;
    password.returnKeyType = UIReturnKeyDone;
    password.delegate = self;
    password.text = @"123123";
    password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    password.textColor = [UIColor whiteColor];
    password.borderStyle = UITextBorderStyleNone;
    password.font = [UIFont systemFontOfSize:14.0f];
    [container addSubview:password];
    
    CALayer *borderLayer2 = [CALayer layer];
    borderLayer2.backgroundColor = [UIColor whiteColor].CGColor;
    borderLayer2.frame = CGRectMake(0, 29.0f, 180.0f, 1);
    [password.layer addSublayer:borderLayer2];

    
    UIButton *signinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signinBtn.tag = 1;
    signinBtn.layer.masksToBounds = YES;
    signinBtn.frame = CGRectMake( password.frame.origin.x, 250.0f, 180.0f, 40.0f);
    [signinBtn setTitle:@"Sign in" forState:UIControlStateNormal];
    signinBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [signinBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [signinBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    signinBtn.layer.borderWidth = 1.0f;
    signinBtn.layer.cornerRadius = 5.0f;
    [signinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signinBtn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateHighlighted];

    signinBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [signinBtn addTarget:self action:@selector(signinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [container addSubview:signinBtn];

    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.tag = 1;
    createBtn.layer.masksToBounds = YES;
    createBtn.frame = CGRectMake( password.frame.origin.x, 300.0f, 180.0f, 40.0f);
    [createBtn setTitle:@"Create an account" forState:UIControlStateNormal];
    createBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [createBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [createBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    createBtn.layer.borderWidth = 1.0f;
    createBtn.layer.cornerRadius = 5.0f;
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createBtn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateHighlighted];
    createBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [createBtn addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [container addSubview:createBtn];

    
    
    [self.view addSubview:container];
    
    
    
}
-(void)createButtonPressed:(id)sender{
    SignupViewController *viewCont = [[SignupViewController alloc] init];
    viewCont.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:viewCont animated:YES completion:^{
        
    }];
}

-(void)signinButtonPressed:(id)sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signinFinished:) name:API_ACCESS_TOKEN object:nil];
    //Hide Buttons
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    for(UIView *subview in container.subviews){
        if(subview.tag == 1){
            subview.userInteractionEnabled = NO;
            subview.alpha = 0.0f;
        }
    }
    
    [UIView commitAnimations];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:CLIENT_ID forKey:@"client_id"];
    [dict setObject:CLIENT_SECRET forKey:@"client_secret"];
    [dict setObject:GRANT_TYPE forKey:@"grant_type"];
    [dict setObject:email.text forKey:@"username"];
    [dict setObject:password.text forKey:@"password"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:@"" forKey:@"device_id"];

    [[OLNetworkManager manager] requestPostAPI:API_ACCESS_TOKEN withParameters:dict withToken:NO];

}


-(void)signinFinished:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_ACCESS_TOKEN object:nil];
    
    if(noti.object == nil){
        NSLog(@"Something wrong...");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign in Failed" message:@"Something wrong.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        for(UIView *subview in container.subviews){
            if(subview.tag == 1){
                subview.userInteractionEnabled = YES;
                subview.alpha = 1.0f;
            }
        }
        
        [UIView commitAnimations];

        return;
    }
    
    NSLog(@"%@",noti.object);
    
    NSString *token = [(NSDictionary *)noti.object objectForKey:@"access_token"];
    if(token != nil){
        [[OLNetworkManager manager] saveToken:token];
        [[OLNetworkManager manager ] saveUsername:email.text];
        [[OLNetworkManager manager ] savePassword:password.text];
        
        [self performSelector:@selector(loadMyInfo) withObject:nil afterDelay:0.5f];
    }else{
        NSLog(@"Sign in Failed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign in Failed" message:@"Something wrong.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        for(UIView *subview in container.subviews){
            if(subview.tag == 1){
                subview.userInteractionEnabled = YES;
                subview.alpha = 1.0f;
            }
        }
        
        [UIView commitAnimations];

    }
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.25
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGFloat oriY = (self.view.frame.size.height - 340.0f)/2.0f - 100.0f;
                         container.frame = CGRectMake(0, oriY, container.frame.size.width, container.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.25
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGFloat oriY = (self.view.frame.size.height - 340.0f)/2.0f;
                         container.frame = CGRectMake(0, oriY, container.frame.size.width, container.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
     
        [_thumb sd_setImageWithURL:[NSURL URLWithString:MEDIA_URL([[OLNetworkManager manager] getProfile:@"picture"])] placeholderImage:[UIImage imageNamed:@"profile.png"]];

    }
    [self performSelector:@selector(goToMain) withObject:nil afterDelay:1.0f];
}

@end
