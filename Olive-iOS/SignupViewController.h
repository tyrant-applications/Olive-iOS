//
//  SignupViewController.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 21..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate>{
    UIView *container;

    UITextField *password2;
    UITextField *password;
    UITextField *email;
}

@end
