//
//  CoreDataManager.m
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 15..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"

@implementation CoreDataManager
@synthesize managedObjectContext;

static CoreDataManager *sharedInstance = nil;

+(id)manager{
    if(sharedInstance == nil){
        sharedInstance = [[CoreDataManager alloc] init];
    }
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}


-(void)prepare{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
}

#pragma mark Creation Of Object
-(Rooms *)getOrCreateRoomsObject:(NSInteger)room_id{
    NSArray *fetchedObjects;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Rooms"  inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"room_id == %d",room_id]];
    NSError * error = nil;
    fetchedObjects = [managedObjectContext executeFetchRequest:fetch error:&error];
    
    if([fetchedObjects count] == 1)
        return [fetchedObjects objectAtIndex:0];
    else{
        Rooms *newRoom = (Rooms *)[NSEntityDescription insertNewObjectForEntityForName:@"Rooms" inManagedObjectContext:managedObjectContext];
        newRoom.room_id = [NSNumber numberWithInteger:room_id];
        return newRoom;
    }

}
-(Friends *)getOrCreateFriendsObject:(NSString *)username{
    NSArray *fetchedObjects;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Friends"  inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"username == %@",username]];
    NSError * error = nil;
    fetchedObjects = [managedObjectContext executeFetchRequest:fetch error:&error];
    
    if([fetchedObjects count] == 1)
        return [fetchedObjects objectAtIndex:0];
    else{
        Friends *newFriend = (Friends *)[NSEntityDescription insertNewObjectForEntityForName:@"Friends" inManagedObjectContext:managedObjectContext];
        newFriend.username = username;
        newFriend.update_date = [NSDate dateWithTimeIntervalSince1970:0];
        return newFriend;
    }
}

-(Friends *)getFriendsObject:(NSString *)username{
    NSArray *fetchedObjects;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Friends"  inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"username == %@",username]];
    NSError * error = nil;
    fetchedObjects = [managedObjectContext executeFetchRequest:fetch error:&error];
    
    if([fetchedObjects count] == 1)
        return [fetchedObjects objectAtIndex:0];
    else{
        return nil;
    }
}


-(Messages *)createMessagesObject{
    Messages *newMessage = (Messages *)[NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:managedObjectContext];
    return newMessage;

}


#pragma mark Save & Delete functions

-(BOOL)save{
    NSError *error = nil;
    if(![managedObjectContext save:&error]){
        //handle the error
        
        return NO;
    }
    return YES;
}

-(void)deleteFriends:(Friends *)friend{
    [managedObjectContext deleteObject:friend];
    [self save];
}

#pragma mark Fetch Request

-(NSArray *)getAllFriends{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"username" ascending:YES];
    return [self fetchAllObjectsInEntity:@"Friends" predicate:nil sort:sortDescriptor limit:nil];
}
-(NSArray *)getAllRooms{
    return [self fetchAllObjectsInEntity:@"Rooms" predicate:nil sort:nil  limit:nil];
}
-(NSArray *)getAllMessagesInRoomID:(NSNumber *)room_id{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"room_id == %d",[room_id integerValue]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"reg_date" ascending:YES];

    return [self fetchAllObjectsInEntity:@"Messages" predicate:predicate sort:sortDescriptor  limit:nil];
}
-(Messages *)getMessagesObjectID:(NSNumber *)messageID{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"message_id == %d",[messageID integerValue]];
    
    NSArray *result = [self fetchAllObjectsInEntity:@"Messages" predicate:predicate sort:nil  limit:nil];
    if(result != nil && [result count] >= 1){
        return [result firstObject];
    }

    return nil;
}
-(Messages *)getLastMessageInRoomID:(NSNumber *)room_id{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"room_id == %d",[room_id integerValue]];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"reg_date" ascending:NO];

    
    NSArray *result = [self fetchAllObjectsInEntity:@"Messages" predicate:predicate sort:sortDescriptor  limit:[NSNumber numberWithInt:1]];
    if(result != nil && [result count] == 1){
        return [result firstObject];
    }
    
    return nil;
}



-(NSArray *)fetchAllObjectsInEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sort:(NSSortDescriptor *)sortDescriptor limit:(NSNumber *)limit{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if(limit != nil)
        [request setFetchLimit:[limit integerValue]];
    
    if(predicate != nil)
        [request setPredicate:predicate];
    
    if(sortDescriptor != nil)
        [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if(mutableFetchResults == nil){
        //Handle the error
    }
    
    return mutableFetchResults;
}




-(NSDate *)getNSDateFromServerDate:(NSString *)dateStr{
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];

    return [fmt dateFromString:dateStr];
}


-(NSDate *)getNSDateFromServerDateForPostOlive:(NSString *)dateStr{
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss..SSSZ"];
    
    return [fmt dateFromString:dateStr];
}


-(void)installPrekeyboardButtons{
    NSArray *set1 = [NSArray arrayWithObjects:@"Eat?", @"Can We Meet?", @"Yes", @"Where?",
                     @"Coffee?", @"Can We Talk?", @"No", @"When?",
                     @"Pub", @"Wanna Do Something?", @"BUSY", @"With?",nil];
    NSArray *set2 = [NSArray arrayWithObjects:@"(Food?)", @"(Yes)", @"Where?", @"Make you own button.",
                     @"(Coffee?)", @"(No)", @"When?", @"Make you own button.",
                     @"(Drink?)", @"(Maybe)", @"(Busy)", @"Make you own button.",nil];
    NSArray *set3 = [NSArray arrayWithObjects:@"Happy Hour", @"Uris", @"(Mel's)", @"In class",
                     @"Rugby HH", @"Watson", @"(Pourhouse)", @"CBS Matters",
                     @"Afterparty", @"Warren", @"(Parlour)", @"Make your own button.",nil];
    NSArray *buttons = [NSArray arrayWithObjects:set1, set2, set3, nil];
    
    int key_cols = 4;
    int key_rows = 3;
    for(int page = 0; page < 3; page++){
        NSArray *c_page = [buttons objectAtIndex:page];
        for(int row = 0; row< key_rows; row++){
            for(int col = 0; col< key_cols; col++){
                //
                //KeyboardButton
                KeyboardButton *newBtn = (KeyboardButton *)[NSEntityDescription insertNewObjectForEntityForName:@"KeyboardButton" inManagedObjectContext:managedObjectContext];
                newBtn.key_type = [NSNumber numberWithInt:OLIVE_TEXT];
                newBtn.contents = [c_page objectAtIndex: key_cols*row+col];
                newBtn.page = [NSNumber numberWithInt:page];
                newBtn.row = [NSNumber numberWithInt:row];
                newBtn.col = [NSNumber numberWithInt:col];
                
            }
        }
    }
    [self save];
}
-(NSArray *)getAllKeyboardButtons{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KeyboardButton" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    [request setSortDescriptors:[NSArray arrayWithObjects:
                                 [NSSortDescriptor sortDescriptorWithKey:@"page" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"col" ascending:YES],
                                 nil]];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if(mutableFetchResults == nil){
        //Handle the error
    }
    return mutableFetchResults;
}

-(NSArray *)getAllKeyboardButtonsInPage:(int)page{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KeyboardButton" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"page == %d",page]];
    [request setSortDescriptors:[NSArray arrayWithObjects:
                                 [NSSortDescriptor sortDescriptorWithKey:@"page" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:@"col" ascending:YES],
                                 nil]];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if(mutableFetchResults == nil){
        //Handle the error
    }
    return mutableFetchResults;

}

@end
