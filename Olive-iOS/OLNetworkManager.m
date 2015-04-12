//
//  OLNetworkManager.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 1. 27..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "OLNetworkManager.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@implementation OLNetworkManager
@synthesize unreadMessages;

static OLNetworkManager *sharedInstance = nil;

+(id)manager{
    if(sharedInstance == nil){
        sharedInstance = [[OLNetworkManager alloc] init];
    }
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if(self){
        self.unreadMessages = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)removeToken{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"ACCESS_TOKEN"];
    [prefs synchronize];
    
}
-(void)saveToken:(NSString *)token{
    NSString *oldToken = [self getToken];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:token forKey:@"ACCESS_TOKEN"];
    [prefs synchronize];
    NSLog(@"Token Saved: %@ (Old: %@)", [self getToken],oldToken);
}

-(NSString *)getToken{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs stringForKey:@"ACCESS_TOKEN"];
}


-(void)removeUsername{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"USERNAME"];
    [prefs synchronize];
    
}
-(void)saveUsername:(NSString *)username{
    NSString *oldToken = [self getUsername];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:username forKey:@"USERNAME"];
    [prefs synchronize];
    NSLog(@"Username Saved: %@ (Old: %@)", [self getUsername],oldToken);
}

-(NSString *)getUsername{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs stringForKey:@"USERNAME"];
}


-(void)removePassword{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"PASSWORD"];
    [prefs synchronize];
    
}
-(void)savePassword:(NSString *)password{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:password forKey:@"PASSWORD"];
    [prefs synchronize];
}

-(NSString *)getPassword{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs stringForKey:@"PASSWORD"];
}

-(void)removeUserProfile{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"USERPROFILE"];
    [prefs synchronize];
}
-(void)saveUserProfile:(NSDictionary *)profile{
    //NSLog(@"SAVE %@",profile);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:profile];
    if([dict objectForKey:@"phone"] == nil || [[dict objectForKey:@"phone"] isKindOfClass:[NSNull class]]){
        [dict removeObjectForKey:@"phone"];
    }

    [prefs setObject:dict forKey:@"USERPROFILE"];
    [prefs synchronize];
    
    [self getProfile:@"123"];

}
-(NSString *)getProfile:(NSString *)key{
    NSMutableDictionary *userInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"USERPROFILE"] mutableCopy];
    for (NSString * aKey in [userInfo allKeys]) {
        if([aKey isEqualToString:key]){
            return [userInfo objectForKey:aKey];
        }
    }

    return nil;

}



-(void)requestGetAPI:(NSString *)api{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:api parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)requestPostAPI:(NSString *)api withParameters:(NSMutableDictionary *)params withToken:(BOOL)token{
   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (token){
        [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Authorization"];
    }
    [manager POST:api parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:api object:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:api object:nil];

        NSLog(@"Error: %@", error);
    }];
}

-(void)requestPostAPI:(NSString *)api withParameters:(NSMutableDictionary *)params withToken:(BOOL)token withFormData:(NSData *)fileData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (token){
        [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Authorization"];
    }
    [manager POST:api parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:@"new_picture" fileName:@"photo.jpg" mimeType:@"image/jpeg"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",api);
        [[NSNotificationCenter defaultCenter] postNotificationName:api object:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:api object:nil];
        
        NSLog(@"Error: %@", error);
    }];
}



-(void)postOlive:(OLIVE_TYPE)type inRoom:(NSNumber *)roomid  withInfo:(NSDictionary *)oliveInfo{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%d",type] forKey:@"msg_type"];
    [params setObject:[NSString stringWithFormat:@"%d",[roomid intValue]] forKey:@"room_id"];
    
    if(type == OLIVE_TEXT || type == OLIVE_LOCATION){
        [params setObject:[oliveInfo objectForKey:@"contents"] forKey:@"contents"];
        [self requestPostAPI:API_POST_OLIVE withParameters:params withToken:YES];

    }else if(type == OLIVE_IMAGE){
        [self requestPostAPI:API_POST_OLIVE withParameters:params withToken:YES withFormData:[oliveInfo objectForKey:@"img"]];

    }else{
        NSLog(@"Unsupported Type");
        return;
    }
    
}



-(void)signout{
    [self removeToken];
    [self removeUsername];
    [self removePassword];
    [self removeUserProfile];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate flushDatabase];
    [delegate goToSignin];

}


-(void)getNewMessages{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewMessageFinished:) name:API_GET_NEW_OLIVE object:nil];
    if([self getToken] != nil){
        [self requestPostAPI:API_GET_NEW_OLIVE withParameters:nil withToken:YES];    
    }
}

-(void)getNewMessageFinished:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:API_GET_NEW_OLIVE object:nil];
    
    //NSLog(@"%@",noti);
    
    if([noti.object isKindOfClass:[NSDictionary class]]){
        NSArray *data = [noti.object objectForKey:@"data"];
        
        [self.unreadMessages removeAllObjects];
        //        NSLog(@"Unread Count :%d", data.count);
        for(NSDictionary *messageInfo in data){
            Messages *message  = nil;
            if([[CoreDataManager manager] getMessagesObjectID:[messageInfo objectForKey:@"message_id"]]){
                message = [[CoreDataManager manager] getMessagesObjectID:[messageInfo objectForKey:@"message_id"]];
            }else{
                message = [[CoreDataManager manager] createMessagesObject];
                message.author = [messageInfo objectForKey:@"author"];
                message.contents = [messageInfo objectForKey:@"contents"];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                message.msg_type = [f numberFromString:[messageInfo objectForKey:@"msg_type"]];
                message.message_id = [messageInfo objectForKey:@"message_id"];
                
                message.reg_date = [[CoreDataManager manager] getNSDateFromServerDate:[messageInfo objectForKey:@"reg_date"]];
                message.room_id = [messageInfo objectForKey:@"room_id"];
                
                [[CoreDataManager manager] save];
                NSLog(@"%@",[[CoreDataManager manager] getAllMessagesInRoomID:message.room_id]);
                
            }
            
            [self.unreadMessages addObject:message];
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:API_GET_NEW_OLIVE_FINISHED object:nil];
    [self performSelector:@selector(getNewMessages) withObject:nil afterDelay:1.0f];
}

@end
