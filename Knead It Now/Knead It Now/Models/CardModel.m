//
//  CardModel.m
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "CardModel.h"

@implementation CardModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    CardModel *item = [[CardModel alloc] init];
    
    item.cardId = [self checkNil:[dicParams objectForKey:@"id"]];
    item.name = [self checkNil:[dicParams objectForKey:@"name"]];
    item.expMonth = [self checkNil:[dicParams objectForKey:@"exp_month"]];
    item.expYear = [self checkNil:[dicParams objectForKey:@"exp_year"]];
    item.last4 = [self checkNil:[dicParams objectForKey:@"last4"]];
    item.brand = [self checkNil:[dicParams objectForKey:@"brand"]];
    item.bDef = [[dicParams objectForKey:@"default_for_currency"] boolValue];
    
    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}

@end
