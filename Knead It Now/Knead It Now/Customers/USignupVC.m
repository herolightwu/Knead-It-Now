//
//  USignupVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/19.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "USignupVC.h"
#import "Common.h"
#import "Config.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import <OneSignal/OneSignal.h>

@interface USignupVC ()

@end

@implementation USignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mSignupBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSignup:(id)sender {
    //NSString *token = @"";
    if(![self checkValidField]) return;
    OSPermissionSubscriptionState* status = [OneSignal getPermissionSubscriptionState];
    NSString* userId = status.subscriptionStatus.userId;
    if(userId){
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [HttpApi signupToUser:self.mEmailTxt.text Password:self.mPasswordTxt.text Firstname:self.mFirstnameTxt.text Lastname:self.mLastnameTxt.text Phone:self.mPhoneTxt.text Token:userId Success:^(NSDictionary* result){
            [SVProgressHUD dismiss];
            g_user = [[UserModel alloc] initWithDictionary:result];
            [Common saveValueKey:@"user_email" Value:g_user.email];
            [Common saveValueKey:@"user_id" Value:g_user.userId];
            [Common saveValueKey:@"login_type" Value:@"1"];
            [Common saveValueKey:@"remember_login" Value:@"1"];
            [self gotoMainHome];
        } Fail:^(NSString* errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
    } else{
        [self showAlertDlg:@"Alert!" Msg:@"Can't get device id. Please try to login again with real phone."];
    }
    
    /*[SVProgressHUD showWithStatus:@"Please wait..."];
    [HttpApi signupToUser:self.mEmailTxt.text Password:self.mPasswordTxt.text Firstname:self.mFirstnameTxt.text Lastname:self.mLastnameTxt.text Phone:self.mPhoneTxt.text Token:token Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        g_user = [[UserModel alloc] initWithDictionary:result];
        [Common saveValueKey:@"user_email" Value:g_user.email];
        [Common saveValueKey:@"user_id" Value:g_user.userId];
        [Common saveValueKey:@"login_type" Value:@"1"];
        [Common saveValueKey:@"remember_login" Value:@"1"];
        [self gotoMainHome];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];*/
    
}

- (void)gotoMainHome{
    /*UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_UserNav"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];*/
    g_bLogin = true;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)checkValidField{
    if([self.mFirstnameTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type first name."];
        return false;
    }
    if([self.mLastnameTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type last name."];
        return false;
    }
    if([self.mEmailTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email address."];
        return false;
    }
    if(![Common IsValidEmail:self.mEmailTxt.text]){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email address correctly."];
        return false;
    }
    
    if([self.mPhoneTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type phone number."];
        return false;
    }
    if([self.mPasswordTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type password."];
        return false;
    }
    if(![self.mPasswordTxt.text isEqualToString:self.mConfirmTxt.text]){
        [self showAlertDlg:@"Warning!" Msg:@"Please type confirm password correctly."];
        return false;
    }
    
    return true;
}

- (void)showAlertDlg:(NSString*) title Msg:(NSString*)msg{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}
@end
