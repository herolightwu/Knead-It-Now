//
//  UResultCell.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/20.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mTherapistImg;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mBussinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDistance;
@property (weak, nonatomic) IBOutlet UILabel *mMassageType;
@property (weak, nonatomic) IBOutlet UILabel *mStartTime;
@property (weak, nonatomic) IBOutlet UILabel *mDuration;
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property (weak, nonatomic) IBOutlet UIButton *mProfileBtn;
@property (weak, nonatomic) IBOutlet UIButton *mRequestBtn;

@end
