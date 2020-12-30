//
//  TGiveRatingVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/18.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "BookModel.h"

@interface TGiveRatingVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mUserImg;
@property (weak, nonatomic) IBOutlet UILabel *mUsername;
@property (weak, nonatomic) IBOutlet UILabel *mRatingLabel;
@property (weak, nonatomic) IBOutlet EDStarRating *mRatingBar;
@property (weak, nonatomic) IBOutlet UITextField *mReviewTxt;
@property (weak, nonatomic) IBOutlet UIButton *mPostBtn;
@property (weak, nonatomic) IBOutlet UILabel *mAppointTime;
@property (weak, nonatomic) IBOutlet UILabel *mTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDuration;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *mReportBtn;
@property (weak, nonatomic) IBOutlet UIView *mEditView;

@property (nonatomic) NSArray* colors;
@property (nonatomic, strong) NSString* bookid;
@property (nonatomic, strong) BookModel* bookdata;

- (IBAction)onBack:(id)sender;
- (IBAction)onPost:(id)sender;
- (IBAction)onReport:(id)sender;

@end
