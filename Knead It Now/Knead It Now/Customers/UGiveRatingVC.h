//
//  UGiveRatingVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/22.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "BookModel.h"

@interface UGiveRatingVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mTherapistImg;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mBusiness;
@property (weak, nonatomic) IBOutlet EDStarRating *mRatingBar;
@property (weak, nonatomic) IBOutlet UIView *mPostView;
@property (weak, nonatomic) IBOutlet UITextField *mReviewTxt;
@property (weak, nonatomic) IBOutlet UIButton *mPostBtn;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDuration;
@property (weak, nonatomic) IBOutlet UILabel *mTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *mReportBtn;

@property (nonatomic) NSArray* colors;
@property (nonatomic, strong) NSString* bookid;
@property (nonatomic, strong) BookModel* bookdata;

- (IBAction)onBack:(id)sender;
- (IBAction)onPost:(id)sender;
- (IBAction)onReport:(id)sender;

@end
