//
//  USearchVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/19.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USearchVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *mTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *mTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *mChooseLocBtn;
@property (weak, nonatomic) IBOutlet UIButton *mCurrentLocBtn;
@property (weak, nonatomic) IBOutlet UIButton *mHomeLocBtn;
@property (weak, nonatomic) IBOutlet UISlider *mSlider;
@property (weak, nonatomic) IBOutlet UIButton *mDurBtn1;
@property (weak, nonatomic) IBOutlet UIButton *mDurBtn2;
@property (weak, nonatomic) IBOutlet UIButton *mDurBtn3;
@property (weak, nonatomic) IBOutlet UIButton *mDurBtn4;
@property (weak, nonatomic) IBOutlet UIButton *mFemaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *mMaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *mEitherBtn;
@property (weak, nonatomic) IBOutlet UIButton *mSearchBtn;
@property (weak, nonatomic) IBOutlet UILabel *mRateLabel;

@property (weak, nonatomic) IBOutlet UIView *mSearchResultView;
@property (weak, nonatomic) IBOutlet UIButton *mRefineBtn;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *unreadNotiView;

@property (nonatomic, strong) NSMutableArray* searchdata;

- (IBAction)onProfile:(id)sender;
- (IBAction)onNotification:(id)sender;
- (IBAction)onChooseType:(id)sender;
- (IBAction)onChooseTime:(id)sender;
- (IBAction)onChooseLocation:(id)sender;
- (IBAction)onCurrentLocation:(id)sender;
- (IBAction)onHomeLocation:(id)sender;
- (IBAction)onSliderChanged:(id)sender;
- (IBAction)onFirstDuration:(id)sender;
- (IBAction)onSecondDuration:(id)sender;
- (IBAction)onThirdDuration:(id)sender;
- (IBAction)onForthDuration:(id)sender;
- (IBAction)onChooseFemale:(id)sender;
- (IBAction)onChooseMale:(id)sender;
- (IBAction)onChooseEither:(id)sender;
- (IBAction)onSearch:(id)sender;
- (IBAction)onRefine:(id)sender;

@end
