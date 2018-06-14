//
//  UserModel.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessModel.h"

@interface UserModel : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *homeAddr;
@property (nonatomic, strong) NSString *homeLoc;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *rate_count;
@property (nonatomic, strong) NSString *account_id;
@property (nonatomic, strong) NSString *ip_address;
@property (nonatomic, strong) BusinessModel *businessInfo;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end
