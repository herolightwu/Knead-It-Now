//
//  TSignupInfoVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/19.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface TSignupInfoVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mFirstNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mLastNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mBNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mBAddressTxt;
@property (weak, nonatomic) IBOutlet UITextField *mBCityTxt;
@property (weak, nonatomic) IBOutlet UITextField *mBStateTxt;
@property (weak, nonatomic) IBOutlet UITextField *mBZipTxt;
@property (weak, nonatomic) IBOutlet UITextField *mBPhoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *mLicenseTxt;
@property (weak, nonatomic) IBOutlet UITextField *mYearTxt;
@property (weak, nonatomic) IBOutlet UIView *mGenderView;
@property (weak, nonatomic) IBOutlet UIView *mParkingView;
@property (weak, nonatomic) IBOutlet UIButton *mGenderBtn;
@property (weak, nonatomic) IBOutlet UIButton *mParkingBtn;
@property (weak, nonatomic) IBOutlet UITextField *mDobTxt;

@property (strong, nonatomic) UserModel* user;
@property (strong, nonatomic) NSString* password;

- (IBAction)onBack:(id)sender;
- (IBAction)onNext:(id)sender;
- (IBAction)onGender:(id)sender;
- (IBAction)onParking:(id)sender;

@end
