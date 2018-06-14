//
//  UPaymentVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "UPaymentVC.h"
#import "Config.h"
#import "UPaymentCardTVC.h"
#import "UConfirmedVC.h"
#import "UMessageVC.h"
#import "HttpApi.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "CardModel.h"

@interface UPaymentVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger sel_ind;
    
}
@end

@implementation UPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mPayBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    sel_ind = -1;
    self.charge_id = @"";
    self.charge_status = @"";
    self.cardArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loaddata];
    [self loadCardData];
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

- (void)loaddata{
    [SVProgressHUD show];
    [HttpApi getPaymentInfo:self.book_id Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        self.destination_id = result[@"seller_stripe_id"];
        self.bookdata = [[BookModel alloc] initWithDictionary:result[@"book"]];
        [self setLayout];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)setLayout{
    NSDateFormatter *inFormatter = [[NSDateFormatter alloc] init];
    [inFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString* today_str = [inFormatter stringFromDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString* event_time_str = [NSString stringWithFormat:@"%@ %@", today_str, self.event_time];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate* eTime = [dateFormatter dateFromString:event_time_str];
    NSInteger timeInterval = [[NSDate date] timeIntervalSinceDate:eTime];
    if(timeInterval/60 > 15){
        [SVProgressHUD showWithStatus:@"Cancelling..."];
        [HttpApi cancelAppointment:self.book_id Success:^(NSDictionary* result){
            [SVProgressHUD showSuccessWithStatus:@"This Appointment was cancelled."];
            [self.navigationController popViewControllerAnimated:YES];
        } Fail:^(NSString* errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else{
        NSString *contentMsg = [NSString stringWithFormat:@"<html><body><font size=5 color=black>You are sending payment to <b>%@</b></font></body></html>", self.bookdata.seller_name];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[contentMsg dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.mAlertLabel.attributedText = attrStr;
        self.mDuration.text = self.bookdata.duration;
        self.mMassageType.text = TYPES_MASSAGES[[self.bookdata.massage_type integerValue]-1];
        self.mPriceLabel.text = [NSString stringWithFormat:@"$ %@", self.bookdata.cost];
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
    CardModel* one = self.cardArray[indexPath.row];
    UPaymentCardTVC *tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_UPaymentCardTVC" forIndexPath:indexPath];
    tvc.mCardNumber.text = [NSString stringWithFormat:@"%@ **** **** **** %@", one.brand, one.last4];
    if(sel_ind == indexPath.row){
       [tvc.mCheck setOn:YES];
    } else{
       [tvc.mCheck setOn:NO];
    }
    cell = tvc;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(sel_ind == indexPath.row){
        sel_ind = -1;
    } else{
        sel_ind = indexPath.row;
    }
    [self.mTableView reloadData];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPay:(id)sender {
    if(sel_ind >= 0){
        CardModel* one = self.cardArray[sel_ind];
        float cost_val = [self.bookdata.cost floatValue];
        NSString* amount = [NSString stringWithFormat:@"%ld", (long)(cost_val * 100)];
        NSString* fee = [NSString stringWithFormat:@"%ld", (long)(cost_val*10)];// 10% fee
        NSString* desc = [NSString stringWithFormat:@"Charge for %@ massage", TYPES_MASSAGES[[self.bookdata.massage_type intValue]-1]];
        [SVProgressHUD show];
        [HttpApi chargeSTPPayment:g_user.account_id CardId:one.cardId Amount:amount AppFee:fee AccountId:self.destination_id Desc:desc Success:^(NSDictionary* result){
            self.charge_id = result[@"id"];
            self.charge_status = result[@"status"];
            [self uploadPayInfo];
        } Fail:^(NSString* errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
    }
}

- (void)uploadPayInfo{
    CardModel* one = self.cardArray[sel_ind];
    NSString* cardname = [NSString stringWithFormat:@"%@ **** **** **** %@", one.brand, one.last4];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
    NSString* ptime = [dateFormatter stringFromDate:[NSDate date]];
    [HttpApi uploadPayInfo:self.event_id BookId:self.book_id PayTime:ptime ChargeId:self.charge_id CardName:cardname ChargeStatus:self.charge_status Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        UConfirmedVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UConfirmedVC"];
        vc.bookdata = self.bookdata;
        [self.navigationController pushViewController:vc animated:YES];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (IBAction)onMessage:(id)sender {
    if([self.bookdata.status isEqualToString:@"confirmed"]){
        UMessageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UMessageVC"];
        vc.bookid = self.book_id;
        vc.fromphoto = self.bookdata.seller_photo;
        vc.fromid = self.bookdata.seller_id;
        [self.navigationController pushViewController:vc animated:YES];
    }    
}
@end
