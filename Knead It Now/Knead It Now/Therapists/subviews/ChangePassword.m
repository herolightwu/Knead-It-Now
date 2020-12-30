//
//  ChangePassword.m
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import "ChangePassword.h"
#import "Config.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"
#import "AppDelegate.h"

@interface ChangePassword()
{
    
}

@end

@implementation ChangePassword

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *imageLayer = self.mCurPass.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    imageLayer = self.mNewPass.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    imageLayer = self.mConfirmPass.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
}

- (void)setLayout
{
    //self.mUsername.text = self.data.userName;
    //self.mEmail.text = self.data.email;
    //self.mPhone.text = self.data.phone;
}

- (IBAction)onCloseClick:(id)sender {
    [self.m_alertView close];
}

- (IBAction)onUpdateClick:(id)sender {
    if(![self checkValidField]){
        return;
    }
    NSString *uemail = g_user.email;
    NSString *newpass = self.mNewPass.text;
    NSString *oldpass = self.mCurPass.text;
    [SVProgressHUD show];
    [HttpApi changePassword:uemail NewPass:newpass OldPass:oldpass Success:^(NSDictionary *result){
        [SVProgressHUD showSuccessWithStatus:(NSString*)result];
        [self doneSave];
    } Fail:^(NSString *errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (BOOL)checkValidField{
    if([self.mCurPass.text length] == 0){
        return false;
    }
    if([self.mNewPass.text length] == 0){
        return false;
    }
    if([self.mConfirmPass.text length] == 0){
        return false;
    }
    if(![self.mNewPass.text isEqualToString:self.mConfirmPass.text]){
        return false;
    }
    return true;
}

- (void)doneSave
{
    [self.delegate doneSaveWithChangePassword:self];
    [self.m_alertView close];
}

@end
