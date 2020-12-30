//
//  MessageModel.m
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    MessageModel *item = [[MessageModel alloc] init];
    
    item.mid = [self checkNil:[dicParams objectForKey:@"id"]];
    item.sender_id = [self checkNil:[dicParams objectForKey:@"sender_id"]];
    item.receiver_id = [self checkNil:[dicParams objectForKey:@"receiver_id"]];
    item.content = [self checkNil:[dicParams objectForKey:@"content"]];
    item.book_id = [self checkNil:[dicParams objectForKey:@"book_id"]];
    item.send_time = [self checkNil:[dicParams objectForKey:@"send_time"]];
    item.isread = [self checkNil:[dicParams objectForKey:@"read_status"]];
    
    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}

@end
