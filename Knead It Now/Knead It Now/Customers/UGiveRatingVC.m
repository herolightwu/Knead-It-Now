//
//  UGiveRatingVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/22.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "UGiveRatingVC.h"
#import "Config.h"
#import "AppDelegate.h"
#import "HttpApi.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIImageView+WebCache.h"

@interface UGiveRatingVC ()
{
    NSString* reviewStr;
}
@end

@implementation UGiveRatingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mTherapistImg.layer;
    [imageLayer setCornerRadius:40];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mPostBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mReportBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mPostView.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    // Initialization code
    self.colors = @[ [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0f], [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f], [UIColor colorWithRed:0.1f green:1.0f blue:0.1f alpha:1.0f]];
    // Setup control using iOS7 tint Color
    self.mRatingBar.backgroundColor  = self.colors[1];//[UIColor whiteColor];
    self.mRatingBar.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRatingBar.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRatingBar.maxRating = 5.0;
    self.mRatingBar.delegate = (id)self;
    self.mRatingBar.horizontalMargin = 2.0;
    self.mRatingBar.editable=YES;
    float rating = 5.0f;
    self.mRatingBar.rating= rating;
    self.mRatingBar.displayMode=EDStarRatingDisplayAccurate;
    [self.mRatingBar  setNeedsDisplay];
    self.mRatingBar.tintColor = self.colors[0];
    
    reviewStr = @"";
    self.mReportBtn.hidden = YES;
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
    NSString* filename = self.bookdata.seller_photo;
    if([filename length] > 0) {
        NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, filename];
        [self.mTherapistImg sd_setImageWithURL:[NSURL URLWithString:url]];
    } else{
        [self.mTherapistImg setImage:[UIImage imageNamed:@"ic_user.png"]];
    }
    self.mNameLabel.text = self.bookdata.seller_name;
    self.mRateLabel.text = [NSString stringWithFormat:@"%.1f", [self.bookdata.seller_rate floatValue]];
    self.mBusiness.text = self.bookdata.bs_name;
    
    self.mDuration.text = self.bookdata.duration;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPost:(id)sender {
    reviewStr = self.mReviewTxt.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString* postdate = [dateFormatter stringFromDate:[NSDate date]];
    NSString* rate = [NSString stringWithFormat:@"%.1f", self.mRatingBar.rating];
    [SVProgressHUD showWithStatus:@"Posting..."];
    [HttpApi reportReview:self.bookdata.seller_id FormId:g_user.userId Rate:rate BookId:self.bookid Content:reviewStr PostDate:postdate Success:^(NSDictionary *result){
        [SVProgressHUD showSuccessWithStatus:@"Your review reported to user."];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (IBAction)onReport:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
