//
//  TLoginVC.h
//  Book Me Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TLoginVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mEmailTxt;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTxt;
@property (weak, nonatomic) IBOutlet UIButton *mLoginBtn;


- (IBAction)onForgotPassword:(id)sender;
- (IBAction)onLoginClick:(id)sender;
- (IBAction)onGoToSignup:(id)sender;

@end
