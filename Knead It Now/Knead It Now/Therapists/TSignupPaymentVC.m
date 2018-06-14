//
//  TSignupPaymentVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TSignupPaymentVC.h"
#import "CardModel.h"
#import "HttpApi.h"
#import "AppDelegate.h"
#import "Common.h"
#import <OneSignal/OneSignal.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface TSignupPaymentVC (){
    NSString* token;
}

@end

@implementation TSignupPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    token = @"";
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onFinish:(id)sender {
    if(![self checkValidField]) return;
    NSString* exp_str = self.mExpireTxt.text;
    NSArray* foo = [exp_str componentsSeparatedByString:@"/"];
    [SVProgressHUD show];
    [HttpApi getStripeCardToken:self.mCardNameTxt.text CardNum:self.mCardNumberTxt.text ExpMonth:foo[0] ExpYear:foo[1] Cvc:self.mCvvTxt.text Success:^(NSDictionary* result){
        self.card_token = result[@"id"];
        [self createAccountWithCard];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)createAccountWithCard{
    [HttpApi createSTPAccount:self.user.email Source:self.card_token Success:^(NSDictionary* result){
        NSString* stpId = result[@"id"];
        self.user.account_id = stpId;
        [self updateStripeAccount];
        //[self registerTherapist];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)updateStripeAccount{
    if([HttpApi updateTOSAcceptance:self.user.account_id FirstName:self.user.firstName LastName:self.user.lastName Dob:self.user.birthday IpAddress:self.user.ip_address Type:1 Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        [self registerTherapist];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }]){
        
    } else{
        [SVProgressHUD dismiss];
        [self showAlertDlg:@"Warning!" Msg:@"Account updateing failed!"];
    }
}

- (void)registerTherapist{

    OSPermissionSubscriptionState* status = [OneSignal getPermissionSubscriptionState];
    NSString* userId = status.subscriptionStatus.userId;
    if(userId){
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [HttpApi signupToSeller:self.password UserInfo:self.user Token:userId Success:^(NSDictionary* data){
            [SVProgressHUD dismiss];
            g_user = [[UserModel alloc] initWithDictionary:data];
            [Common saveValueKey:@"user_email" Value:g_user.email];
            [Common saveValueKey:@"user_id" Value:g_user.userId];
            [Common saveValueKey:@"login_type" Value:@"1"];
            [Common saveValueKey:@"remember_login" Value:@"1"];
            [self gotoMainScreen];
        } Fail:^(NSString* error){
            [SVProgressHUD showErrorWithStatus:error];
        }];
    } else{
        [self showAlertDlg:@"Alert!" Msg:@"Can't get device id. Please try to login again with real phone."];
    }
    
    /*[SVProgressHUD showWithStatus:@"Please wait..."];
     [HttpApi signupToSeller:self.password UserInfo:self.user Token:token Success:^(NSDictionary* data){
     [SVProgressHUD dismiss];
     g_user = [[UserModel alloc] initWithDictionary:data];
     [Common saveValueKey:@"user_email" Value:g_user.email];
     [Common saveValueKey:@"user_id" Value:g_user.userId];
     [Common saveValueKey:@"login_type" Value:@"1"];
     [Common saveValueKey:@"remember_login" Value:@"1"];
     [self gotoMainScreen];
     } Fail:^(NSString* error){
     [SVProgressHUD showErrorWithStatus:error];
     }];*/
}

- (void)gotoMainScreen{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_TherapistNav"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (BOOL)checkValidField{
    if([self.mCardNameTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter name."];
        return false;
    }
    
    if([self.mCardNumberTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type card number."];
        return false;
    }
    if([self.mExpireTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type expire date."];
        return false;
    }
    NSString* exp_str = self.mExpireTxt.text;
    NSArray* foo = [exp_str componentsSeparatedByString:@"/"];
    if(foo.count != 2){
        [self showAlertDlg:@"Warning!" Msg:@"Please type expire date correctly."];
        return false;
    }
    
    if([foo[0] intValue] > 12 || [foo[1] intValue] > 100){
        [self showAlertDlg:@"Warning!" Msg:@"Please type expire date correctly."];
        return false;
    }
    
    if([self.mCvvTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter cvv."];
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
