//
//  TLoginVC.m
//  Book Me Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TLoginVC.h"
#import "Config.h"
#import "ForgotVC.h"
#import "Common.h"
#import "TSignupVC.h"
#import "HttpApi.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import <OneSignal/OneSignal.h>


@interface TLoginVC ()
{
    NSString *token;
}
@end

@implementation TLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mLoginBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onForgotPassword:(id)sender {
    ForgotVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ForgotVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onLoginClick:(id)sender {
    if(![self checkValidField]) return;
    
    OSPermissionSubscriptionState* status = [OneSignal getPermissionSubscriptionState];
    NSString* userId = status.subscriptionStatus.userId;
    if(userId){
        //[Common saveValueKey:@"token" Value:userId];
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [HttpApi loginWithEmail:self.mEmailTxt.text Password:self.mPasswordTxt.text Token:userId Success:^(NSDictionary* data){
            [SVProgressHUD dismiss];
            UserModel* one = [[UserModel alloc] initWithDictionary:data];
            if([one.type isEqualToString:USER_TYPE_THERAPIST]){
                g_user = one;
                [Common saveValueKey:@"user_email" Value:one.email];
                [Common saveValueKey:@"user_id" Value:one.userId];
                [Common saveValueKey:@"login_type" Value:@"1"];
                [Common saveValueKey:@"remember_login" Value:@"1"];
                [self gotoMainScreen];
            } else{
                [self showAlertDlg:@"Warning!" Msg:@"You can't login with this email address as therapist."];
            }
            
        } Fail:^(NSString* error){
            [SVProgressHUD showErrorWithStatus:error];
        }];
    } else{
        [self showAlertDlg:@"Alert!" Msg:@"Can't get device id. Please try to login again with real phone."];
    }
    
    /*token = @"";
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [HttpApi loginWithEmail:self.mEmailTxt.text Password:self.mPasswordTxt.text Token:token Success:^(NSDictionary* data){
        [SVProgressHUD dismiss];
        UserModel* one = [[UserModel alloc] initWithDictionary:data];
        if([one.type isEqualToString:USER_TYPE_THERAPIST]){
            g_user = one;
            [Common saveValueKey:@"user_email" Value:one.email];
            [Common saveValueKey:@"user_id" Value:one.userId];
            [Common saveValueKey:@"login_type" Value:@"1"];
            [Common saveValueKey:@"remember_login" Value:@"1"];
            [self gotoMainScreen];
        } else{
            [self showAlertDlg:@"Warning!" Msg:@"You can't login with this email address as therapist."];
        }
        
    } Fail:^(NSString* error){
        [SVProgressHUD showErrorWithStatus:error];
    }];*/
}

- (IBAction)onGoToSignup:(id)sender {
    TSignupVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TSignupVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoMainScreen{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_TherapistNav"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (BOOL)checkValidField{
    if([self.mEmailTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email address."];
        return false;
    }
    
    if(![Common IsValidEmail:self.mEmailTxt.text]){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email address correctly."];
        return false;
    }
    
    if([self.mPasswordTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type password."];
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
