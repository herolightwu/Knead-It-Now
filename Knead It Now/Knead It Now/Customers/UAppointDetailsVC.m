//
//  UAppointDetailsVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "UAppointDetailsVC.h"
#import "Config.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"
#import "UProfileVC.h"

@interface UAppointDetailsVC ()

@end

@implementation UAppointDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mTherapistImg.layer;
    [imageLayer setCornerRadius:40];
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
    self.mBusinessLabel.text = self.bookdata.bs_name;
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
    self.mMassageType.text = TYPES_MASSAGES[[self.bookdata.massage_type intValue]-1];
    self.mPriceLabel.text = [NSString stringWithFormat:@"$ %@", self.bookdata.cost];
    
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

- (IBAction)onCancel:(id)sender {
    [SVProgressHUD showWithStatus:@"Cancelling..."];
    [HttpApi cancelAppointment:self.bookdata.book_id Success:^(NSDictionary* result){
        [SVProgressHUD showSuccessWithStatus:@"This Appointment was cancelled."];
        [self gotoProfilePage];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)gotoProfilePage{
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.navigationController popToRootViewControllerAnimated:YES];//search page
        UProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UProfileVC"];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
}
@end
