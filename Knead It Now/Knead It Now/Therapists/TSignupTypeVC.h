//
//  TSignupTypeVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"
#import "UserModel.h"

@interface TSignupTypeVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mDeepView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mDeepCheck;
@property (weak, nonatomic) IBOutlet UIView *mSwedView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mSwedCheck;
@property (weak, nonatomic) IBOutlet UIView *mPreView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mPreCheck;
@property (weak, nonatomic) IBOutlet UIView *mLympView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mLympCheck;
@property (weak, nonatomic) IBOutlet UIView *mCranView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCranCheck;
@property (weak, nonatomic) IBOutlet UIView *mReflView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mReflCheck;
@property (weak, nonatomic) IBOutlet UIView *mSportView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mSportCheck;
@property (weak, nonatomic) IBOutlet UIView *mAromView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mAromCheck;
@property (weak, nonatomic) IBOutlet UIView *mAcupView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mAcupCheck;
@property (weak, nonatomic) IBOutlet UIView *mMyofView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mMyofCheck;
@property (weak, nonatomic) IBOutlet UIView *mReikiView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mReikiCheck;
@property (weak, nonatomic) IBOutlet UIView *mShiaView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mShiaCheck;
@property (weak, nonatomic) IBOutlet UIView *mTrigView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mTrigCheck;

@property (strong, nonatomic) UserModel* user;
@property (strong, nonatomic) NSString* password;

- (IBAction)onBack:(id)sender;
- (IBAction)onNext:(id)sender;
- (IBAction)onDeepClick:(id)sender;
- (IBAction)onSwedClick:(id)sender;
- (IBAction)onPreClick:(id)sender;
- (IBAction)onLympClick:(id)sender;
- (IBAction)onCranClick:(id)sender;
- (IBAction)onReflClick:(id)sender;
- (IBAction)onSportClick:(id)sender;
- (IBAction)onAromClick:(id)sender;
- (IBAction)onAcupClick:(id)sender;
- (IBAction)onMyofClick:(id)sender;
- (IBAction)onReikiClick:(id)sender;
- (IBAction)onShiaClick:(id)sender;
- (IBAction)onTrigClick:(id)sender;

@end
