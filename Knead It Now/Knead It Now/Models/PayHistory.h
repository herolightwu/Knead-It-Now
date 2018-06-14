//
//  PayHistory.h
//  Kneaditnow
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayHistory : NSObject
@property (nonatomic, strong) NSString *payId;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *card_name;
@property (nonatomic, strong) NSString *book_date;
@property (nonatomic, strong) NSString *book_time;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *massage_type;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end
