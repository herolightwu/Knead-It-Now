//
//  UConfirmedVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/22.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface UConfirmedVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mTherapistImg;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mBusiness;
@property (weak, nonatomic) IBOutlet UILabel *mCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *mAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDuration;
@property (weak, nonatomic) IBOutlet UILabel *mMassageType;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *mAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *mCancelBtn;

@property (nonatomic, strong) BookModel* bookdata;
@property (nonatomic, strong) NSString* savedEventId;

- (IBAction)onBack:(id)sender;
- (IBAction)onAddCalendar:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onPhoneCall:(id)sender;

@end
