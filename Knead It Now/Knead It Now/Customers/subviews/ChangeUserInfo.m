//
//  ChangeUserInfo.m
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import "ChangeUserInfo.h"
#import "Config.h"
#import "Common.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"
#import "AppDelegate.h"

@interface ChangeUserInfo()
{
    
}

@end

@implementation ChangeUserInfo

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *imageLayer = self.mNewPhone.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    imageLayer = self.mNewEmail.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    [self setLayout];
}

- (void)setLayout
{
    self.mNewEmail.text = g_user.email;
    self.mNewPhone.text = g_user.phone;
}

- (IBAction)onCloseClick:(id)sender {
    [self.m_alertView close];
}

- (IBAction)onUpdateClick:(id)sender {
    if(![self checkValidField]){
        return;
    }
    NSString *uemail = self.mNewEmail.text;
    NSString *uphone = self.mNewPhone.text;
    [SVProgressHUD show];
    [HttpApi updateUserInfo:g_user.userId NewEmail:uemail NewPhone:uphone Success:^(NSDictionary* result){
        [SVProgressHUD showSuccessWithStatus:@"User Info was updated successfully."];
        g_user.email = uemail;
        g_user.phone = uphone;
        [self doneSave];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (BOOL)checkValidField{
    if([self.mNewPhone.text length] == 0){
        return false;
    }
    if([self.mNewEmail.text length] == 0){
        return false;
    }
    if(![Common IsValidEmail:self.mNewEmail.text]){
        return false;
    }
    if([self.mNewEmail.text isEqualToString:g_user.email] && [self.mNewPhone.text isEqualToString:g_user.phone]){
        return false;
    }
    
    return true;
}

- (void)doneSave
{
    [self.delegate doneSaveWithChangeInfo:self];
    [self.m_alertView close];
}

@end
