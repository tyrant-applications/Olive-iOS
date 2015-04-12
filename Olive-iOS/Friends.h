//
//  Friends.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 3. 15..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friends : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSDate * update_date;
@property (nonatomic, retain) NSString * picture;

@end
