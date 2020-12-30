//
//  UTherapistProfileVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/20.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "UTherapistProfileVC.h"
#import "Config.h"
#import "UNoteVC.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppDelegate.h"
#import "HttpApi.h"
#import "ReviewModel.h"
#import "UIImageView+WebCache.h"
#import "ULoginVC.h"

@interface UTherapistProfileVC ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL bViewMore;
}
@end

@implementation UTherapistProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mRequestView.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mRequestBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mTherapistImg.layer;
    [imageLayer setCornerRadius:40];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    bViewMore = false;
    self.therapist_reviews = [[NSMutableArray alloc] init];
    [self setlayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadProfiledata];
}

- (void)loadProfiledata{
    if(![self.bookdata.seller_id isEqualToString:@"0"] && [self.bookdata.seller_id length] > 0){
        [SVProgressHUD show];
        [HttpApi getTherapistProfile:self.bookdata.seller_id Success:^(NSDictionary* result){
            [SVProgressHUD dismiss];
            self.therapist_reviews = [[NSMutableArray alloc] init];
            NSString* s_rate = result[@"rate"];
            NSString* s_count = result[@"count"];
            NSString* s_active_year = result[@"active_year"];
            NSString* s_types = result[@"massage_types"];
            NSString* s_parking = result[@"parking"];
            
            NSArray* review_array = [result objectForKey:@"reviews"];
            for(int i=0; i < [review_array count]; i ++){
                ReviewModel* rv = [[ReviewModel alloc] initWithDictionary:review_array[i]];
                [self.therapist_reviews addObject:rv];
            }
            
            [self setFields:s_rate Count:s_count A_year:s_active_year Types:s_types Parking:s_parking];
            bViewMore = false;
            [self.mTableView reloadData];
        } Fail:^(NSString* errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
    }
}

- (void)setlayout{
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
            self.mCity.text = arr_str[0];
        }
        if(arr_str.count > 1){
            self.mAddress.text = arr_str[1];
        }
        if(arr_str.count >2){
            self.mAddress.text = [NSString stringWithFormat:@"%@ %@", arr_str[1], arr_str[2]];
        }
    }
    
    self.mDistance.text = [NSString stringWithFormat:@"%.1f miles away", self.bookdata.distance];
    int ind_val = [self.bookdata.massage_type intValue];
    self.mReqType.text = TYPES_MASSAGES[ind_val-1];
    self.mReqTime.text = self.bookdata.start_time;
    self.mreqDur.text = [NSString stringWithFormat:@"%@ minutes", self.bookdata.duration];
    self.mPriceLabel.text = [NSString stringWithFormat:@"$ %@", self.bookdata.cost];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//Tableview Delegate, DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(self.therapist_reviews.count < 3) return self.therapist_reviews.count;
    if(!bViewMore) return 3;
    else return self.therapist_reviews.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 110;
    if(!bViewMore && indexPath.row == 2) h = 40;
    else if(bViewMore && indexPath.row == self.therapist_reviews.count) h = 40;
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    if(!bViewMore && indexPath.row == 2){
        UITableViewCell* tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_ViewAllCell" forIndexPath:indexPath];
        UILabel* titlelb = [tvc viewWithTag:8];
        titlelb.text = @"View All";
        
        UIButton* viewAllBtn = [tvc viewWithTag:9];
        [viewAllBtn addTarget:self action:@selector(btnViewAllClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell = tvc;
        return cell;
    } else if(bViewMore && indexPath.row == self.therapist_reviews.count){
        UITableViewCell* tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_ViewAllCell" forIndexPath:indexPath];
        UILabel* titlelb = [tvc viewWithTag:8];
        titlelb.text = @"View Less";
        
        UIButton* viewAllBtn = [tvc viewWithTag:9];
        [viewAllBtn addTarget:self action:@selector(btnViewAllClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell = tvc;
        return cell;
    } else{
        UITableViewCell* tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_TherapistProfileCell" forIndexPath:indexPath];
        cell = tvc;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)btnViewAllClicked:(id)sender
{
    bViewMore = !bViewMore;
    [self.mTableView reloadData];
}
//============================

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRequest:(id)sender {
    if(g_bLogin){
        UNoteVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UNoteVC"];
        vc.bookdata = self.bookdata;
        [self.navigationController pushViewController:vc animated:YES];
    } else{
        ULoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ULoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setFields:(NSString *)rate Count:(NSString *)count A_year:(NSString *)a_year Types:(NSString *)types Parking:(NSString *)parking{
    self.mRateLabel.text = [NSString stringWithFormat:@"%.1f", [rate floatValue]];
    NSString* type_str = @"";
    if([types length] > 0){
        NSArray* type_array = [types componentsSeparatedByString:@","];
        for(int i = 0 ; i < [type_array count]; i++){
            NSInteger ind = [type_array[i] intValue];
            if([type_str length] == 0){
                type_str = TYPES_MASSAGES[ind];
            } else{
                type_str = [NSString stringWithFormat:@"%@, %@", type_str, TYPES_MASSAGES[ind]];
            }
        }
        self.mTypeLabel.text = type_str;
    }
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    self.mExperienceLabel.text = [NSString stringWithFormat:@"%ld years", ([components year] - [a_year intValue])];
    self.mParkingLabel.text = parking;
    
    self.mReviewLabel.text = [NSString stringWithFormat:@"%@ Ratings & %ld Reviews", count, [self.therapist_reviews count]];
}
@end
