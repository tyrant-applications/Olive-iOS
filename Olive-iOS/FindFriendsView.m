//
//  FindFriendsView.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 2..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "FindFriendsView.h"

@implementation FindFriendsView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = OLIVE_DEFAULT_COLOR;
        
        
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width - 20.0f, 20)];
        searchLabel.text = @"Search Friends...";
        searchLabel.font = [UIFont systemFontOfSize:14.0f];
        searchLabel.textColor = [UIColor whiteColor];
        [self addSubview:searchLabel];
        
        CALayer *border = [CALayer layer];
        border.frame = CGRectMake(10, 45, self.frame.size.width - 20.0f, 40);
        border.borderColor = [UIColor whiteColor].CGColor;
        border.borderWidth = 2.0f;
        border.cornerRadius = 5.0f;
        [self.layer addSublayer:border];
        
        UITextField *searchFields = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, self.frame.size.width - 40.0f, 30)];
        searchFields.delegate = self;;
        searchFields.borderStyle = UITextBorderStyleNone;
        searchFields.tintColor = [UIColor whiteColor];
        searchFields.textColor = [UIColor whiteColor];
        searchFields.font = [UIFont systemFontOfSize:14.0f];
        searchFields.placeholder = @"Enter ID or Phone number...";
        [self addSubview:searchFields];
        

        UILabel *searchLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.frame.size.width - 20.0f, 20)];
        searchLabel2.text = @"Search From Phone Book...";
        searchLabel2.font = [UIFont systemFontOfSize:14.0f];
        searchLabel2.textColor = [UIColor whiteColor];
        [self addSubview:searchLabel2];

        UIButton *searchLabel2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchLabel2Btn.frame = CGRectMake(10, 125, self.frame.size.width - 20.0f, 40.0f);
        [searchLabel2Btn setTitle:@"Add From Contacts" forState:UIControlStateNormal];
        searchLabel2Btn.layer.borderColor = [UIColor whiteColor].CGColor;
        searchLabel2Btn.layer.borderWidth = 2.0f;
        searchLabel2Btn.layer.cornerRadius = 5.0f;
        searchLabel2Btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [searchLabel2Btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:searchLabel2Btn];
        
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, searchLabel2Btn.frame.origin.y +searchLabel2Btn.frame.size.height + 15.0f, self.frame.size.width - 20.0f, self.frame.size.height - 60.0f - searchLabel2Btn.frame.origin.y - searchLabel2Btn.frame.size.height - 30.0f)];
        tableView.layer.cornerRadius = 5.0f;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(10, self.frame.size.height - 60.0f, self.frame.size.width - 20.0f, 40.0f);
        [addBtn setTitle:@"Add Friends" forState:UIControlStateNormal];
        addBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [addBtn setBackgroundColor:[UIColor whiteColor]];
        addBtn.layer.borderWidth = 2.0f;
        addBtn.layer.cornerRadius = 5.0f;
        [addBtn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [addBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:addBtn];

        
     }
    return self;
}
- (void) buttonPressed:(id) sender{
    NSLog(@"1");
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
}


#pragma mark -
#pragma mark TableView Related
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

#define SidePadding 2.0f
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    }
        cell.textLabel.text = [NSString stringWithFormat:@"%i",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
