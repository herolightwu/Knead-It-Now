//
//  TUserProfileVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/18.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TUserProfileVC.h"
#import "Config.h"
#import "EDStarRating.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"
#import "ReviewModel.h"
#import "UIImageView+WebCache.h"

@interface TUserProfileVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TUserProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mBookView.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mConfirmBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mRejectBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mUserImg.layer;
    [imageLayer setCornerRadius:50];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    // Initialization code
    self.colors = @[ [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0f], [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f], [UIColor colorWithRed:0.1f green:1.0f blue:0.1f alpha:1.0f]];
    
    self.reviews = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadProfile];
}

- (void)loadProfile{
    [SVProgressHUD show];
    [HttpApi getUserProfile:self.userid BookId:self.bookid Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        self.user_data = [[UserModel alloc] initWithDictionary:result[@"user"]];
        self.book_data = [[BookModel alloc] initWithDictionary:result[@"book"]];
        self.reviews = [[NSMutableArray alloc] init];
        NSArray* rv_array = result[@"reviews"];
        for(int i = 0; i < rv_array.count; i++){
            ReviewModel* one = [[ReviewModel alloc] initWithDictionary:rv_array[i]];
            [self.reviews addObject:one];
        }
        [self setLayout];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)setLayout{
    NSString* filename = self.user_data.photo;
    if([filename length] > 0) {
        NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, filename];
        [self.mUserImg sd_setImageWithURL:[NSURL URLWithString:url]];
    } else{
        [self.mUserImg setImage:[UIImage imageNamed:@"ic_user.png"]];
    }
    
    self.mUsername.text = [NSString stringWithFormat:@"%@ %@", self.user_data.firstName, self.user_data.lastName];
    self.mRatingLabel.text = [NSString stringWithFormat:@"%.1f", [self.user_data.rate floatValue]];
    self.mReviewCount.text = [NSString stringWithFormat:@"%@ Ratings & %ld Reviews", self.user_data.rate_count, self.reviews.count];
    if([self.book_data.status isEqualToString:@"requested"]){
        self.mBookView.hidden = NO;
        self.mMassageType.text = TYPES_MASSAGES[[self.book_data.massage_type integerValue] - 1];
        self.mDuration.text = [NSString stringWithFormat:@"%@ minutes", self.book_data.duration];
        self.mBookTime.text = self.book_data.start_time;
    } else{
        self.mBookView.hidden = YES;
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
    return self.reviews.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 110;
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    if(indexPath.row < [self.reviews count]){
        ReviewModel* one = self.reviews[indexPath.row];
        float rate_val = [one.rate floatValue];
        cell = [tableView dequeueReusableCellWithIdentifier:@"RID_TUserProfileCell" forIndexPath:indexPath];
        EDStarRating* ratingBar = [cell viewWithTag:2];
        // Setup control using iOS7 tint Color
        ratingBar.backgroundColor  = self.colors[1];//[UIColor whiteColor];
        ratingBar.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        ratingBar.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        ratingBar.maxRating = 5.0;
        ratingBar.delegate = (id)self;
        ratingBar.horizontalMargin = 2.0;
        ratingBar.editable=NO;
        ratingBar.rating= rate_val;
        ratingBar.displayMode=EDStarRatingDisplayAccurate;
        [ratingBar  setNeedsDisplay];
        ratingBar.tintColor = self.colors[0];
        
        UILabel* namelb = [cell viewWithTag:1];
        namelb.text = [NSString stringWithFormat:@"%@ %@", one.firstName, one.lastName];
        
        UILabel* timelb = [cell viewWithTag:3];
        //-------------------------------
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd-yyyy"];
        NSDate *startDate = [NSDate date];
        // End date
        NSDate *endDate = [formatter dateFromString:one.postdate];
        NSTimeInterval secondsBetween = [startDate timeIntervalSinceDate:endDate];
        int numberOfDays = secondsBetween / 86400;
        if(numberOfDays < 30){
            timelb.text = [NSString stringWithFormat:@"%ld days ago", (long)numberOfDays];
        } else{
            timelb.text = [NSString stringWithFormat:@"%ld months ago", (long)numberOfDays/30];
        }
        //-------------------------------
        UITextView* contentTv = [cell viewWithTag:4];
        contentTv.text = one.comment;
        
        return cell;
    } else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"RID_EmptyCell" forIndexPath:indexPath];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onConfirm:(id)sender {
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [dateFormatter setDateFormat:@"hh:mm a"]; //Here we can set the format which we need
    NSString *booktime = [dateFormatter stringFromDate:todayDate];
    [SVProgressHUD showWithStatus:@"Confirm Appointment..."];
    [HttpApi confirmAppointment:self.bookid ConfirmTime:booktime Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } Fail:^(NSString *errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (IBAction)onReject:(id)sender {
    [SVProgressHUD showWithStatus:@"Reject Appointment..."];
    [HttpApi rejectAppointment:self.bookid Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];//[self loadEvents];
    } Fail:^(NSString *errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}
@end
