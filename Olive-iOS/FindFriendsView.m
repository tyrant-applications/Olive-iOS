//
//  FindFriendsView.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 2..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>


#import "FindFriendsView.h"
#import "OLNetworkManager.h"
#import "FriendsTableViewCell.h"

@implementation FindFriendsView
@synthesize items;
@synthesize selectedItems;
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.items = [[NSMutableArray alloc] init];
        self.selectedItems = [[NSMutableArray alloc] init];
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
        searchLabel2.text = @"Search From Contacts...";
        searchLabel2.font = [UIFont systemFontOfSize:14.0f];
        searchLabel2.textColor = [UIColor whiteColor];
        [self addSubview:searchLabel2];

        UIButton *searchLabel2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchLabel2Btn.frame = CGRectMake(10, 125, self.frame.size.width - 20.0f, 40.0f);
        [searchLabel2Btn setTitle:@"Search From Contacts" forState:UIControlStateNormal];
        searchLabel2Btn.layer.borderColor = [UIColor whiteColor].CGColor;
        searchLabel2Btn.layer.borderWidth = 2.0f;
        searchLabel2Btn.layer.cornerRadius = 5.0f;
        searchLabel2Btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        searchLabel2Btn.layer.masksToBounds = YES;
        [searchLabel2Btn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [searchLabel2Btn setBackgroundImage:[ViewSettings imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [searchLabel2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [searchLabel2Btn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateHighlighted];

        [searchLabel2Btn addTarget:self action:@selector(contactButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchLabel2Btn];
        
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, searchLabel2Btn.frame.origin.y +searchLabel2Btn.frame.size.height + 15.0f, self.frame.size.width - 20.0f, self.frame.size.height - 60.0f - searchLabel2Btn.frame.origin.y - searchLabel2Btn.frame.size.height - 30.0f)];
        _tableView.layer.cornerRadius = 5.0f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(10, self.frame.size.height - 60.0f, self.frame.size.width - 20.0f, 40.0f);
        [addBtn setTitle:@"Add Friends" forState:UIControlStateNormal];
        addBtn.layer.borderColor = [UIColor whiteColor].CGColor;

        addBtn.layer.borderWidth = 2.0f;
        addBtn.layer.cornerRadius = 5.0f;
        addBtn.layer.masksToBounds = YES;
        [addBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [addBtn setBackgroundImage:[ViewSettings imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn setTitleColor:OLIVE_DEFAULT_COLOR forState:UIControlStateHighlighted];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [addBtn addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:addBtn];
        
     }
    return self;
}
- (void) addButtonPressed:(id) sender{

    NSMutableString *friends = [[NSMutableString alloc] init];
    
    for(NSDictionary *friend in selectedItems){
        if([[friend objectForKey:@"username"] isEqualToString:[[OLNetworkManager manager] getUsername]]) continue;
        [friends appendString:[NSString stringWithFormat:@"%@,",[friend objectForKey:@"username"]]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFriendsFinished:) name:API_ADD_FRIENDS object:nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:friends forKey:@"friends_id"];
    [[OLNetworkManager manager] requestPostAPI:API_ADD_FRIENDS withParameters:dict withToken:YES];
//    NSLog(@"%@",dict);
}


-(void)addFriendsFinished:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_ADD_FRIENDS object:nil];
//    NSLog(@"%@",noti);
    if(noti.object == nil){
        NSLog(@"Something wrong...");
        return;
    }
    if([[noti.object objectForKey:@"success"] integerValue] == 1){
        NSArray *data = [noti.object objectForKey:@"data"];
        
        for(NSDictionary *friendInfo in data){
            NSDate* dateFromString = [[CoreDataManager manager] getNSDateFromServerDate:[friendInfo objectForKey:@"update_date"]];
            
            Friends *friend = [[CoreDataManager manager] getOrCreateFriendsObject:[friendInfo objectForKey:@"username"]];
            
            if([friend.update_date compare:dateFromString] == NSOrderedAscending){
                //Do Update
                if([friendInfo objectForKey:@"phone"] != nil && [[friendInfo objectForKey:@"phone"] isKindOfClass:[NSString class]])
                    friend.phone = [friendInfo objectForKey:@"phone"];
                friend.picture = [friendInfo objectForKey:@"picture"];
                friend.update_date = dateFromString;
            }
            
        }

        [[[UIAlertView alloc] initWithTitle:nil message:@"Friends Add Complete" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

        [selectedItems removeAllObjects];
        [_tableView reloadData];
        //if([data count] == 1)
        //   [[OLNetworkManager manager] saveUserProfile:[data objectAtIndex:0]];
    }else{
    
    }
}


- (void)contactButtonPressed:(id) sender{
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self loadContactsInfo];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self loadContactsInfo];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }

}

-(void)loadContactsInfo{
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    
    NSMutableString *emails = [[NSMutableString alloc] init];
    NSMutableString *contacts = [[NSMutableString alloc] init];
    
    
    for ( int i = 0; i < nPeople; i++ )
    {
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        //kABPersonEmailProperty
        ABMultiValueRef emailsRef = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (int i=0; i<ABMultiValueGetCount(emailsRef); i++) {
            NSString *email = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(emailsRef, i);
            [emails appendString:[NSString stringWithFormat:@"%@,",email]];
        }
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            [contacts appendString:[NSString stringWithFormat:@"%@,",phoneNumber]];
        }
    }
    

    [self findFriendsEmails:emails withContacts:contacts];
}

-(void)findFriendsEmails:(NSString *)emails withContacts:(NSString *)contacts{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedFriendsList:) name:API_FIND_FRIENDS object:nil];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(emails != nil)
        [dict setObject:emails forKey:@"emails"];
    if(contacts != nil)
        [dict setObject:contacts forKey:@"contacts"];
    [[OLNetworkManager manager] requestPostAPI:API_FIND_FRIENDS withParameters:dict withToken:NO];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self findFriendsEmails:textField.text withContacts:textField.text];
}



-(void)loadedFriendsList:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:API_FIND_FRIENDS];

    NSDictionary *result = (NSDictionary *)noti.object;
    
    [selectedItems removeAllObjects];
    [items removeAllObjects];
    [items addObjectsFromArray:[[result objectForKey:@"data"] objectForKey:@"emails"]];
    [items addObjectsFromArray:[[result objectForKey:@"data"] objectForKey:@"contacts"]];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark TableView Related
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.items count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

#define SidePadding 2.0f
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    FindFriendsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[FindFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    }

    NSDictionary *item = [items objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"username"];
    cell.img = [item objectForKey:@"picture"];
    
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if([[CoreDataManager manager] getFriendsObject:[item objectForKey:@"username"]] != nil){
        UIImageView *friendImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friends.png"]];
        friendImg.frame = CGRectMake(0, 0, 30, 30);
        cell.accessoryView = friendImg;
        cell.userInteractionEnabled = NO;
    }else{
        cell.userInteractionEnabled = YES;
        if([selectedItems containsObject:[items objectAtIndex:indexPath.row]]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(![selectedItems containsObject:[items objectAtIndex:indexPath.row]]){
        [selectedItems addObject:[items objectAtIndex:indexPath.row]];
    }else{
        [selectedItems removeObject:[items objectAtIndex:indexPath.row]];
    }
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
    
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
