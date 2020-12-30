//
//  UProfileTodayTVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/22.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UProfileTodayTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mUserImg;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mBusiness;
@property (weak, nonatomic) IBOutlet UILabel *mRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDistance;
@property (weak, nonatomic) IBOutlet UILabel *mMassageType;
@property (weak, nonatomic) IBOutlet UILabel *mStartTime;
@property (weak, nonatomic) IBOutlet UILabel *mDuration;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *mDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *mAddBtn;
@property (weak, nonatomic) IBOutlet UIView *mContentView;


@end
