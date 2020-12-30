//
//  ChangePassword.h
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@class ChangePassword;

@protocol ChangePasswordDelegate <NSObject>

- (void)doneSaveWithChangePassword:(ChangePassword *)changePassword;

@end

@interface ChangePassword : UIView

@property (strong, nonatomic) CustomIOSAlertView *m_alertView;
@property (nonatomic, strong) id <ChangePasswordDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *mCurPass;
@property (weak, nonatomic) IBOutlet UITextField *mNewPass;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmPass;


- (IBAction)onCloseClick:(id)sender;
- (IBAction)onUpdateClick:(id)sender;

-(void)setLayout;

@end
