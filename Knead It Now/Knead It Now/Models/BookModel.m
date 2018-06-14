//
//  BookModel.m
//  Knead It Now
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    BookModel *item = [[BookModel alloc] init];
    
    item.book_id = [self checkNil:[dicParams objectForKey:@"id"]];
    item.seller_id = [self checkNil:[dicParams objectForKey:@"seller_id"]];
    item.seller_name = [self checkNil:[dicParams objectForKey:@"seller_name"]];
    item.seller_photo = [self checkNil:[dicParams objectForKey:@"seller_photo"]];
    item.seller_phone = [self checkNil:[dicParams objectForKey:@"seller_phone"]];
    item.seller_rate = [self checkNil:[dicParams objectForKey:@"seller_rate"]];
    item.bs_name = [self checkNil:[dicParams objectForKey:@"bs_name"]];
    item.bs_address = [self checkNil:[dicParams objectForKey:@"bs_address"]];
    item.bs_location = [self checkNil:[dicParams objectForKey:@"bs_location"]];
    item.seller_note = [self checkNil:[dicParams objectForKey:@"seller_note"]];
    item.start_date = [self checkNil:[dicParams objectForKey:@"start_date"]];
    item.start_time = [self checkNil:[dicParams objectForKey:@"start_time"]];
    item.duration = [self checkNil:[dicParams objectForKey:@"duration"]];
    item.cost = [self checkNil:[dicParams objectForKey:@"cost"]];
    item.auto_confirm = [self checkNil:[dicParams objectForKey:@"auto_confirm"]];
    item.status = [self checkNil:[dicParams objectForKey:@"status"]];
    item.massage_type = [self checkNil:[dicParams objectForKey:@"massage_type"]];
    item.buyer_id = [self checkNil:[dicParams objectForKey:@"buyer_id"]];
    item.buyer_name = [self checkNil:[dicParams objectForKey:@"buyer_name"]];
    item.buyer_photo = [self checkNil:[dicParams objectForKey:@"buyer_photo"]];
    item.buyer_rate = [self checkNil:[dicParams objectForKey:@"buyer_rate"]];
    item.buyer_note = [self checkNil:[dicParams objectForKey:@"buyer_note"]];
    item.book_time = [self checkNil:[dicParams objectForKey:@"book_time"]];
    item.distance = 0.0;
    item.difftime = 0.0;
    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}

@end
