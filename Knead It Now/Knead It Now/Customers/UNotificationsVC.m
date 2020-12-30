//
//  UNotificationsVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "UNotificationsVC.h"
#import "Config.h"
#import "UAppointTVC.h"
#import "UPaymentVC.h"
#import "UGiveRatingVC.h"
#import "AppDelegate.h"
#import "HttpApi.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIImageView+WebCache.h"
#import "UMessageVC.h"
#import "UProfileVC.h"

@interface UNotificationsVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation UNotificationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processAccept:) name:NOTIFICATION_STATUS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadEvents];
}

- (void)processAccept:(NSNotification*)msg{
    [self loadEvents];
}

- (void)loadEvents{
    [SVProgressHUD showWithStatus:@"Loading..."];
    [HttpApi getEvents:g_user.userId Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        self.events = [[NSMutableArray alloc] init];
        NSArray* resp = (NSArray*) result;
        for(int i = 0; i < resp.count; i++){
            EventModel* one = [[EventModel alloc] initWithDictionary:resp[i]];
            [self.events addObject:one];
        }
        [self.mTableView reloadData];
    } Fail:^(NSString* errStr){
        [SVProgressHUD showErrorWithStatus:errStr];
    }];
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
    return [self.events count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventModel* one = self.events[indexPath.row];
    
    int h = 68; // type = 4
    if([one.type_id isEqualToString:@"1"]) h = 160;//type = 1, confirmed
    else if([one.type_id isEqualToString:@"2"]) h = 126;// type = 2, finished
    else if([one.type_id isEqualToString:@"3"]) h = 68;// type = 3
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    EventModel* one = self.events[indexPath.row];
    NSString* contentMsg;
    NSDateFormatter *inFormatter = [[NSDateFormatter alloc] init];
    [inFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString* today_str = [inFormatter stringFromDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString* event_time_str = [NSString stringWithFormat:@"%@ %@", today_str, one.event_time];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate* eTime = [dateFormatter dateFromString:event_time_str];
    
    if([one.type_id isEqualToString:@"1"]){
        UAppointTVC *tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_UAppointTVC" forIndexPath:indexPath];
        contentMsg = [NSString stringWithFormat:@"<html><body><font size=5 color=black>%@</font></body></html>", one.content];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[contentMsg dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        tvc.mBookContent.attributedText = attrStr;
        
        if([one.sender_photo length] > 0){
            NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, one.sender_photo];
            [tvc.mUserImage sd_setImageWithURL:[NSURL URLWithString:url]];
        }
        
        NSInteger timeInterval = [[NSDate date] timeIntervalSinceDate:eTime];
        if(timeInterval > 3600){
            tvc.mPastTime.text = [NSString stringWithFormat:@"%ld hours ago", (long)(timeInterval / 3600)];
        } else{
            tvc.mPastTime.text = [NSString stringWithFormat:@"%ld minutes ago", (long)(timeInterval / 60)];
        }
        
        tvc.mFinishBtn.tag = indexPath.row;
        [tvc.mFinishBtn addTarget:self
                        action:@selector(tapFinishClick:)
              forControlEvents:UIControlEventTouchUpInside];
        
        tvc.mCancelBtn.tag = indexPath.row;
        [tvc.mCancelBtn addTarget:self
                           action:@selector(tapCancelClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        cell = tvc;
        return cell;
    } else if([one.type_id isEqualToString:@"3"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"RID_TRateTVC" forIndexPath:indexPath];
        UIImageView* userImg = [cell viewWithTag:11];
        CALayer *imageLayer = userImg.layer;
        [imageLayer setCornerRadius:25];
        [imageLayer setBorderWidth:1];
        [imageLayer setMasksToBounds:YES];
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
        
        if([one.sender_photo length] > 0){
            NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, one.sender_photo];
            [userImg sd_setImageWithURL:[NSURL URLWithString:url]];
        }
        
        UILabel* timelb = [cell viewWithTag:12];
        NSInteger timeInterval = [[NSDate date] timeIntervalSinceDate:eTime];
        if(timeInterval > 3600){
            timelb.text = [NSString stringWithFormat:@"%ld hours ago", (long)(timeInterval / 3600)];
        } else{
            timelb.text = [NSString stringWithFormat:@"%ld minutes ago", (long)(timeInterval / 60)];
        }
        
        UILabel* contentlb1 = [cell viewWithTag:13];
        contentMsg = [NSString stringWithFormat:@"<html><body><font size=5 color=black>%@</font></body></html>", one.content];
        NSAttributedString * attrStr1 = [[NSAttributedString alloc] initWithData:[contentMsg dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        contentlb1.attributedText = attrStr1;
        
        return cell;
    } else if([one.type_id isEqualToString:@"4"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"RID_TMessageTVC" forIndexPath:indexPath];
        UIImageView* userImg = [cell viewWithTag:21];
        CALayer *imageLayer = userImg.layer;
        [imageLayer setCornerRadius:25];
        [imageLayer setBorderWidth:1];
        [imageLayer setMasksToBounds:YES];
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
        
        if([one.sender_photo length] > 0){
            NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, one.sender_photo];
            [userImg sd_setImageWithURL:[NSURL URLWithString:url]];
        }
        
        UILabel* timelb = [cell viewWithTag:22];
        NSInteger timeInterval = [[NSDate date] timeIntervalSinceDate:eTime];
        if(timeInterval > 3600){
            timelb.text = [NSString stringWithFormat:@"%ld hours ago", (long)(timeInterval / 3600)];
        } else{
            timelb.text = [NSString stringWithFormat:@"%ld minutes ago", (long)(timeInterval / 60)];
        }
        
        UILabel* contentlb2 = [cell viewWithTag:23];
        contentMsg = [NSString stringWithFormat:@"<html><body><font size=5 color=black>%@</font></body></html>", one.content];
        NSAttributedString * attrStr2 = [[NSAttributedString alloc] initWithData:[contentMsg dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        contentlb2.attributedText = attrStr2;
        
        return cell;
    } else if([one.type_id isEqualToString:@"2"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"RID_TFinishTVC" forIndexPath:indexPath];
        UIImageView* userImg = [cell viewWithTag:31];
        CALayer *imageLayer = userImg.layer;
        [imageLayer setCornerRadius:25];
        [imageLayer setBorderWidth:1];
        [imageLayer setMasksToBounds:YES];
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
        
        if([one.sender_photo length] > 0){
            NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, one.sender_photo];
            [userImg sd_setImageWithURL:[NSURL URLWithString:url]];
        }
        
        UILabel* timelb = [cell viewWithTag:32];
        NSInteger timeInterval = [[NSDate date] timeIntervalSinceDate:eTime];
        if(timeInterval > 3600){
            timelb.text = [NSString stringWithFormat:@"%ld hours ago", (long)(timeInterval / 3600)];
        } else{
            timelb.text = [NSString stringWithFormat:@"%ld minutes ago", (long)(timeInterval / 60)];
        }
        
        UILabel* contentlb3 = [cell viewWithTag:33];
        contentMsg = [NSString stringWithFormat:@"<html><body><font size=5 color=black>%@</font></body></html>", one.content];
        NSAttributedString * attrStr3 = [[NSAttributedString alloc] initWithData:[contentMsg dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        contentlb3.attributedText = attrStr3;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EventModel* one = self.events[indexPath.row];
    if([one.type_id isEqualToString:@"2"]){
        UGiveRatingVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UGiveRatingVC"];
        vc.bookid = one.book_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if([one.type_id isEqualToString:@"3"]){//Rate
        [self readRateEvent:one.eventid];
    } else if([one.type_id isEqualToString:@"4"]){//message
        [self readMessageEvent:one];
    }
}

- (void)readMessageEvent:(EventModel *)emodel{
    [SVProgressHUD show];
    [HttpApi setEventRead:emodel.eventid Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        if([emodel.book_status isEqualToString:@"requested"] || [emodel.book_status isEqualToString:@"confirmed"]){
            UMessageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UMessageVC"];
            vc.bookid = emodel.book_id;
            vc.fromphoto = emodel.sender_photo;
            vc.fromid = emodel.sender_id;
            [self.navigationController pushViewController:vc animated:YES];
        } else{
            [self loadEvents];
        }
        
    } Fail:^(NSString* errStr){
        [SVProgressHUD showErrorWithStatus:errStr];
    }];
}

- (void)readRateEvent:(NSString *)eid{
    [SVProgressHUD show];
    [HttpApi setEventRead:eid Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        [self loadEvents];
    } Fail:^(NSString* errStr){
        [SVProgressHUD showErrorWithStatus:errStr];
    }];
}

- (IBAction)onBack:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self gotoProfilePage];
}

-(IBAction)tapFinishClick:(id)sender{
    UIButton* btn = (UIButton *)sender;
    EventModel* one = self.events[btn.tag];
    UPaymentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UPaymentVC"];
    vc.book_id = one.book_id;
    vc.event_id = one.eventid;
    vc.event_time = one.event_time;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)tapCancelClick:(id)sender{
    UIButton* btn = (UIButton *)sender;
    EventModel* one = self.events[btn.tag];
    [SVProgressHUD showWithStatus:@"Cancelling..."];
    [HttpApi cancelAppointment:one.book_id Success:^(NSDictionary* result){
        [SVProgressHUD showSuccessWithStatus:@"This Appointment was cancelled."];
        [self gotoProfilePage];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)gotoProfilePage{
    //[self.navigationController popToRootViewControllerAnimated:YES];//search page
    UProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UProfileVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
