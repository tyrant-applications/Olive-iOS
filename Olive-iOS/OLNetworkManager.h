//
//  OLNetworkManager.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 1. 27..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    OLIVE_TEXT = 0,
    OLIVE_IMAGE = 1,
    OLIVE_VIDEO = 2,
    OLIVE_AUDIO = 3,
    OLIVE_LOCATION = 4,
    OLIVE_EMOTICON = 5,
} OLIVE_TYPE;

#define CLIENT_ID @"2472266904a9452d7e30"
#define CLIENT_SECRET @"26e82a650178634867d59a54404913bcbc175265"
#define GRANT_TYPE @"password"

#define API_LOAD_USER_INFO API_URL(@"friends/profile")
#define API_CREATE_ACCOUNT API_URL(@"user/signup")
#define API_UPDATE_ACCOUNT API_URL(@"user/update")
#define API_ACCESS_TOKEN API_URL(@"access_token")

#define API_FIND_FRIENDS API_URL(@"friends/find")
#define API_LIST_FRIENDS API_URL(@"friends/list")
#define API_ADD_FRIENDS API_URL(@"friends/add")
#define API_ADD_FRIENDS_FINISHED @"API_ADD_FRIENDS"

#define API_LIST_ROOMS API_URL(@"rooms/list")
#define API_CREATE_ROOMS API_URL(@"rooms/create")

#define API_POST_OLIVE API_URL(@"message/post")
#define API_GET_NEW_OLIVE API_URL(@"message/new")
#define API_GET_NEW_OLIVE_FINISHED @"API_GET_NEW_OLIVE_FINISHED"
#define API_READ_OLIVE API_URL(@"message/read")



@interface OLNetworkManager : NSObject{
    NSMutableArray *unreadMessages;
}
@property (nonatomic, retain) NSMutableArray *unreadMessages;

+(id)manager;

-(void)saveToken:(NSString *)token;
-(NSString *)getToken;
-(void)removeToken;

-(void)removeUsername;
-(void)saveUsername:(NSString *)username;
-(NSString *)getUsername;

-(void)removePassword;
-(void)savePassword:(NSString *)password;
-(NSString *)getPassword;

-(void)removeUserProfile;
-(void)saveUserProfile:(NSDictionary *)profile;
-(NSString *)getProfile:(NSString *)key;


-(void)requestGetAPI:(NSString *)api;
-(void)requestPostAPI:(NSString *)api withParameters:(NSMutableDictionary *)params withToken:(BOOL)token;
-(void)requestPostAPI:(NSString *)api withParameters:(NSMutableDictionary *)params withToken:(BOOL)token withFormData:(NSData *)fileData;

-(void)postOlive:(OLIVE_TYPE)type inRoom:(NSNumber *)roomid  withInfo:(NSDictionary *)oliveInfo;

-(void)signout;


-(void)getNewMessages;

@end
