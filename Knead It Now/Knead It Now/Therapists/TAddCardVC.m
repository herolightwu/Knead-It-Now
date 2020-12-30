//
//  TAddCardVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TAddCardVC.h"
#import "Config.h"
#import "ChooseDateView.h"
#import "AppDelegate.h"
#import "HttpApi.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface TAddCardVC ()<ChooseDateViewDelegate>
{
    
}
@end

@implementation TAddCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.card_token = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)setLayout{
    
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

- (IBAction)onDone:(id)sender {
    if(![self checkValidField]) return;
    NSString* exp_str = self.mExpireBtn.titleLabel.text;
    NSArray* foo = [exp_str componentsSeparatedByString:@"/"];
    
    [SVProgressHUD show];
    [HttpApi getStripeCardToken:self.mCardName.text CardNum:self.mCardNumber.text ExpMonth:foo[0] ExpYear:foo[1] Cvc:self.mCVV.text Success:^(NSDictionary* result){
        self.card_token = result[@"id"];
        [self addCardToAccount];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)addCardToAccount{
    if([g_user.type isEqualToString:USER_TYPE_THERAPIST]){
        if([g_user.account_id length] > 0){
            [HttpApi addCardToAccount:g_user.account_id Source:self.card_token Success:^(NSDictionary* result){
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            } Fail:^(NSString* errstr){
                [SVProgressHUD showErrorWithStatus:errstr];
            }];
        } else{
            [HttpApi createSTPAccount:g_user.email Source:self.card_token Success:^(NSDictionary* result){
                NSString* stpId = result[@"id"];
                [self updateSTPID:stpId];
                [self updateStripeAccount];
            } Fail:^(NSString* errstr){
                [SVProgressHUD showErrorWithStatus:errstr];
            }];
        }
        
    } else{
        if([g_user.account_id length] > 0){
            [HttpApi addCardToCustomer:g_user.account_id Source:self.card_token Success:^(NSDictionary* result){
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            } Fail:^(NSString* errstr){
                [SVProgressHUD showErrorWithStatus:errstr];
            }];
        } else{
            NSString* desc = [NSString stringWithFormat:@"%@ %@", g_user.firstName, g_user.lastName];
            [HttpApi createStripeCustomer:g_user.email Source:self.card_token Desc:desc Success:^(NSDictionary* result){
                NSString* stpId = result[@"id"];
                [self updateSTPID:stpId];
            } Fail:^(NSString* errstr){
                [SVProgressHUD showErrorWithStatus:errstr];
            }];
        }
    }
    
}

- (void)updateStripeAccount{
    if([HttpApi updateTOSAcceptance:g_user.account_id FirstName:g_user.firstName LastName:g_user.lastName Dob:g_user.birthday IpAddress:g_user.ip_address Type:1 Success:^(NSDictionary* result){
    } Fail:^(NSString* errstr){
        
    }]){
        
    } else{
        [self showAlertDlg:@"Warning!" Msg:@"Account updateing failed!"];
    }
}


- (void)updateSTPID:(NSString *)act_id{
    [HttpApi updateStpAccount:g_user.userId StpId:act_id Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        g_user.account_id = act_id;
        [self.navigationController popViewControllerAnimated:YES];
    } Fail:^(NSString *errstr){
        if([g_user.type isEqualToString:USER_TYPE_THERAPIST]){
            [self deleteAccountFromSTP:act_id];
        } else{
            [self deleteCustomerFromSTP:act_id];
        }
        
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)deleteAccountFromSTP:(NSString *)act_id{
    [HttpApi deleteSTPAccount:act_id Success:^(NSDictionary *result){
        [self setLayout];
    } Fail:^(NSString* errstr){
        
    }];
}

- (void)deleteCustomerFromSTP:(NSString*)act_id{
    [HttpApi deleteStripeCustomer:act_id Success:^(NSDictionary *result){
        [self setLayout];
    } Fail:^(NSString* errstr){
        
    }];
}

- (IBAction)onExpireDate:(id)sender {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    ChooseDateView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseDateView" owner:self options:nil] objectAtIndex:0];
    chooseView.m_alertView = alertView;
    chooseView.delegate = self;
    chooseView.type = 0;
    chooseView.mDate = [NSDate date];
    [chooseView setLayout];
    
    [alertView setContainerView:chooseView];
    [alertView setButtonTitles:nil];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

- (void)doneSaveWithChooseDateView:(ChooseDateView *)chooseDateView Option:(NSDate *)option
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //[outputFormatter setDateFormat:@"yyyy-MMM-dd"];
    [outputFormatter setDateFormat:@"MM/yy"];
    [self.mExpireBtn setTitle:[outputFormatter stringFromDate:option] forState:UIControlStateNormal];
}

- (BOOL)checkValidField{
    if([self.mCardName.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type card name."];
        return false;
    }
    
    if([self.mCardNumber.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type card number."];
        return false;
    }
    
    if([self.mExpireBtn.titleLabel.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please choose expire date."];
        return false;
    }
    
    if([self.mCVV.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type cvv."];
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
