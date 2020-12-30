//
//  CardModel.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardModel : NSObject
@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *expMonth;
@property (nonatomic, strong) NSString *expYear;
@property (nonatomic, strong) NSString *last4;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic) BOOL bDef;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end
