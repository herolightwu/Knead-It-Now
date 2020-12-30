//
//  ULoginVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/19.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GoogleSignIn;

@interface ULoginVC : UIViewController<GIDSignInDelegate, GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mEmailTxt;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTxt;
@property (weak, nonatomic) IBOutlet UIButton *mLoginBtn;
@property (weak, nonatomic) IBOutlet UIView *mFacebookView;
@property (weak, nonatomic) IBOutlet UIView *mGoogleView;
@property (weak, nonatomic) IBOutlet UIView *mSignupView;

- (IBAction)onLogin:(id)sender;
- (IBAction)onForgotPassword:(id)sender;
- (IBAction)onFacebookLogin:(id)sender;
- (IBAction)onGoolgeLogin:(id)sender;
- (IBAction)onSignup:(id)sender;

@end
