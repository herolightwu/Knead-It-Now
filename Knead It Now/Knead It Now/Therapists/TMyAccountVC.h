//
//  TMyAccountVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface TMyAccountVC : UIViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mContactBtn;
@property (weak, nonatomic) IBOutlet UIButton *mLogoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *mDeleteBtn;

- (IBAction)onBack:(id)sender;
- (IBAction)onChangePassword:(id)sender;
- (IBAction)onContactService:(id)sender;
- (IBAction)onLogOut:(id)sender;
- (IBAction)onDeleteAccount:(id)sender;

@end
