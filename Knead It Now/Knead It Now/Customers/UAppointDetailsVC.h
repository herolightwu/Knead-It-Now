//
//  UAppointDetailsVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface UAppointDetailsVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mTherapistImg;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mBusinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *mAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDuration;
@property (weak, nonatomic) IBOutlet UILabel *mMassageType;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *mCancelBtn;

@property (nonatomic, strong) BookModel* bookdata;

- (IBAction)onBack:(id)sender;
- (IBAction)onCancel:(id)sender;

@end
