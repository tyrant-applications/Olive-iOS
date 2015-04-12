//
//  Messages.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 22..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Messages : NSManagedObject

@property (nonatomic, retain) NSNumber * room_id;
@property (nonatomic, retain) NSDate * reg_date;
@property (nonatomic, retain) NSNumber * msg_type;
@property (nonatomic, retain) NSNumber * message_id;
@property (nonatomic, retain) NSString * contents;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * attached_file;

@end
