//
//  USettingVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/22.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface USettingVC : UIViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UILabel *mPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *mEmailLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *mContactBtn;
@property (weak, nonatomic) IBOutlet UIButton *mLogoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *mDeleteBtn;

@property (nonatomic, strong) NSMutableArray* cardArray;

- (IBAction)onBack:(id)sender;
- (IBAction)onChooseAddress:(id)sender;
- (IBAction)onChangeInfo:(id)sender;
- (IBAction)onAddCard:(id)sender;
- (IBAction)onChangePassword:(id)sender;
- (IBAction)onContact:(id)sender;
- (IBAction)onLogout:(id)sender;
- (IBAction)onDeleteAccount:(id)sender;

@end
