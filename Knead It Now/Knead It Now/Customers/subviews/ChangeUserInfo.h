//
//  ChangeUserInfo.h
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@class ChangeUserInfo;

@protocol ChangeUserInfoDelegate <NSObject>

- (void)doneSaveWithChangeInfo:(ChangeUserInfo *)changeUserInfo;

@end

@interface ChangeUserInfo : UIView

@property (strong, nonatomic) CustomIOSAlertView *m_alertView;
@property (nonatomic, strong) id <ChangeUserInfoDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *mNewPhone;
@property (weak, nonatomic) IBOutlet UITextField *mNewEmail;


- (IBAction)onCloseClick:(id)sender;
- (IBAction)onUpdateClick:(id)sender;

-(void)setLayout;

@end
