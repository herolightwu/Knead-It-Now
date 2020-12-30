//
//  ULoginVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/19.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "ULoginVC.h"
#import "Config.h"
#import "ForgotVC.h"
#import "Common.h"
#import "USignupVC.h"
#import "NetworkManager.h"
#import "SVProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "HttpApi.h"
#import "AppDelegate.h"
#import "FacebookUserInfo.h"
#import <OneSignal/OneSignal.h>

@interface ULoginVC (){
    NSString* token;
    NSString* fbToken;
    FacebookUserInfo *facebookUserInfo;
}

@end

@implementation ULoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
    CALayer *imageLayer = self.mLoginBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mFacebookView.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mGoogleView.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mSignupView.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    token = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
//- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onLogin:(id)sender {
    if(![NetworkManager IsConnectionAvailable]){
        [self showAlertDlg:@"Network Error" Msg:@"Please check network status."];
        return;
    }
    if(![self checkValidField]) return;
    
    OSPermissionSubscriptionState* status = [OneSignal getPermissionSubscriptionState];
    NSString* userId = status.subscriptionStatus.userId;
    if(userId){
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [HttpApi loginWithEmail:self.mEmailTxt.text Password:self.mPasswordTxt.text Token:userId Success:^(NSDictionary *result){
            [SVProgressHUD dismiss];
            g_loginType = LOGIN_TYPE_GENERAL;
            UserModel* one = [[UserModel alloc] initWithDictionary:result];
            if([one.type isEqualToString:USER_TYPE_CUSTOMER]){
                [Common saveValueKey:@"user_email" Value:one.email];
                [Common saveValueKey:@"user_id" Value:one.userId];
                [Common saveValueKey:@"login_type" Value:@"1"];
                [Common saveValueKey:@"remember_login" Value:@"1"];
                g_user = one;
                [self gotoMainScreen];
            } else{
                [self showAlertDlg:@"Warning!" Msg:@"You can't login with this email address as customer."];
            }
        } Fail:^(NSString* errStr){
            [SVProgressHUD showErrorWithStatus:errStr];
        }];
    } else{
        [self showAlertDlg:@"Alert!" Msg:@"Can't get device id. Please try to login again with real phone."];
    }
    
}

- (IBAction)onForgotPassword:(id)sender {
    ForgotVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ForgotVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onFacebookLogin:(id)sender {
    if(![NetworkManager IsConnectionAvailable]){
        [self showAlertDlg:@"Network Error" Msg:@"Please check network status."];
        return;
    }
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email"] fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                    [self showAlertDlg:@"Network Error" Msg:error.description];
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                    //[self showAlertDlg:@"Network Error" Msg:@"Cancelled"];
                                } else {
                                    NSLog(@"Logged in");
                                    FBSDKAccessToken* fToken = [FBSDKAccessToken currentAccessToken];
                                    if ([FBSDKAccessToken currentAccessToken]) {
                                        fbToken = fToken.tokenString;
                                        
                                        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                                        [parameters setValue:@"id,first_name, name, last_name, email" forKey:@"fields"];
                                        
                                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                                         
                                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                             if (!error) {
                                                 NSLog(@"fetched user:%@", result);
                                                 
                                                 NSDictionary *dicResult = (NSDictionary *)result;
                                                 facebookUserInfo = [[FacebookUserInfo alloc] init];
                                                 
                                                 facebookUserInfo.facebookId = dicResult[@"id"];
                                                 facebookUserInfo.firstName = dicResult[@"first_name"];
                                                 facebookUserInfo.lastName = dicResult[@"last_name"];
                                                 facebookUserInfo.email = dicResult[@"email"];
                                                 facebookUserInfo.birthday = dicResult[@"birthday"];
                                                 facebookUserInfo.gender = dicResult[@"gender"];
                                                 facebookUserInfo.location = dicResult[@"location"][@"name"];
                                                 //self.facebookUserInfo.picture = dicResult[@"picture"][@"data"][@"url"];
                                                 
                                                 [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/picture", facebookUserInfo.facebookId] parameters:@{@"redirect": @"false", @"width":@"200", @"height":@"200"}]
                                                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                                      if (!error) {
                                                          NSLog(@"fetched user:%@", result);
                                                          NSDictionary *dicResult = (NSDictionary *)result;
                                                          facebookUserInfo.picture = dicResult[@"data"][@"url"];
                                                          
                                                          OSPermissionSubscriptionState* status = [OneSignal getPermissionSubscriptionState];
                                                          NSString* tokenID = status.subscriptionStatus.userId;
                                                          if(tokenID){
                                                              [SVProgressHUD show];
                                                              [HttpApi loginWithSocial:(NSString*)facebookUserInfo.email Username:facebookUserInfo.firstName Lastname:facebookUserInfo.lastName SocialID:facebookUserInfo.facebookId Type:@"fb" Photo:facebookUserInfo.picture Token:tokenID Success:^(NSDictionary* result){
                                                                  [SVProgressHUD dismiss];
                                                                  g_loginType = LOGIN_TYPE_SOCIAL;
                                                                  UserModel* one = [[UserModel alloc] initWithDictionary:result];
                                                                  if([one.type isEqualToString:USER_TYPE_CUSTOMER]){
                                                                      [Common saveValueKey:@"user_email" Value:one.email];
                                                                      [Common saveValueKey:@"user_id" Value:one.userId];
                                                                      [Common saveValueKey:@"login_type" Value:@"2"];
                                                                      [Common saveValueKey:@"remember_login" Value:@"1"];
                                                                      g_user = one;
                                                                      [self gotoMainScreen];
                                                                  }
                                                              } Fail:^(NSString* errStr){
                                                                  [SVProgressHUD showErrorWithStatus:errStr];
                                                              }];
                                                          } else{
                                                              [self showAlertDlg:@"Alert!" Msg:@"Can't get device id. Please try to login again with real phone."];
                                                          }
                                                          
                                                          /*[SVProgressHUD show];
                                                          [HttpApi loginWithSocial:(NSString*)facebookUserInfo.email Username:facebookUserInfo.firstName Lastname:facebookUserInfo.lastName SocialID:facebookUserInfo.facebookId Type:@"fb" Photo:facebookUserInfo.picture Token:token Success:^(NSDictionary* result){
                                                              [SVProgressHUD dismiss];
                                                              g_loginType = LOGIN_TYPE_SOCIAL;
                                                              UserModel* one = [[UserModel alloc] initWithDictionary:result];
                                                              if([one.type isEqualToString:USER_TYPE_CUSTOMER]){
                                                                  [Common saveValueKey:@"user_email" Value:one.email];
                                                                  [Common saveValueKey:@"user_id" Value:one.userId];
                                                                  [Common saveValueKey:@"login_type" Value:@"2"];
                                                                  [Common saveValueKey:@"remember_login" Value:@"1"];
                                                                  g_user = one;
                                                                  [self gotoMainScreen];
                                                              }
                                                          } Fail:^(NSString* errStr){
                                                              [SVProgressHUD showErrorWithStatus:errStr];
                                                          }];*/
                                                          
                                                          [login logOut];
                                                      }
                                                  }];
                                             }
                                         }];
                                    }
                                }
                            }];
}


