//
//  KeyboardButton.h
//  Olive-iOS
//
//  Created by 정의준 on 2015. 4. 12..
//  Copyright (c) 2015년 정의준. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KeyboardButton : NSManagedObject

@property (nonatomic, retain) NSNumber * key_type;
@property (nonatomic, retain) NSString * contents;
@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSNumber * col;
@property (nonatomic, retain) NSNumber * row;

@end
