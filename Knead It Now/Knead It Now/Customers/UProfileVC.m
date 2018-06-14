//
//  UProfileVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/22.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "UProfileVC.h"
#import "Config.h"
#import "Common.h"
#import "UProfileTodayTVC.h"
#import "UProfileHistoryTVC.h"
#import "UConfirmedVC.h"
#import "TZImagePickerController.h"
#import "TOCropViewController.h"
#import "TMyReviewsVC.h"
#import "USettingVC.h"
#import "AppDelegate.h"
#import "HttpApi.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIImageView+WebCache.h"
#import "BookModel.h"
#import <EventKit/EventKit.h>

@interface UProfileVC ()<UITableViewDelegate, UITableViewDataSource, TOCropViewControllerDelegate>
{
    TOCropViewController *m_cropViewController;
    TZImagePickerController *imagePickerVc;
}
@property(strong, nonatomic) UIImage *selImage;
@end

@implementation UProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mUserImg.layer;
    [imageLayer setCornerRadius:50];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    self.todaydata = [[NSMutableArray alloc] init];
    self.historydata = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    [self setLayout];
}

- (void)setLayout{
    if(g_loginType == LOGIN_TYPE_SOCIAL){
        [self.mUserImg sd_setImageWithURL:[NSURL URLWithString:g_user.photo]];
    } else{
        NSString* filename = g_user.photo;
        if([filename length] > 0) {
            NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, filename];
            [self.mUserImg sd_setImageWithURL:[NSURL URLWithString:url]];
        } else{
            [self.mUserImg setImage:[UIImage imageNamed:@"ic_user.png"]];
        }
    }
    float rate_val = [g_user.rate floatValue];
    self.mRateLabel.text = [NSString stringWithFormat:@"%.1f", rate_val];
    self.mNameLabel.text = [NSString stringWithFormat:@"%@ %@", g_user.firstName, g_user.lastName];
}

