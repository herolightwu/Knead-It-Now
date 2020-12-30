//
//  EventModel.h
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventModel : NSObject
@property (nonatomic, strong) NSString *eventid;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *sender_photo;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *book_id;
@property (nonatomic, strong) NSString *book_status;
@property (nonatomic, strong) NSString *type_id;
@property (nonatomic, strong) NSString *isread;
@property (nonatomic, strong) NSString *event_time;
@property (nonatomic, strong) NSString *sender_id;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end
