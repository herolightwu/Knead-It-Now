//
//  TCardDetailVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TCardDetailVC.h"
#import "Config.h"
#import "HttpApi.h"
#import "AppDelegate.h"
#import "ChooseDateView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface TCardDetailVC ()<ChooseDateViewDelegate>{
    BOOL bdef;
    NSDate* ex_date;
}

@end

@implementation TCardDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mDelBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    bdef = self.carddata.bDef;
    NSString *date_str = [NSString stringWithFormat:@"%@/%@", self.carddata.expMonth, self.carddata.expYear];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/yy"];
    ex_date = [outputFormatter dateFromString:date_str];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLayout];
}

- (void)setLayout{
    self.mCardName.text = self.carddata.name;
    self.mCardNumber.text = [NSString stringWithFormat:@"**** **** **** %@", self.carddata.last4];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/yy"];
    [self.mExpireBtn setTitle:[outputFormatter stringFromDate:ex_date] forState:UIControlStateNormal];
    if([g_user.type isEqualToString:USER_TYPE_THERAPIST]){
        self.mSwitchView.hidden = NO;
    } else{
        self.mSwitchView.hidden = YES;
    }
    if(bdef){
        [self.mSwitch setOn:YES];
    } else{
        [self.mSwitch setOn:NO];
    }
    
    if([g_user.type isEqualToString:USER_TYPE_THERAPIST] && self.card_count < 2){
        self.mDelBtn.hidden = YES;
    } else{
        self.mDelBtn.hidden = NO;
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDelete:(id)sender {
    if([g_user.type isEqualToString:USER_TYPE_THERAPIST]){
        [SVProgressHUD show];
        [HttpApi deleteAccountCard:g_user.account_id CardId:self.carddata.cardId Success:^(NSDictionary *result){
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        } Fail:^(NSString* errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
    } else{
        [SVProgressHUD show];
        [HttpApi deleteCustomerCard:g_user.account_id CardId:self.carddata.cardId Success:^(NSDictionary *result){
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        } Fail:^(NSString* errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
    }
}

- (IBAction)onSwitch:(id)sender {
    bdef = !bdef;
}

- (IBAction)onDone:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM"];
    NSString *myMonthString = [df stringFromDate:ex_date];
    [df setDateFormat:@"yyyy"];
    NSString *myYearString = [df stringFromDate:ex_date];
    if([g_user.type isEqualToString:USER_TYPE_THERAPIST]){
        NSString* def_str = @"false";
        if(bdef) def_str = @"true";
        [SVProgressHUD show];
        [HttpApi updateAccountCard:g_user.account_id CardId:self.carddata.cardId Name:self.mCardName.text Ex_month:myMonthString Ex_year:myYearString DefaultCard:def_str Success:^(NSDictionary* result){
            [SVProgressHUD dismiss];
            CardModel* one = [[CardModel alloc] initWithDictionary:result];
            self.carddata = one;
            [self setLayout];
        } Fail:^(NSString *errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
        
    } else{
        [SVProgressHUD show];
        [HttpApi updateCustomerCard:g_user.account_id CardId:self.carddata.cardId Name:self.mCardName.text Ex_month:myMonthString Ex_year:myYearString Success:^(NSDictionary *result){
            [SVProgressHUD dismiss];
            CardModel* one = [[CardModel alloc] initWithDictionary:result];
            self.carddata = one;
            [self setLayout];
        } Fail:^(NSString *errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
    }
    
}

- (IBAction)onExpireClick:(id)sender {
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
    ex_date = option;
}


@end
