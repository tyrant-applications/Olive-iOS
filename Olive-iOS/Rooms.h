//
//  Rooms.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 20..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Rooms : NSManagedObject

@property (nonatomic, retain) NSNumber * room_id;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * attendants_list;
@property (nonatomic, retain) NSString * last_msg;
@property (nonatomic, retain) NSString * creator;

@end
