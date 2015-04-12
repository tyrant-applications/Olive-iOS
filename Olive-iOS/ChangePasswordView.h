//
//  ChangePasswordView.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 29..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordView : UIView <UITextFieldDelegate>{
    UITextField *password;
    UITextField *newpassword1;
    UITextField *newpassword2;
}

@end
