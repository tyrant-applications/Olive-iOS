//
//  OliveKeyboardView.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 1..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface OliveKeyboardScrollView: UIScrollView{

}
@end

@interface OliveKeyboardContainerView : UIView{
    UIScrollView *_scrollView;
}

@property (nonatomic, retain) UIScrollView *_scrollView;
@end
