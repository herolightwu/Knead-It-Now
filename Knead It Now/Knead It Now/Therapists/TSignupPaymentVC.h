//
//  TSignupPaymentVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface TSignupPaymentVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mCardNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mCardNumberTxt;
@property (weak, nonatomic) IBOutlet UITextField *mExpireTxt;
@property (weak, nonatomic) IBOutlet UITextField *mCvvTxt;

@property (strong, nonatomic) UserModel* user;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSString* card_token;

- (IBAction)onBack:(id)sender;
- (IBAction)onFinish:(id)sender;

@end
