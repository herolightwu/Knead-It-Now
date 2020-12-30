//
//  EventModel.m
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "EventModel.h"

@implementation EventModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    EventModel *item = [[EventModel alloc] init];
    
    item.eventid = [self checkNil:[dicParams objectForKey:@"id"]];
    item.user_id = [self checkNil:[dicParams objectForKey:@"user_id"]];
    item.sender_photo = [self checkNil:[dicParams objectForKey:@"photo"]];
    item.content = [self checkNil:[dicParams objectForKey:@"content"]];
    item.book_id = [self checkNil:[dicParams objectForKey:@"book_id"]];
    item.book_status = [self checkNil:[dicParams objectForKey:@"book_status"]];
    item.type_id = [self checkNil:[dicParams objectForKey:@"type_id"]];
    item.isread = [self checkNil:[dicParams objectForKey:@"isread"]];
    item.event_time = [self checkNil:[dicParams objectForKey:@"event_time"]];
    item.sender_id = [self checkNil:[dicParams objectForKey:@"sender_id"]];
    
    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}

@end
