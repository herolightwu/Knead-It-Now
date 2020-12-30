//
//  TAppointmentDetailVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/17.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface TAppointmentDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mUserImg;
@property (weak, nonatomic) IBOutlet UILabel *mUsername;
@property (weak, nonatomic) IBOutlet UILabel *mRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *mAppointTime;
@property (weak, nonatomic) IBOutlet UILabel *mDuration;
@property (weak, nonatomic) IBOutlet UILabel *mMassageType;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *mAddBtn;

@property (nonatomic, strong) NSString* bookid;
@property (nonatomic, strong) BookModel *bookdata;
@property (nonatomic, strong) NSString* savedEventId;

- (IBAction)onBack:(id)sender;
- (IBAction)onMessage:(id)sender;
- (IBAction)onAddToCalendar:(id)sender;
- (IBAction)onUserClick:(id)sender;

@end
