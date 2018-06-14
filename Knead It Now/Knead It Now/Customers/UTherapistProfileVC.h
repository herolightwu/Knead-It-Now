//
//  UTherapistProfileVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/20.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface UTherapistProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mTherapistImg;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mExperienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mBusinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCity;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UILabel *mParkingLabel;
@property (weak, nonatomic) IBOutlet UILabel *mReviewLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *mRequestView;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDistance;
@property (weak, nonatomic) IBOutlet UILabel *mReqType;
@property (weak, nonatomic) IBOutlet UILabel *mReqTime;
@property (weak, nonatomic) IBOutlet UIButton *mRequestBtn;
@property (weak, nonatomic) IBOutlet UILabel *mreqDur;

@property (nonatomic, strong) BookModel* bookdata;
@property (nonatomic, strong) NSMutableArray* therapist_reviews;

- (IBAction)onBack:(id)sender;
- (IBAction)onRequest:(id)sender;


@end
