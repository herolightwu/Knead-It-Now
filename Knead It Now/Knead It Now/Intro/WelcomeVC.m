//
//  WelcomeVC.m
//  Book Me Now
//
//  Created by meixiang wu on 2018/6/13.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "WelcomeVC.h"
#import "Config.h"
#import "AppDelegate.h"
#import "TLoginVC.h"
#import "ULoginVC.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "HttpApi.h"
#import "UserModel.h"
#import <OneSignal/OneSignal.h>

@interface WelcomeVC (){
    NSString* token;
}

@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mTherapistView.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mUserView.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    token = @"";
    if([[Common getValueKey:@"remember_login"] isEqualToString:@"1"]){
        NSString *str = [Common getValueKey:@"login_type"];
        g_loginType = [str integerValue];
        NSString *userid = [Common getValueKey:@"user_id"];
        NSString *email = [Common getValueKey:@"user_email"];
        
        OSPermissionSubscriptionState* status = [OneSignal getPermissionSubscriptionState];
        NSString* userId = status.subscriptionStatus.userId;
        if(userId)
        {
            [SVProgressHUD show];
            [HttpApi getUserById:email UserID:userid Token:userId Success:^(NSDictionary* result) {
                [SVProgressHUD dismiss];
                UserModel* one = [[UserModel alloc] initWithDictionary:result];
                g_user = one;
                g_bLogin = true;
                if([one.type isEqualToString:USER_TYPE_THERAPIST]){
                    [self gotoTherapistHome];
                } else {
                    [self gotoCustomerHome];
                }
            } Fail:^(NSString *strError) {
                [SVProgressHUD showErrorWithStatus:strError];
            }];
        } else{
            [self showAlertDlg:@"Alert!" Msg:@"Can't get device id. Please try to login again with real phone."];
        }
        
        /*[SVProgressHUD show];
        [HttpApi getUserById:email UserID:userid Token:token Success:^(NSDictionary* result) {
            [SVProgressHUD dismiss];
            UserModel* one = [[UserModel alloc] initWithDictionary:result];
            g_user = one;
            if([one.type isEqualToString:USER_TYPE_THERAPIST]){
                [self gotoTherapistHome];
            } else {
                [self gotoCustomerHome];
            }
        } Fail:^(NSString *strError) {
            [SVProgressHUD showErrorWithStatus:strError];
        }];*/
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTherapistClick:(id)sender {
    g_userType = USER_THERAPIST;
    g_bEditable = NOEDITABLE_MODE;
    TLoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TLoginVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)mUserClick:(id)sender {
    g_userType = USER_CUSTOMER;
    /*ULoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ULoginVC"];
    [self.navigationController pushViewController:vc animated:YES];*/
    g_bLogin = false;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_UserNav"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (void)gotoTherapistHome{
    g_userType = USER_THERAPIST;
    g_bEditable = NOEDITABLE_MODE;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_TherapistNav"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (void)gotoCustomerHome{
    g_userType = USER_CUSTOMER;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_UserNav"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];
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
