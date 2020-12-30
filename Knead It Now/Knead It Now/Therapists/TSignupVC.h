//
//  TSignupVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSignupVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mUsernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mEmailTxt;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTxt;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmPassTxt;

- (IBAction)onBack:(id)sender;
- (IBAction)onNext:(id)sender;

@end
