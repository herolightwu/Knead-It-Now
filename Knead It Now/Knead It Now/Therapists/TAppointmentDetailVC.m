//
//  TAppointmentDetailVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/17.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TAppointmentDetailVC.h"
#import "Config.h"
#import "TMessageVC.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppDelegate.h"
#import "HttpApi.h"
#import "UIImageView+WebCache.h"
#import "TUserProfileVC.h"
#import <EventKit/EventKit.h>

@interface TAppointmentDetailVC ()

@end

@implementation TAppointmentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mUserImg.layer;
    [imageLayer setCornerRadius:50];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mAddBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    self.bookdata = [[BookModel alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData{
    [SVProgressHUD show];
    [HttpApi getAppointment:self.bookid Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        self.bookdata = [[BookModel alloc] initWithDictionary:result];
        [self setLayout];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)setLayout{
    NSString* filename = self.bookdata.buyer_photo;
    if([filename length] > 0) {
        NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, filename];
        [self.mUserImg sd_setImageWithURL:[NSURL URLWithString:url]];
    } else{
        [self.mUserImg setImage:[UIImage imageNamed:@"ic_user.png"]];
    }
    self.mUsername.text = self.bookdata.buyer_name;
    self.mRatingLabel.text = [NSString stringWithFormat:@"%.1f", [self.bookdata.buyer_rate floatValue]];
    
    self.mDuration.text = self.bookdata.duration;
    self.mMassageType.text = TYPES_MASSAGES[[self.bookdata.massage_type integerValue] - 1];
    self.mPriceLabel.text = [NSString stringWithFormat:@"$ %@", self.bookdata.cost];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate* sTime = [dateFormatter dateFromString:self.bookdata.start_time];
    NSInteger duration = [self.bookdata.duration integerValue];
    NSDate* eTime = [sTime dateByAddingTimeInterval:duration*60];
    NSString* endTime = [dateFormatter stringFromDate:eTime];
    self.mAppointTime.text = [NSString stringWithFormat:@"Today at %@ - %@", self.bookdata.start_time, endTime];
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

- (IBAction)onMessage:(id)sender {
    if([self.bookdata.status isEqualToString:@"requested"] || [self.bookdata.status isEqualToString:@"confirmed"]){
        TMessageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TMessageVC"];
        vc.bookid = self.bookdata.book_id;
        vc.fromphoto = self.bookdata.buyer_photo;
        vc.fromid = self.bookdata.buyer_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onAddToCalendar:(id)sender {
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

- (IBAction)onUserClick:(id)sender {
    TUserProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TUserProfileVC"];
    vc.userid = self.bookdata.buyer_id;
    vc.bookid = self.bookid;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
