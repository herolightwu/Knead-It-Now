//
//  TPaymentVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TPaymentVC.h"
#import "TCardDetailVC.h"
#import "TAddCardVC.h"
#import "CardModel.h"
#import "AppDelegate.h"
#import "Config.h"
#import "HttpApi.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "PayHistory.h"

@interface TPaymentVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cardArray = [[NSMutableArray alloc] init];
    self.payArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadCardData];
    [self loadHistory];
}

- (void)loadHistory{
    [HttpApi getPayHistory:g_user.userId Success:^(NSDictionary* result){
        NSArray* response = (NSArray*) result;
        self.payArray = [[NSMutableArray alloc] init];
        for(int i = 0 ; i < response.count; i++){
            PayHistory* one = [[PayHistory alloc] initWithDictionary:response[i]];
            [self.payArray addObject:one];
        }
        [self.mHistoryTable reloadData];
    } Fail:^(NSString* errstr){
        
    }];
}

- (void)loadCardData{
    if([g_user.account_id length] > 0){
        [SVProgressHUD show];
        [HttpApi getCardListFromAccount:g_user.account_id Success:^(NSDictionary* result){
            [SVProgressHUD dismiss];
            self.cardArray = [[NSMutableArray alloc] init];
            NSArray* dataArray = (NSArray*)result[@"data"];
            for(int i = 0 ; i < dataArray.count; i++){
                CardModel* one = [[CardModel alloc] initWithDictionary:dataArray[i]];
                [self.cardArray addObject:one];
            }
            [self.mCardTable reloadData];
        } Fail:^(NSString* errStr){
            [SVProgressHUD showErrorWithStatus:errStr];
        }];
    } else{
        [self.mCardTable reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableView == self.mCardTable){
        return [self.cardArray count];
    } else if(tableView == self.mHistoryTable){
        return [self.payArray count];;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 86;
    if(tableView == self.mCardTable){
        h = 41;
    } else if(tableView == self.mHistoryTable){
        h = 86;
    }
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    if(tableView == self.mCardTable){
        cell = [tableView dequeueReusableCellWithIdentifier:@"RID_PaymentCardCell" forIndexPath:indexPath];
        UILabel* tlb = [cell viewWithTag:5];
        CardModel* one = self.cardArray[indexPath.row];
        tlb.text = [NSString stringWithFormat:@"%@ **** **** **** %@", one.brand, one.last4];
        return cell;
    } else if(tableView == self.mHistoryTable){
        PayHistory* other = self.payArray[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"RID_PaymentHistoryCell" forIndexPath:indexPath];
        
        NSDateFormatter *inFormatter = [[NSDateFormatter alloc] init];
        [inFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate* bookdate = [inFormatter dateFromString:other.book_date];
        [inFormatter setDateFormat:@"MMMM dd yyyy"];
        NSString* date_str = [inFormatter stringFromDate:bookdate];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSString* event_time_str = [NSString stringWithFormat:@"%@ %@", other.book_date, other.book_time];
        [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
        NSDate* sTime = [dateFormatter dateFromString:event_time_str];
        NSInteger duration = [other.duration integerValue];
        NSDate* eTime = [sTime dateByAddingTimeInterval:duration*60];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString* estr = [dateFormatter stringFromDate:eTime];
        
        UILabel* datelb = [cell viewWithTag:1];
        datelb.text = [NSString stringWithFormat:@"%@ | %@ - %@", date_str, other.book_time, estr];
        
        UILabel* typelb = [cell viewWithTag:2];
        typelb.text = TYPES_MASSAGES[[other.massage_type intValue]-1];
        UILabel* cardlb = [cell viewWithTag:3];
        cardlb.text = other.card_name;
        UILabel* costlb = [cell viewWithTag:4];
        costlb.text = [NSString stringWithFormat:@"$ %@", other.price];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.mCardTable){
        CardModel* one = self.cardArray[indexPath.row];
        TCardDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TCardDetailVC"];
        vc.carddata = one;
        vc.card_count = self.cardArray.count;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddCard:(id)sender {
    TAddCardVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TAddCardVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
