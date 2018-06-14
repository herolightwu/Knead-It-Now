//
//  BusinessModel.h
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessModel : NSObject
@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *bName;
@property (nonatomic, strong) NSString *bAddress;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *bLicense;
@property (nonatomic, strong) NSString *activeYear;
@property (nonatomic, strong) NSString *parking;
@property (nonatomic, strong) NSString *bTypes;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end
