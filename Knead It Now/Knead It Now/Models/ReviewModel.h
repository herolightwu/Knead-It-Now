//
//  ReviewModel.h
//
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewModel : NSObject
@property (nonatomic, strong) NSString *reviewid;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *postdate;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end
