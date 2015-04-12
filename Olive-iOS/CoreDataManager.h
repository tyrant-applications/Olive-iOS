//
//  CoreDataManager.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 15..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "Friends.h"
#import "Messages.h"
#import "Rooms.h"
#import "KeyboardButton.h"


@interface CoreDataManager : NSObject{
    NSManagedObjectContext *managedObjectContext;
}


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+(id)manager;
-(void)prepare;

-(Rooms *)getOrCreateRoomsObject:(NSInteger)room_id;
-(Friends *)getOrCreateFriendsObject:(NSString *)username;
-(Friends *)getFriendsObject:(NSString *)username;
-(Messages *)createMessagesObject;
-(BOOL)save;
-(void)deleteFriends:(Friends *)friend;

-(NSArray *)getAllFriends;
-(NSArray *)getAllRooms;
-(NSArray *)getAllMessagesInRoomID:(NSNumber *)room_id;
-(Messages *)getMessagesObjectID:(NSNumber *)messageID;
-(Messages *)getLastMessageInRoomID:(NSNumber *)room_id;

-(NSArray *)fetchAllObjectsInEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sort:(NSSortDescriptor *)sortDescriptor limit:(NSNumber *)limit;

-(NSDate *)getNSDateFromServerDate:(NSString *)date;
-(NSDate *)getNSDateFromServerDateForPostOlive:(NSString *)date;



-(void)installPrekeyboardButtons;
-(NSArray *)getAllKeyboardButtons;
-(NSArray *)getAllKeyboardButtonsInPage:(int)page;
@end
