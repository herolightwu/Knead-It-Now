//
//  BusinessModel.m
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "BusinessModel.h"

@implementation BusinessModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    BusinessModel *item = [[BusinessModel alloc] init];
    
    item.businessId = [self checkNil:[dicParams objectForKey:@"id"]];
    item.bName = [self checkNil:[dicParams objectForKey:@"name"]];
    item.bAddress = [self checkNil:[dicParams objectForKey:@"address"]];
    item.zipcode = [self checkNil:[dicParams objectForKey:@"zipcode"]];
    item.bLicense = [self checkNil:[dicParams objectForKey:@"license_code"]];
    item.activeYear = [self checkNil:[dicParams objectForKey:@"active_year"]];
    item.parking = [self checkNil:[dicParams objectForKey:@"parking"]];
    item.bTypes = [self checkNil:[dicParams objectForKey:@"massage_types"]];
    
    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}

@end