- (IBAction)onGoolgeLogin:(id)sender {
    if(![NetworkManager IsConnectionAvailable]){
        [self showAlertDlg:@"Network Error" Msg:@"Please check network status."];
        return;
    }
    
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    if(user != nil){
        NSString *userId = user.userID;                  // For client-side use only!
        //NSString *idToken = user.authentication.idToken; // Safe to send to the server
        //NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        NSURL *imageURL;
        if (user.profile.hasImage){
            NSUInteger dimension = round(120 * [[UIScreen mainScreen] scale]);
            imageURL = [user.profile imageURLWithDimension:dimension];
        }
        
        OSPermissionSubscriptionState* status = [OneSignal getPermissionSubscriptionState];
        NSString* tokenID = status.subscriptionStatus.userId;
        if(tokenID){
            [SVProgressHUD show];
            [HttpApi loginWithSocial:email Username:givenName Lastname:familyName SocialID:userId Type:@"gl" Photo:imageURL.absoluteString Token:tokenID Success:^(NSDictionary* result){
                [SVProgressHUD dismiss];
                g_loginType = LOGIN_TYPE_SOCIAL;
                UserModel* one = [[UserModel alloc] initWithDictionary:result];
                if([one.type isEqualToString:USER_TYPE_CUSTOMER]){
                    [Common saveValueKey:@"user_email" Value:one.email];
                    [Common saveValueKey:@"user_id" Value:one.userId];
                    [Common saveValueKey:@"login_type" Value:@"2"];
                    [Common saveValueKey:@"remember_login" Value:@"1"];
                    g_user = one;
                    [self gotoMainScreen];
                }
            } Fail:^(NSString *errStr){
                [SVProgressHUD showErrorWithStatus:errStr];
            }];
        } else{
            [self showAlertDlg:@"Alert!" Msg:@"Can't get device id. Please try to login again with real phone."];
        }
        
        /*[SVProgressHUD show];
        [HttpApi loginWithSocial:email Username:givenName Lastname:familyName SocialID:userId Type:@"gl" Photo:imageURL.absoluteString Token:token Success:^(NSDictionary* result){
            [SVProgressHUD dismiss];
            g_loginType = LOGIN_TYPE_SOCIAL;
            UserModel* one = [[UserModel alloc] initWithDictionary:result];
            if([one.type isEqualToString:USER_TYPE_CUSTOMER]){
                [Common saveValueKey:@"user_email" Value:one.email];
                [Common saveValueKey:@"user_id" Value:one.userId];
                [Common saveValueKey:@"login_type" Value:@"2"];
                [Common saveValueKey:@"remember_login" Value:@"1"];
                g_user = one;
                [self gotoMainScreen];
            }
        } Fail:^(NSString *errStr){
            [SVProgressHUD showErrorWithStatus:errStr];
        }];*/
        [[GIDSignIn sharedInstance] signOut];
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (IBAction)onSignup:(id)sender {
    USignupVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_USignupVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoMainScreen{
    /*UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_UserNav"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];*/
    g_bLogin = true;
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)checkValidField{
    if([self.mEmailTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email address."];
        return false;
    }
    if([self.mPasswordTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type password."];
        return false;
    }
    if(![Common IsValidEmail:self.mEmailTxt.text]){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email address correctly."];
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
