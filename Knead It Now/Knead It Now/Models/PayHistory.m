//
//  PayHistory.m
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "PayHistory.h"

@implementation PayHistory
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    PayHistory *item = [[PayHistory alloc] init];
    
    item.payId = [self checkNil:[dicParams objectForKey:@"id"]];
    item.price = [self checkNil:[dicParams objectForKey:@"price"]];
    item.card_name = [self checkNil:[dicParams objectForKey:@"card_name"]];
    item.book_date = [self checkNil:[dicParams objectForKey:@"book_date"]];
    item.book_time = [self checkNil:[dicParams objectForKey:@"book_time"]];
    item.duration = [self checkNil:[dicParams objectForKey:@"duration"]];
    item.massage_type = [self checkNil:[dicParams objectForKey:@"massage_type"]];
    
    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}

@end
