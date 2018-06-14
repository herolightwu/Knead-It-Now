//
//  USignupVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/19.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USignupVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mFirstnameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mLastnameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mEmailTxt;
@property (weak, nonatomic) IBOutlet UITextField *mPhoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTxt;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmTxt;
@property (weak, nonatomic) IBOutlet UIButton *mSignupBtn;

- (IBAction)onBack:(id)sender;
- (IBAction)onSignup:(id)sender;

@end
