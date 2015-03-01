//
//  MainViewController.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 1. 27..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "MainViewController.h"
#import "FriendsTableViewCell.h"
#import "OliveViewController.h"


@implementation MainViewController
@synthesize _tabBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    //self.title = @"Olive";
    [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:0]];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;

}




#pragma mark -
#pragma mark TableView Related
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

#define CELL_HEIGHT 80.0f
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

#define SidePadding 2.0f
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    FriendsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[FriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    }
    
    NSArray *titles = @[@"Black Panther", @"Iron Man", @"Spider Man", @"Wolverine", @"Cyclops", @"Captain America", @"Black Widow",@"Daredevil", @"Thor", @"Hulk"];
    
    if(indexPath.row < 3){
        cell.contentView.backgroundColor = OLIVE_DEFAULT_COLOR;
    }else{
        cell.contentView.backgroundColor = RGB(255,255,255);
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.img = [NSString stringWithFormat:@"%@.png",cell.textLabel.text];
//    cell.detailTextLabel.text = @"Category";
//    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    OliveViewController *viewContr = [[OliveViewController alloc] initWithUser:cell.textLabel.text];
    [self.navigationController pushViewController:viewContr animated:YES];
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



@end
