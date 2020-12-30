//
//  UConfirmedVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/22.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "UConfirmedVC.h"
#import "Config.h"
#import <EventKit/EventKit.h>
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"
#import "UProfileVC.h"

@interface UConfirmedVC ()

@end

@implementation UConfirmedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mTherapistImg.layer;
    [imageLayer setCornerRadius:40];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mAddBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mCancelBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
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
    NSString* filename = self.bookdata.seller_photo;
    if([filename length] > 0) {
        NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, filename];
        [self.mTherapistImg sd_setImageWithURL:[NSURL URLWithString:url]];
    } else{
        [self.mTherapistImg setImage:[UIImage imageNamed:@"ic_therapist.png"]];
    }
    self.mNameLabel.text = self.bookdata.seller_name;
    self.mRateLabel.text = [NSString stringWithFormat:@"%.1f", [self.bookdata.seller_rate floatValue]];
    self.mBusiness.text = self.bookdata.bs_name;
    if([self.bookdata.bs_address length] > 0){
        NSArray* arr_str = [self.bookdata.bs_address componentsSeparatedByString:@","];
        if(arr_str.count > 0){
            self.mCityLabel.text = arr_str[0];
        }
        if(arr_str.count > 1){
            self.mAddressLabel.text = arr_str[1];
        }
        if(arr_str.count >2){
            self.mAddressLabel.text = [NSString stringWithFormat:@"%@ %@", arr_str[1], arr_str[2]];
        }
    }
    
    self.mDuration.text = self.bookdata.duration;
    self.mMassageType.text = TYPES_MASSAGES[[self.bookdata.massage_type intValue] - 1];
    self.mPriceLabel.text = [NSString stringWithFormat:@"$ %@", self.bookdata.cost];
    self.mPhoneLabel.text = self.bookdata.seller_phone;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate* sTime = [dateFormatter dateFromString:self.bookdata.start_time];
    NSInteger duration = [self.bookdata.duration integerValue];
    NSDate* eTime = [sTime dateByAddingTimeInterval:duration*60];
    NSString* endTime = [dateFormatter stringFromDate:eTime];
    self.mTimeLabel.text = [NSString stringWithFormat:@"Today at %@ - %@", self.bookdata.start_time, endTime];
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
    [self gotoProfilePage];
}

- (IBAction)onAddCalendar:(id)sender {
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        NSDateFormatter *inFormatter = [[NSDateFormatter alloc] init];
        [inFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString* today_str = [inFormatter stringFromDate:[NSDate date]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSString* event_time_str = [NSString stringWithFormat:@"%@ %@", today_str, self.bookdata.start_time];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        NSDate* sTime = [dateFormatter dateFromString:event_time_str];
        NSInteger duration = [self.bookdata.duration integerValue];
        NSDate* eTime = [sTime dateByAddingTimeInterval:duration*60];
        
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = @"Massage Appointment";
        event.startDate = sTime;//[NSDate date]; //today
        event.endDate = eTime;//[event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        event.calendar = [store defaultCalendarForNewEvents];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        self.savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
    }];
}

- (IBAction)onCancel:(id)sender {
    NSString* msg = @"There is no refund, are you sure you want to cancel the appointment?";
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Cancel Appointment"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self doCancel];
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel your yes please button action here
                               }];
    
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doCancel{
    [SVProgressHUD showWithStatus:@"Cancelling..."];
    [HttpApi cancelAppointment:self.bookdata.book_id Success:^(NSDictionary* result){
        [SVProgressHUD showSuccessWithStatus:@"This Appointment was cancelled."];
        [self gotoProfilePage];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)gotoProfilePage{
    UProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UProfileVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onPhoneCall:(id)sender {
    NSString *tempNum = [self.bookdata.seller_phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *phoneNumber = [tempNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if([phoneNumber length] == 0) return;
    NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNumber]];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:phoneUrl options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"Open call: %d",success);
                                     }];
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:phoneUrl];
            NSLog(@"Open call: %d",success);
        }
        
        
    }
    else{
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else if ([[UIApplication sharedApplication] canOpenURL:phoneFallbackUrl]) {
            [[UIApplication sharedApplication] openURL:phoneFallbackUrl];
        } else {
            UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }
    }
}
@end
