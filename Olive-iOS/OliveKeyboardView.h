//
//  OliveKeyboardView.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OliveButton : UIButton<UIAlertViewDelegate>{
    KeyboardButton *myBtnInfo;
}
@property (nonatomic, retain) KeyboardButton *myBtnInfo;
@end

@interface OliveKeyboardView : UIView{

}

-(id)initWithFrame:(CGRect)frame buttons:(NSArray *)buttons;
@end
