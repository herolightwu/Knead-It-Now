//
//  BookModel.h
//  Knead It Now
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject
@property (nonatomic, strong) NSString *book_id;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *seller_name;
@property (nonatomic, strong) NSString *seller_photo;
@property (nonatomic, strong) NSString *seller_phone;
@property (nonatomic, strong) NSString *seller_rate;
@property (nonatomic, strong) NSString *bs_name;
@property (nonatomic, strong) NSString *bs_address;
@property (nonatomic, strong) NSString *bs_location;
@property (nonatomic, strong) NSString *start_date;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSString *auto_confirm;
@property (nonatomic, strong) NSString *seller_note;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *massage_type;
@property (nonatomic, strong) NSString *buyer_id;
@property (nonatomic, strong) NSString *buyer_name;
@property (nonatomic, strong) NSString *buyer_photo;
@property (nonatomic, strong) NSString *buyer_rate;
@property (nonatomic, strong) NSString *buyer_note;
@property (nonatomic, strong) NSString *book_time;
@property (nonatomic) float distance;
@property (nonatomic) float difftime;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end
