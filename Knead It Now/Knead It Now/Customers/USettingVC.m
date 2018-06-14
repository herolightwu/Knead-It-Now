//
//  USettingVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/22.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "USettingVC.h"
#import "Config.h"
#import "ChangePassword.h"
#import "TCardDetailVC.h"
#import "TAddCardVC.h"
#import "HNKMapViewController.h"
#import "ChangeUserInfo.h"
#import "AppDelegate.h"
#import "HttpApi.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Common.h"
#import <Stripe/Stripe.h>
#import "CardModel.h"

@interface USettingVC ()<UITableViewDataSource, UITableViewDelegate, ChangePasswordDelegate, HNKMapViewControllerDelegate, ChangeUserInfoDelegate>

@end

@implementation USettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mContactBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mLogoutBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mDeleteBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    self.cardArray = [[NSMutableArray alloc] init];
    
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadCardData];
}

- (void)setLayout{
    self.mPhoneNumber.text = g_user.phone;
    self.mEmailLabel.text = g_user.email;
    if([g_user.homeAddr length] > 0){
        NSArray* addr_array = [g_user.homeAddr componentsSeparatedByString:@","];
        if(addr_array.count > 0){
            self.mCityLabel.text = addr_array[0];
        }
        NSString* city_str = @"";
        for(int i = 1; i < addr_array.count; i++){
            city_str = [NSString stringWithFormat:@"%@ %@", city_str, addr_array[i]];
        }
        self.mAddress.text = city_str;
    } else{
        self.mCityLabel.text = @"";
        self.mAddress.text = @"";
    }
}

- (void)loadCardData{
    if([g_user.account_id length] > 0){
        [SVProgressHUD show];
        [HttpApi getCardListFromCustomer:g_user.account_id Success:^(NSDictionary* result){
            [SVProgressHUD dismiss];
            self.cardArray = [[NSMutableArray alloc] init];
            NSArray* dataArray = (NSArray*)result[@"data"];
            for(int i = 0 ; i < dataArray.count; i++){
                CardModel* one = [[CardModel alloc] initWithDictionary:dataArray[i]];
                [self.cardArray addObject:one];
            }
            [self.mTableView reloadData];
        } Fail:^(NSString* errStr){
            [SVProgressHUD showErrorWithStatus:errStr];
        }];
    } else{
        [self.mTableView reloadData];
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
//Tableview delegate , Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.cardArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 41;
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"RID_PaymentCardCell" forIndexPath:indexPath];
    UILabel* tlb = [cell viewWithTag:5];
    CardModel* one = self.cardArray[indexPath.row];
    tlb.text = [NSString stringWithFormat:@"%@ **** **** **** %@", one.brand, one.last4];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CardModel* one = self.cardArray[indexPath.row];
    TCardDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TCardDetailVC"];
    vc.carddata = one;
    vc.card_count = self.cardArray.count;
    [self.navigationController pushViewController:vc animated:YES];
}

//========================================

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onChooseAddress:(id)sender {
    HNKMapViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_HNKMapViewController"];
    mVC.delegate = self;
    mVC.mLocation = g_user.homeLoc;
    mVC.mAddress = g_user.homeAddr;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onChangeInfo:(id)sender {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    ChangeUserInfo *changeInfo = [[[NSBundle mainBundle] loadNibNamed:@"ChangeUserInfo" owner:self options:nil] objectAtIndex:0];
    changeInfo.m_alertView = alertView;
    changeInfo.delegate = self;
    
    [alertView setContainerView:changeInfo];
    [alertView setButtonTitles:nil];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

- (IBAction)onAddCard:(id)sender {
    TAddCardVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TAddCardVC"];
    [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)onContact:(id)sender {
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

- (IBAction)onLogout:(id)sender {
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
    if([g_user.account_id length] > 0){
        [HttpApi deleteStripeCustomer:g_user.account_id Success:^(NSDictionary *result) {
            
        } Fail:^(NSString *errstr) {
            //[SVProgressHUD showErrorWithStatus:errstr];
        }];
    }
    [SVProgressHUD showWithStatus:@"Deleting..."];
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
}

- (void)doneSaveWithChangePassword:(ChangePassword *)changePassword{
    //[self setLayout];
}

- (void)doneUpdateLocation:(HNKMapViewController *)viewController CurLoc:(NSString *)mLoc CurAddr:(NSString *)mAddr{
    [SVProgressHUD showWithStatus:@"Updating..."];
    [HttpApi updateHomeAddr:g_user.userId HomeAddr:mAddr HomeLoc:mLoc Success:^(NSDictionary* result){
        [SVProgressHUD showSuccessWithStatus:@"Your Address was updated successfuly"];
        g_user.homeAddr = mAddr;
        g_user.homeLoc = mLoc;
        [self setLayout];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)doneSaveWithChangeInfo:(ChangeUserInfo *)changeUserInfo{
    [self setLayout];
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
