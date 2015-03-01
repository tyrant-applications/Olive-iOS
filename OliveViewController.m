//
//  OliveViewController.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 2. 22..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "OliveViewController.h"

@implementation OliveViewController
@synthesize _userID;

-(id)initWithUser:(NSString *)userid{
    self = [super init];
    if(self){
        self._userID = userid;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self._userID;

    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 44.0f)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self._userID]]];
    imageView.frame = CGRectMake(12, 6, 32, 32);

    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CALayer *imageLayer = imageView.layer;
    [imageLayer setCornerRadius:32.0f/2.0f];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderWidth:1];
    [imageLayer setBorderColor:RGB(0,0,0).CGColor];
    [imageLayer setMasksToBounds:YES];

    [container addSubview:imageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:container];

    [self setupViews];
}

-(void)setupViews{
    //Olive Table View
    _tableView = [[OliveTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [ViewSettings getOliveTableViewHeight])];
    [self.view addSubview:_tableView];
    
    //Olive Detail View
    _detailView = [[OliveDetailView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _tableView.frame.size.height - [ViewSettings getOliveKeyboardHeight])];

    [self.view addSubview:_detailView];
    
    //Olive Keyboard View
    _keyboardView = [[OliveKeyboardContainerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [ViewSettings getOliveKeyboardHeight], self.view.frame.size.width, [ViewSettings getOliveKeyboardHeight])];
    [self.view addSubview:_keyboardView];

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
