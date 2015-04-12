//
//  ChangePasswordView.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 29..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "ChangePasswordView.h"

@implementation ChangePasswordView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = OLIVE_DEFAULT_COLOR;
        
        password = [[UITextField alloc] initWithFrame:CGRectMake((self.frame.size.width - 180.0f)/2.0f, 20.0f, 180.0f, 24.0f)];
        password.secureTextEntry = YES;
        password.keyboardType = UIKeyboardTypeAlphabet;
        password.returnKeyType = UIReturnKeyDone;
        password.delegate = self;
        password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Current Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        password.textColor = [UIColor whiteColor];
        password.borderStyle = UITextBorderStyleNone;
        password.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:password];
        
        CALayer *borderLayer2 = [CALayer layer];
        borderLayer2.backgroundColor = [UIColor whiteColor].CGColor;
        borderLayer2.frame = CGRectMake(0, password.frame.size.height - 1, 180.0f, 1);
        [password.layer addSublayer:borderLayer2];

        newpassword1 = [[UITextField alloc] initWithFrame:CGRectMake((self.frame.size.width - 180.0f)/2.0f, 55.0f, 180.0f, 24.0f)];
        newpassword1.secureTextEntry = YES;
        newpassword1.keyboardType = UIKeyboardTypeAlphabet;
        newpassword1.returnKeyType = UIReturnKeyDone;
        newpassword1.delegate = self;
        newpassword1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

        newpassword1.textColor = [UIColor whiteColor];
        newpassword1.borderStyle = UITextBorderStyleNone;
        newpassword1.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:newpassword1];
        
        CALayer *borderLayer = [CALayer layer];
        borderLayer.backgroundColor = [UIColor whiteColor].CGColor;
        borderLayer.frame = CGRectMake(0, password.frame.size.height - 1, 180.0f, 1);
        [newpassword1.layer addSublayer:borderLayer];

        newpassword2 = [[UITextField alloc] initWithFrame:CGRectMake((self.frame.size.width - 180.0f)/2.0f, 90.0f, 180.0f, 24.0f)];
        newpassword2.secureTextEntry = YES;
        newpassword2.keyboardType = UIKeyboardTypeAlphabet;
        newpassword2.returnKeyType = UIReturnKeyDone;
        newpassword2.delegate = self;
        newpassword2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        newpassword2.textColor = [UIColor whiteColor];
        newpassword2.borderStyle = UITextBorderStyleNone;
        newpassword2.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:newpassword2];
        
        CALayer *borderLayer3 = [CALayer layer];
        borderLayer3.backgroundColor = [UIColor whiteColor].CGColor;
        borderLayer3.frame = CGRectMake(0, password.frame.size.height - 1, 180.0f, 1);
        [newpassword2.layer addSublayer:borderLayer3];


        UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        createBtn.tag = 1;
        createBtn.layer.masksToBounds = YES;
        createBtn.frame = CGRectMake((self.frame.size.width - 180.0f)/2.0f + 100 , 130, 80, 40.0f);
        [createBtn setTitle:@"Change" forState:UIControlStateNormal];
        createBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [createBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [createBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        createBtn.layer.borderWidth = 1.0f;
        createBtn.layer.cornerRadius = 5.0f;
        [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [createBtn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateHighlighted];
        createBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [createBtn addTarget:self action:@selector(changeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:createBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.tag = 1;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.frame = CGRectMake((self.frame.size.width - 180.0f)/2.0f , 130, 80, 40.0f);
        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        cancelBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [cancelBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        cancelBtn.layer.borderWidth = 1.0f;
        cancelBtn.layer.cornerRadius = 5.0f;
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateHighlighted];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cancelBtn];

        
    }
    return self;

}


-(void)start{
    [password becomeFirstResponder];
}


-(void)cancelBtnPressed{
    if([password  isFirstResponder])    [password resignFirstResponder];
    if([newpassword1  isFirstResponder])    [newpassword1 resignFirstResponder];
    if([newpassword2  isFirstResponder])    [newpassword2 resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.alpha = 0.0f;
    [UIView setAnimationDidStopSelector:@selector(removeThis)];
    [UIView commitAnimations];
}
-(void)removeThis{
    [self removeFromSuperview];
}


-(void)changeBtnPressed{
    NSString *alertMSG = nil;
    if([CommonUtils checkEmpty:password.text]){
        alertMSG = @"Please type current password.";
    }else if([CommonUtils checkEmpty:newpassword1.text]){
        alertMSG = @"Please type new password";
    }else if([CommonUtils checkEmpty:newpassword2.text]){
        alertMSG = @"Please type confirm password";
    }else if(![newpassword1.text isEqualToString:newpassword2.text]){
        alertMSG = @"New password doesn't match.";
    }
    
    if(alertMSG != nil){
        [[[UIAlertView alloc] initWithTitle:@"Oops:-(" message:alertMSG delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    for(UIView *subview in self.subviews){
        subview.userInteractionEnabled = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signupFinished:) name:API_UPDATE_ACCOUNT object:nil];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:password.text forKey:@"password"];
    [dict setObject:newpassword1.text forKey:@"new_password"];
    
    [[OLNetworkManager manager] requestPostAPI:API_UPDATE_ACCOUNT withParameters:dict withToken:YES];
    
}


-(void)signupFinished:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_UPDATE_ACCOUNT object:nil];
    
    if(noti.object == nil){
        NSLog(@"Something wrong...");
        return;
    }
    
    NSLog(@"%@",noti.object);
    
    if([[noti.object objectForKey:@"success"] integerValue] == 1){
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Your password changed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [[OLNetworkManager manager ] savePassword:password.text];

        [self cancelBtnPressed];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Oops:-(" message:[noti.object objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        for(UIView *subview in self.subviews){
            subview.userInteractionEnabled = YES;
        }
    }
}

@end
