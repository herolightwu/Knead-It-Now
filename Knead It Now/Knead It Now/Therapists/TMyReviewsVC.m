//
//  TMyReviewsVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TMyReviewsVC.h"
#import "ReviewTVC.h"
#import "Config.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"
#import "AppDelegate.h"
#import "ReviewModel.h"

@interface TMyReviewsVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation TMyReviewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    self.reviewlist = [[NSMutableArray alloc] init];
    [SVProgressHUD showWithStatus:@"Loading..."];
    [HttpApi getReviews:g_user.userId Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        NSArray* review_array = result[@"reviews"];
        for(int i = 0; i < [review_array count]; i++){
            NSDictionary* one = review_array[i];
            ReviewModel* one_review = [[ReviewModel alloc] initWithDictionary:one];
            [self.reviewlist addObject:one_review];
            [self.mTableView reloadData];
        }
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
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
    return self.reviewlist.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 128;
    if(indexPath.row == 0) h = 44;
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        UITableViewCell* cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"RID_ReviewHeaderCell" forIndexPath:indexPath];
        UILabel* lbl = [cell viewWithTag:1];
        UILabel* ratelabel = [cell viewWithTag:2];
        lbl.text = [NSString stringWithFormat:@"%@ Ratings & %ld Reviews", g_user.rate_count, self.reviewlist.count];
        ratelabel.text = [NSString stringWithFormat:@"%.1f", [g_user.rate floatValue]];
        return cell;
    } else{
        ReviewTVC* tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_ReviewItemCell" forIndexPath:indexPath];
        ReviewModel* one = self.reviewlist[indexPath.row - 1];
        tvc.mUsername.text = [NSString stringWithFormat:@"%@ %@", one.firstName, one.lastName];
        [tvc.mRatingBar setRating:[one.rate floatValue]];
        tvc.mContent.text = one.comment;
        //-------------------------------
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd-yyyy"];
        NSDate *startDate = [NSDate date];
        // End date
        NSDate *endDate = [formatter dateFromString:one.postdate];
        NSTimeInterval secondsBetween = [startDate timeIntervalSinceDate:endDate];
        int numberOfDays = secondsBetween / 86400;
        if(numberOfDays < 30){
            tvc.mDateAgo.text = [NSString stringWithFormat:@"%ld days ago", (long)numberOfDays];
        } else{
            tvc.mDateAgo.text = [NSString stringWithFormat:@"%ld months ago", (long)numberOfDays/30];
        }
        //-------------------------------
        return tvc;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
