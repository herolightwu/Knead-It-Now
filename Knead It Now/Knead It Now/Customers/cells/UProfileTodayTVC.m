//
//  UProfileTodayTVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/22.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "UProfileTodayTVC.h"
#import "Config.h"

@implementation UProfileTodayTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *imageLayer = self.mUserImg.layer;
    [imageLayer setCornerRadius:20];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mDetailBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mAddBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mContentView.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
