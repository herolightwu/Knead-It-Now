//
//  ReviewModel.m
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "ReviewModel.h"

@implementation ReviewModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    ReviewModel *item = [[ReviewModel alloc] init];
    
    item.reviewid = [self checkNil:[dicParams objectForKey:@"id"]];
    item.firstName = [self checkNil:[dicParams objectForKey:@"first_name"]];
    item.lastName = [self checkNil:[dicParams objectForKey:@"last_name"]];
    item.rate = [self checkNil:[dicParams objectForKey:@"rate"]];
    item.comment = [self checkNil:[dicParams objectForKey:@"comment"]];
    item.postdate = [self checkNil:[dicParams objectForKey:@"postdate"]];
    
    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}

@end
