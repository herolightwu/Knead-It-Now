//
//  UserModel.m
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "UserModel.h"
#import "CardModel.h"
#import "Config.h"

@implementation UserModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    UserModel *item = [[UserModel alloc] init];
    
    item.userId = [self checkNil:[dicParams objectForKey:@"id"]];
    item.firstName = [self checkNil:[dicParams objectForKey:@"first_name"]];
    item.lastName = [self checkNil:[dicParams objectForKey:@"last_name"]];
    item.userName = [self checkNil:[dicParams objectForKey:@"username"]];
    item.email = [self checkNil:[dicParams objectForKey:@"email"]];
    item.phone = [self checkNil:[dicParams objectForKey:@"phone"]];
    item.gender = [self checkNil:[dicParams objectForKey:@"gender"]];
    item.birthday = [self checkNil:[dicParams objectForKey:@"birthday"]];
    item.photo = [self checkNil:[dicParams objectForKey:@"photo"]];
    item.type = [self checkNil:[dicParams objectForKey:@"type"]];
    item.homeAddr = [self checkNil:[dicParams objectForKey:@"address"]];
    item.homeLoc = [self checkNil:[dicParams objectForKey:@"location"]];
    item.rate = [self checkNil:[dicParams objectForKey:@"rate"]];
    item.rate_count = [self checkNil:[dicParams objectForKey:@"rate_count"]];
    item.account_id = [self checkNil:[dicParams objectForKey:@"stripe_id"]];
    item.ip_address = [self checkNil:[dicParams objectForKey:@"ip_address"]];
    
    if([item.type isEqualToString:USER_TYPE_THERAPIST]){
        item.businessInfo = [[BusinessModel alloc] initWithDictionary: [dicParams objectForKey:@"business_info"]];
    } else{
        item.businessInfo = nil;
    }
    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}

@end
