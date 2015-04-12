//
//  SigninViewController.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 15..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninViewController : UIViewController <UITextFieldDelegate>{
    UIView *container;
    
    UITextField *password;
    UITextField *email;
    
    UIImageView *_thumb;
}

@end
