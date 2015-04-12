//
//  SettingView.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 14..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ToggleButton : UIButton

@end


@interface SettingView : UIView <UIAlertViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImageView *thumb;
    
    UIViewController *viewCont;
}
@property (nonatomic, retain) UIViewController *viewCont;
@property (nonatomic, retain) UIImageView *thumb;
@end
