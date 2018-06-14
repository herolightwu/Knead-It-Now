//
//  TSignupVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TSignupVC.h"
#import "Config.h"
#import "TSignupInfoVC.h"
#import "Common.h"
#import "UserModel.h"

@interface TSignupVC (){
    UserModel* signup_user;
    NSString* password;
}

@end

@implementation TSignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    signup_user = [[UserModel alloc] init];
    password = @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mUsernameTxt.text = signup_user.userName;
    self.mEmailTxt.text = signup_user.email;
    self.mPasswordTxt.text = password;
    self.mConfirmPassTxt.text = password;
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

- (IBAction)onNext:(id)sender {
    if(![self checkValidField]) return;
    signup_user.userName = self.mUsernameTxt.text;
    signup_user.email = self.mEmailTxt.text;
    password = self.mPasswordTxt.text;
    TSignupInfoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TSignupInfoVC"];
    vc.user = signup_user;
    vc.password = password;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)checkValidField{
    if([self.mUsernameTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter username."];
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
    
    if([self.mPasswordTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter business name."];
        return false;
    }
    
    if(![self.mPasswordTxt.text isEqualToString:self.mConfirmPassTxt.text]){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter confirm password correctly."];
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
