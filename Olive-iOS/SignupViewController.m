//
//  SignupViewController.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 15..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "SignupViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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
        
        UIImageView *thumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.png"]];
        thumb.frame = CGRectMake((self.view.frame.size.width - 50.0f)/2.0f, 60, 50, 50);
        thumb.contentMode = UIViewContentModeScaleAspectFit;
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
    container = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 380.0f)/2.0f, self.view.frame.size.width, 380.0f)];
    
    UIImageView *olive = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin_logo.png"]];
    olive.frame = CGRectMake((self.view.frame.size.width - 200.0f)/2.0f, 0, 200, 40);
    olive.contentMode = UIViewContentModeScaleAspectFit;
    [container addSubview:olive];
    
    UIImageView *thumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.png"]];
    thumb.frame = CGRectMake((self.view.frame.size.width - 50.0f)/2.0f, 80.0f, 50, 50);
    thumb.contentMode = UIViewContentModeScaleAspectFit;
    [container addSubview:thumb];
    
    CALayer *imageLayer = thumb.layer;
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
    

    password2 = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 180.0f)/2.0f, 240.0f, 180.0f, 30.0f)];
    password2.tag = 1;
    password2.secureTextEntry = YES;
    password2.keyboardType = UIKeyboardTypeAlphabet;
    password2.returnKeyType = UIReturnKeyDone;
    password2.delegate = self;
    password2.text = @"123123";
    password2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    password2.textColor = [UIColor whiteColor];
    password2.borderStyle = UITextBorderStyleNone;
    password2.font = [UIFont systemFontOfSize:14.0f];
    [container addSubview:password2];
    
    CALayer *borderLayer3 = [CALayer layer];
    borderLayer3.backgroundColor = [UIColor whiteColor].CGColor;
    borderLayer3.frame = CGRectMake(0, 29.0f, 180.0f, 1);
    [password2.layer addSublayer:borderLayer3];

    
    UIButton *signinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signinBtn.tag = 1;
    signinBtn.layer.masksToBounds = YES;
    signinBtn.frame = CGRectMake( password.frame.origin.x, 290.0f, 180.0f, 40.0f);
    [signinBtn setTitle:@"Create" forState:UIControlStateNormal];
    signinBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [signinBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [signinBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    signinBtn.layer.borderWidth = 1.0f;
    signinBtn.layer.cornerRadius = 5.0f;
    [signinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signinBtn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateHighlighted];
    
    signinBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [signinBtn addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [container addSubview:signinBtn];
    
    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.tag = 1;
    createBtn.layer.masksToBounds = YES;
    createBtn.frame = CGRectMake( password.frame.origin.x, 340.0f, 180.0f, 40.0f);
    [createBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    createBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [createBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [createBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    createBtn.layer.borderWidth = 1.0f;
    createBtn.layer.cornerRadius = 5.0f;
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createBtn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateHighlighted];
    createBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [createBtn addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [container addSubview:createBtn];
    
    
    
    [self.view addSubview:container];
    
    
    
}
-(void)cancelButtonPressed{
    NSLog(@"Hello");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)signupButtonPressed:(id)sender{
    NSString *alertMSG = nil;
    if([CommonUtils checkEmpty:email.text]){
        alertMSG = @"Please type valid email address.";
    }else if([CommonUtils checkEmpty:password.text]){
            alertMSG = @"Please type valid password.";
    }else if([CommonUtils checkEmpty:password2.text]){
        alertMSG = @"Please type password check.";
    }else if(![password.text isEqualToString:password.text]){
        alertMSG = @"Password doesn't match.";
    }
    
    if(alertMSG != nil){
        [[[UIAlertView alloc] initWithTitle:@"Oops:-(" message:alertMSG delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signupFinished:) name:API_CREATE_ACCOUNT object:nil];
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
    [dict setObject:email.text forKey:@"username"];
    [dict setObject:password.text forKey:@"password"];
    
    [[OLNetworkManager manager] requestPostAPI:API_CREATE_ACCOUNT withParameters:dict withToken:NO];
    
}


-(void)signupFinished:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_CREATE_ACCOUNT object:nil];
    
    if(noti.object == nil){
        NSLog(@"Something wrong...");
        return;
    }
    
    NSLog(@"%@",noti.object);
    
    if([[noti.object objectForKey:@"success"] integerValue] == 1){
        [[[UIAlertView alloc] initWithTitle:@"Hello:-)" message:@"Welcome to Olive!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

        [self cancelButtonPressed];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Oops:-(" message:[noti.object objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
