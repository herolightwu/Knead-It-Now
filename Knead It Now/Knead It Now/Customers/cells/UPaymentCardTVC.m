//
//  UPaymentCardTVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "UPaymentCardTVC.h"
#import "Config.h"

@implementation UPaymentCardTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCheckView addSubview:self.mCheck];
    self.mCheck.on = NO;
    //self.mCheckBox.onFillColor = YELLOW_COLOR;
    self.mCheck.onTintColor = WHITE_COLOR;
    self.mCheck.tintColor = WHITE_COLOR;
    self.mCheck.onCheckColor = PRIMARY_COLOR;
    //UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check0:)];
    //[self.mCheckBox0 addGestureRecognizer:singleFingerTap];
    self.mCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mCheck.boxType = BEMBoxTypeSquare;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
