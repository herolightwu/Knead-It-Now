//
//  TMyAccountVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TMyAccountVC.h"
#import "Config.h"
#import "ChangePassword.h"
#import "Common.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"

@interface TMyAccountVC ()<ChangePasswordDelegate>

@end

@implementation TMyAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mLogoutBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mContactBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mDeleteBtn.layer;
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

- (IBAction)onChangePassword:(id)sender {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    ChangePassword *changePass = [[[NSBundle mainBundle] loadNibNamed:@"ChangePassword" owner:self options:nil] objectAtIndex:0];
    changePass.m_alertView = alertView;
    changePass.delegate = self;
    
    [alertView setContainerView:changePass];
    [alertView setButtonTitles:nil];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

- (IBAction)onContactService:(id)sender {
    NSString *emailTitle = @"Welcome KneadItNow App";
    // Email Content
    NSString *messageBody = @"<h3>To Service Center</h3>"; // Change the message body to HTML
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"serviceinfo@kneaditnow.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)onLogOut:(id)sender {
    [Common saveValueKey:@"remember_login" Value:@"0"];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_WelcomeNav"];
    mVC.modalTransitionStyle = UIModalPresentationNone;
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (IBAction)onDeleteAccount:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Confirm Delete"
                                  message:@"Do you really want to delete your account?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self deleteAccount];
                                }];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel your yes please button action here
                                   }];
    [alert addAction:cancelButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}

- (void)deleteAccount{
    [SVProgressHUD showWithStatus:@"Deleting..."];
    [HttpApi deleteSTPAccount:g_user.account_id Success:^(NSDictionary *result) {
        [HttpApi removeAccount:g_user.userId Success:^(NSDictionary *dic) {
            [SVProgressHUD dismiss];
            [Common saveValueKey:@"remember_login" Value:@"0"];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_WelcomeNav"];
            mVC.modalTransitionStyle = UIModalPresentationNone;
            [self presentViewController:mVC animated:YES completion:NULL];
        } Fail:^(NSString *erstr) {
            [SVProgressHUD showErrorWithStatus:erstr];
        }];
    } Fail:^(NSString *errstr) {
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)doneSaveWithChangePassword:(ChangePassword *)changePassword{
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