- (void)loadData{
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [dateFormatter setDateFormat:@"dd/MM/yyyy"]; //Here we can set the format which we need
    NSString *todayString = [dateFormatter stringFromDate:todayDate];
    [SVProgressHUD showWithStatus:@"Loading history..."];
    [HttpApi getBookHistory:g_user.userId Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        self.todaydata = [[NSMutableArray alloc] init];
        self.historydata = [[NSMutableArray alloc] init];
        NSArray* bookArray = (NSArray*)result;
        for(int i = 0; i < bookArray.count; i++){
            BookModel* one = [[BookModel alloc] initWithDictionary:bookArray[i]];
            if([one.start_date isEqualToString:todayString]){
                [self.todaydata addObject:one];
            } else{
                [self.historydata addObject:one];
            }
        }
        [self.mTodayTable reloadData];
        [self.mHistoryTable reloadData];
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
//TableView delegate, datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger row = 0;
    if(tableView == self.mTodayTable) row = self.todaydata.count;
    else if(tableView == self.mHistoryTable) row = self.historydata.count;
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 204; // type = 4
    if(tableView == self.mTodayTable) h = 204;//type = 1
    else if(tableView == self.mHistoryTable) h = 160;// type = 2
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    if(tableView == self.mTodayTable){
        BookModel* one = self.todaydata[indexPath.row];
        UProfileTodayTVC *tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_UProfileTodayTVC" forIndexPath:indexPath];
        NSString* filename = one.seller_photo;
        if([filename length] > 0) {
            NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, filename];
            [tvc.mUserImg sd_setImageWithURL:[NSURL URLWithString:url]];
        } else{
            [tvc.mUserImg setImage:[UIImage imageNamed:@"ic_therapist.png"]];
        }
        tvc.mNameLabel.text = one.seller_name;
        tvc.mBusiness.text = one.bs_name;
        tvc.mRateLabel.text = [NSString stringWithFormat:@"%.1f", [one.seller_rate floatValue]];
        float dist = [self calcDistance:one.bs_location];
        if(dist == MAX_DISTANCE){
            tvc.mDistance.text = @"Unknown";
        } else{
            tvc.mDistance.text = [NSString stringWithFormat:@"%.1f miles away", dist];
        }
        tvc.mMassageType.text = TYPES_MASSAGES[[one.massage_type intValue] - 1];
        tvc.mStartTime.text = one.start_time;
        tvc.mPriceLabel.text = [NSString stringWithFormat:@"$ %@", one.cost];
        tvc.mDuration.text = [NSString stringWithFormat:@"%@ minutes", one.duration];
        
        tvc.mDetailBtn.tag = indexPath.row;
        [tvc.mDetailBtn addTarget:self
                           action:@selector(tapDetailClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        tvc.mAddBtn.tag = indexPath.row;
        [tvc.mAddBtn addTarget:self
                           action:@selector(tapAddClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        cell = tvc;
        return cell;
    } else if(tableView == self.mHistoryTable){
        BookModel* other = self.historydata[indexPath.row];
        UProfileHistoryTVC *tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_UProfileHistoryTVC" forIndexPath:indexPath];
        NSString* filename = other.seller_photo;
        if([filename length] > 0) {
            NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, filename];
            [tvc.mUserImg sd_setImageWithURL:[NSURL URLWithString:url]];
        } else{
            [tvc.mUserImg setImage:[UIImage imageNamed:@"ic_therapist.png"]];
        }
        
        tvc.mNameLabel.text = other.seller_name;
        tvc.mRateLabel.text = [NSString stringWithFormat:@"%.1f", [other.seller_rate floatValue]];
        tvc.mBusiness.text = other.bs_name;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
        [dateFormatter setDateFormat:@"dd/MM/yyyy"]; //Here we can set the format which we need
        NSDate* sdate = [dateFormatter dateFromString:other.start_date];
        [dateFormatter setDateFormat:@"MMMM dd"];
        NSString* str_date = [dateFormatter stringFromDate:sdate];
        tvc.mDateLabel.text = str_date;
        tvc.mTypeLabel.text = TYPES_MASSAGES[[other.massage_type intValue] - 1];
        tvc.mDuration.text = [NSString stringWithFormat:@"%@ minutes", other.duration];
        tvc.mTimeLabel.text = other.start_time;
        tvc.mPriceLabel.text = [NSString stringWithFormat:@"$ %@", other.cost];
        
        cell = tvc;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//================================

- (IBAction)onBack:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onSetting:(id)sender {
    USettingVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_USettingVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onChoosePhoto:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Profile Photo"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Current Photo"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self removePhoto];
                                                           }]; // 2
    UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:@"Choose Photo"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
                                                               
                                                               // You can get the photos by block, the same as by delegate.
                                                               // 你可以通过block或者代理，来得到用户选择的照片.
                                                               [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                                                                   //[self.mMyImageView setImage:photos[0]];
                                                                   m_cropViewController = [[TOCropViewController alloc] initWithImage:photos[0]];
                                                                   m_cropViewController.delegate = self;
                                                                   m_cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
                                                                   m_cropViewController.customAspectRatio = CGSizeMake(200, 200);
                                                                   
                                                                   m_cropViewController.rotateClockwiseButtonHidden = YES;
                                                                   m_cropViewController.rotateButtonsHidden = YES;
                                                                   m_cropViewController.aspectRatioLockEnabled = YES;
                                                                   m_cropViewController.resetAspectRatioEnabled = NO;
                                                                   [self presentViewController:m_cropViewController animated:YES completion:nil];
                                                               }];
                                                               
                                                               [self presentViewController:imagePickerVc animated:YES completion:nil];
                                                           }]; // 3
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               
                                                           }]; // 2
    
    [alert addAction:removeAction]; // 4
    [alert addAction:chooseAction]; // 5
    [alert addAction:cancelAction];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
     {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
     
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = self.mUserImg;
        popPresenter.sourceRect = self.mUserImg.bounds;
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
     }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onViewReviews:(id)sender {
    TMyReviewsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TMyReviewsVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tapDetailClick:(id)sender{
    UIButton* btn = (UIButton*)sender;
    BookModel* one = self.todaydata[btn.tag];
    UConfirmedVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UConfirmedVC"];
    vc.bookdata = one;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tapAddClick:(id)sender{
    UIButton* btn = (UIButton*)sender;
    BookModel* one = self.todaydata[btn.tag];
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        NSDateFormatter *inFormatter = [[NSDateFormatter alloc] init];
        [inFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString* today_str = [inFormatter stringFromDate:[NSDate date]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSString* event_time_str = [NSString stringWithFormat:@"%@ %@", today_str, one.start_time];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        NSDate* sTime = [dateFormatter dateFromString:event_time_str];
        NSInteger duration = [one.duration integerValue];
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

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        self.selImage = image;
        [self uploadPhoto];
    }];
    
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)uploadPhoto{
    UIImage *small = [Common resizeImage:self.selImage];
    NSData *postData = UIImageJPEGRepresentation(small, 1.0);
    [SVProgressHUD show];
    [HttpApi  uploadPhotoPost:postData UserID:g_user.userId Success:^(NSDictionary *result) {
        [SVProgressHUD dismiss];
        g_user.photo = (NSString*)result;
        [self.mUserImg setImage:self.selImage];
    } Fail:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}

- (void)removePhoto{
    [SVProgressHUD show];
    [HttpApi removePhoto:g_user.userId Success:^(NSDictionary *result) {
        [SVProgressHUD dismiss];
        g_user.photo = @"";
        [self.mUserImg setImage:[UIImage imageNamed:@"ic_user.png"]];
    } Fail:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
    
}

- (float)calcDistance:(NSString *)location{
    if([location length] == 0 || [g_user.homeLoc length] == 0) return MAX_DISTANCE;
    NSArray* foo = [g_user.homeLoc componentsSeparatedByString:@","];
    NSArray* foo1 = [location componentsSeparatedByString:@","];
    CLLocation *OldLocation = [[CLLocation alloc] initWithLatitude:[foo[0] doubleValue] longitude:[foo[1] doubleValue]];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:[foo1[0] doubleValue]longitude:[foo1[1] doubleValue]];
    CLLocationDistance meters = [newLocation distanceFromLocation:OldLocation];
    return (meters/MILE_UNIT_METER);
}

@end
