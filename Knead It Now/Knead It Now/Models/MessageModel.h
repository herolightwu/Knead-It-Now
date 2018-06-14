//
//  MessageModel.h
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *sender_id;
@property (nonatomic, strong) NSString *receiver_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *send_time;
@property (nonatomic, strong) NSString *isread;
@property (nonatomic, strong) NSString *book_id;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end
