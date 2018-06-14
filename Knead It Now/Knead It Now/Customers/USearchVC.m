//
//  USearchVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/19.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "USearchVC.h"
#import "Config.h"
#import "ChooseDateView.h"
#import "AppDelegate.h"
#import "TChooseMassageVC.h"
#import "LMGeocoder.h"
#import "HNKMapViewController.h"
#import "UResultCell.h"
#import "UTherapistProfileVC.h"
#import "UNoteVC.h"
#import "UNotificationsVC.h"
#import "UProfileVC.h"
#import "AppDelegate.h"
#import "USettingVC.h"
#import "HttpApi.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "BookModel.h"
#import "UIImageView+WebCache.h"
#import "ULoginVC.h"

@interface USearchVC ()<ChooseDateViewDelegate, CLLocationManagerDelegate, HNKMapViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSString* sel_Loc;
    NSString* sel_address;
    NSInteger loc_ind;
    NSInteger dur_ind;
    NSInteger gen_ind;
    NSString *cur_address, *cur_location;
    CLLocationManager *m_locationManager;
    CLLocationCoordinate2D mHomeCoordinate;
}

@end

@implementation USearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processConfirmAccept:) name:NOTIFICATION_CONFIRM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processPaidAccept:) name:NOTIFICATION_PAID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processRateAccept:) name:NOTIFICATION_URATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processAccept:) name:NOTIFICATION_UMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processAccept:) name:NOTIFICATION_REJECT object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processTimeout:) name:NOTIFICATION_TIME_OUT object:nil];
    // Do any additional setup after loading the view.
    g_massageType = @"1";
    loc_ind = 1;
    dur_ind = 0;
    gen_ind = 0;
    cur_location = @"";
    cur_address = @"";
    self.mSearchResultView.hidden = YES;
    self.unreadNotiView.hidden = YES;
    // Start getting current location
    m_locationManager = [[CLLocationManager alloc] init];
    m_locationManager.delegate = self;
    m_locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    m_locationManager.distanceFilter = kCLDistanceFilterNone;//100;
    if([m_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [m_locationManager requestWhenInUseAuthorization];
    }
    [m_locationManager startUpdatingLocation];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mSearchResultView.hidden = YES;
    [self loadData];
}

- (void)processConfirmAccept:(NSNotification*)msg{
    self.unreadNotiView.hidden = NO;
    NSString *bookId = msg.userInfo[@"book_id"];
    //NSString *alertstr = msg.userInfo[@"alert"];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:TIMER_LIMIT_VAL];
    notification.alertTitle = @"Not Paid";
    notification.alertBody = @"You don\'t want pay for this appointment. This appointment is cancelled automatically.";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    notification.userInfo = @{@"notification_id":NOTI_AUTO_CANCEL, @"book_id":bookId};
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)processTimeout:(NSNotification*)msg{
    NSString *bookId = msg.userInfo[@"book_id"];
    [SVProgressHUD showWithStatus:@"Cancelling..."];
    [HttpApi cancelAppointment:bookId Success:^(NSDictionary* result){
        [SVProgressHUD showSuccessWithStatus:@"This Appointment was cancelled."];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)processAccept:(NSNotification*)msg{
    self.unreadNotiView.hidden = NO;
}

- (void)processPaidAccept:(NSNotification*)msg{
    self.unreadNotiView.hidden = NO;
    [self removeLocalNotification];
}

- (void)processRateAccept:(NSNotification*)msg{
    self.unreadNotiView.hidden = NO;
    [HttpApi getUserRate:g_user.userId Success:^(NSDictionary* result){
        g_user.rate = result[@"rate"];
        g_user.rate_count = result[@"count"];
    } Fail:^(NSString* errStr){
        
    }];
}

#pragma mark - LOCATION MANAGER

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    mHomeCoordinate = location.coordinate;
    [m_locationManager stopUpdatingLocation];
    cur_location = [NSString stringWithFormat:@"%f,%f", mHomeCoordinate.latitude, mHomeCoordinate.longitude];
    sel_Loc = cur_location;
    //[self getAddressFromLocation:mHomeCoordinate];
}

- (void)removeLocalNotification{
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        if ([localNotification.alertTitle isEqualToString:@"Not Paid"]) {
            //NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
        }
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
//Tableview Delegate, DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger num = self.searchdata.count;
    //if(num > 3) num = 3;
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int h = 204;
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookModel* one = self.searchdata[indexPath.row];
    UResultCell* tvc = [tableView dequeueReusableCellWithIdentifier:@"RID_UResultCell" forIndexPath:indexPath];
    NSString* filename = one.seller_photo;
    if([filename length] > 0) {
        NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, filename];
        [tvc.mTherapistImg sd_setImageWithURL:[NSURL URLWithString:url]];
    } else{
        [tvc.mTherapistImg setImage:[UIImage imageNamed:@"ic_therapist.png"]];
    }
    tvc.mNameLabel.text = one.seller_name;
    tvc.mBussinessLabel.text = one.bs_name;
    tvc.mDistance.text = [NSString stringWithFormat:@"%.1f miles away", one.distance];
    int ind_val = [one.massage_type intValue];
    tvc.mMassageType.text = TYPES_MASSAGES[ind_val-1];
    tvc.mStartTime.text = one.start_time;
    tvc.mDuration.text = [NSString stringWithFormat:@"%@ minutes", one.duration];
    tvc.mPriceLabel.text = [NSString stringWithFormat:@"$ %@", one.cost];
    tvc.mRateLabel.text = [NSString stringWithFormat:@"%.1f", [one.seller_rate floatValue]];
    
    tvc.mProfileBtn.tag = indexPath.row;
    [tvc.mProfileBtn addTarget:self action:@selector(btnProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
    tvc.mRequestBtn.tag = indexPath.row;
    [tvc.mRequestBtn addTarget:self action:@selector(btnRequestClicked:) forControlEvents:UIControlEventTouchUpInside];
    return tvc;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)btnRequestClicked:(id)sender
{
    //Write a code you want to execute on buttons click event
    if(g_bLogin){
        UIButton* btn = (UIButton*)sender;
        NSInteger index = btn.tag;
        BookModel* one = self.searchdata[index];
        UNoteVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UNoteVC"];
        vc.bookdata = one;
        [self.navigationController pushViewController:vc animated:YES];
    } else{
        ULoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ULoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (IBAction)btnProfileClicked:(id)sender
{
    //if(g_bLogin){
        //Write a code you want to execute on buttons click event
        UIButton* btn = (UIButton*)sender;
        NSInteger index = btn.tag;
        BookModel* one = self.searchdata[index];
        UTherapistProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UTherapistProfileVC"];
        vc.bookdata = one;
        [self.navigationController pushViewController:vc animated:YES];
    /*} else{
        ULoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ULoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }*/
}
//============================
- (IBAction)onProfile:(id)sender {
    if(g_bLogin){
        UProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UProfileVC"];
        [self.navigationController pushViewController:vc animated:YES];
    } else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Notice"
                                      message:@"You have to login or sign up."
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        ULoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ULoginVC"];
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }];
        UIAlertAction* cancelButton = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        [alert addAction:yesButton];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)onNotification:(id)sender {
    if(g_bLogin){
        self.unreadNotiView.hidden = YES;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        UNotificationsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UNotificationsVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onChooseType:(id)sender {
    TChooseMassageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TChooseMassageVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onChooseTime:(id)sender {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    ChooseDateView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseDateView" owner:self options:nil] objectAtIndex:0];
    chooseView.m_alertView = alertView;
    chooseView.delegate = self;
    chooseView.type = 1;
    chooseView.mDate = [NSDate date];
    [chooseView setLayout];
    
    [alertView setContainerView:chooseView];
    [alertView setButtonTitles:nil];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

- (IBAction)onChooseLocation:(id)sender {

    HNKMapViewController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_HNKMapViewController"];
    mVC.mLocation = cur_location;
    mVC.mAddress = cur_address;
    mVC.delegate = self;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onCurrentLocation:(id)sender {
    if([cur_location length] > 0){
        sel_Loc = cur_location;
        loc_ind = 1;
        [self setLayout];
    }
}

- (IBAction)onHomeLocation:(id)sender {
    if(!g_bLogin) return;
    if([g_user.homeAddr length] == 0 || [g_user.homeLoc length] == 0){
        
        UIAlertController * alert = [UIAlertController
                                      alertControllerWithTitle:@"Undefine Address"
                                      message:@"You have to set your home address."
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        USettingVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_USettingVC"];
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        sel_Loc = g_user.homeLoc;
        loc_ind = 2;
        [self setLayout];
    }
}

- (IBAction)onSliderChanged:(id)sender {
    NSInteger value = [self roundValue:self.mSlider.value];
    [self.mSlider setValue:(float)value];
    self.mRateLabel.text = [NSString stringWithFormat:@"$ %ld", value];
}

- (IBAction)onFirstDuration:(id)sender {
    dur_ind = 0;
    [self setLayout];
}

- (IBAction)onSecondDuration:(id)sender {
    dur_ind = 1;
    [self setLayout];
}

- (IBAction)onThirdDuration:(id)sender {
    dur_ind = 2;
    [self setLayout];
}

- (IBAction)onForthDuration:(id)sender {
    dur_ind = 3;
    [self setLayout];
}

- (IBAction)onChooseFemale:(id)sender {
    gen_ind = 0;
    [self setLayout];
}

- (IBAction)onChooseMale:(id)sender {
    gen_ind = 1;
    [self setLayout];
}

- (IBAction)onChooseEither:(id)sender {
    gen_ind = 2;
    [self setLayout];
}

- (IBAction)onSearch:(id)sender {
    if([sel_Loc length] == 0){
        [self showAlertDlg:@"Warning" Msg:@"Please select address correctly."];
        return;
    }
    
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [dateFormatter setDateFormat:@"dd/MM/yyyy"]; //Here we can set the format which we need
    NSString *todayString = [dateFormatter stringFromDate:todayDate];
    
    NSString* stime = [NSString stringWithFormat:@"%@ %@", todayString, self.mTimeBtn.titleLabel.text];
    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
    NSDate* timeDate = [dateFormatter dateFromString:stime];
    NSDate* startDate = [self beforeHourDate:timeDate];
    NSDate* endDate = [self nextHourDate:timeDate];
    
    NSString* duration = [NSString stringWithFormat:@"%d", (int)((dur_ind + 1) * 30)];
    NSString* gender = @"Female";
    if(gen_ind == 1) gender = @"Male";
    else if(gen_ind == 2) gender = @"Either";
    //NSString* cost_str = [NSString stringWithFormat:@"%ld", (long)self.mSlider.value];
    
    [SVProgressHUD showWithStatus:@"Searching..."];
    [HttpApi searchBooks:g_massageType StartDate:todayString Duration:duration Gender:gender Success:^(NSDictionary *result){
        [SVProgressHUD dismiss];
        NSMutableArray* retdata = [[NSMutableArray alloc] init];
        NSArray* retlist = (NSArray*) result;
        for(int i = 0; i < retlist.count; i++){
            BookModel* one = [[BookModel alloc] initWithDictionary:retlist[i]];
            [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
            NSString* onetime = [NSString stringWithFormat:@"%@ %@", todayString, one.start_time];
            NSDate* mydate = [dateFormatter dateFromString:onetime];
            
            NSComparisonResult startCompare = [startDate compare: mydate];
            NSComparisonResult endCompare = [endDate compare: mydate];
            
            if (startCompare != NSOrderedDescending && endCompare == NSOrderedDescending)
            {
                // we are on the right date
                NSTimeInterval secondsBetween = [mydate timeIntervalSinceDate:timeDate];
                
                one.difftime = fabsf((float)secondsBetween/7200);
                one.distance = [self calcDistance:one.bs_location];
                one.buyer_id = g_user.userId;
                one.massage_type = g_massageType;
                [retdata addObject:one];
            }
            
        }
        self.searchdata = [[NSMutableArray alloc] init];
        NSInteger dur_norm = [duration integerValue];
        if(retdata.count > 0){
            if(retdata.count > 1){
                NSArray *sorted = [retdata sortedArrayUsingComparator:^(id obj1, id obj2){
                    if ([obj1 isKindOfClass:[BookModel class]] && [obj2 isKindOfClass:[BookModel class]]) {
                        BookModel *s1 = obj1;
                        BookModel *s2 = obj2;
                        NSInteger dur1 = [s1.duration integerValue];
                        NSInteger dur2 = [s2.duration integerValue];
                        
                        float norm1 = s1.difftime + ((float)dur1-dur_norm)/120 + s1.distance/MAX_DISTANCE;
                        float norm2 = s2.difftime + ((float)dur2-dur_norm)/120 + s2.distance/MAX_DISTANCE;
                        
                        if (norm1 < norm2) {
                            return (NSComparisonResult)NSOrderedAscending;
                        } else if (norm1 > norm2) {
                            return (NSComparisonResult)NSOrderedDescending;
                        } else{
                            return (NSComparisonResult)NSOrderedSame;
                        }
                    }
                    // TODO: default is the same?
                    return (NSComparisonResult)NSOrderedSame;
                }];
                [self.searchdata addObjectsFromArray:sorted];
            } else{
                self.searchdata = retdata;
            }
            self.mSearchResultView.hidden = NO;
            [self.mTableView reloadData];
        } else{
            [self showAlertDlg:@"Notice" Msg:@"There is no matched books"];
        }
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
    
}

- (NSDate*) nextHourDate:(NSDate*)inDate{
    /*NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components: NSEraCalendarUnit|NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate: inDate];
    [comps setHour: [comps hour] + 2]; // Here you may also need to check if it's the last hour of the day
    return [calendar dateFromComponents:comps];*/
    int hoursToAdd = 3600*2;
    NSDate* futureDate = [inDate dateByAddingTimeInterval:hoursToAdd];
    return futureDate;
}

- (NSDate*) beforeHourDate:(NSDate*)inDate{
    int hoursToAdd = -3600*2;
    NSDate* beforeDate = [inDate dateByAddingTimeInterval:hoursToAdd];
    return beforeDate;
}

- (IBAction)onRefine:(id)sender {
    self.mSearchResultView.hidden = YES;
}

- (float)calcDistance:(NSString *)location{
    if([location length] == 0) return MAX_DISTANCE;
    NSArray* foo = [sel_Loc componentsSeparatedByString:@","];
    NSArray* foo1 = [location componentsSeparatedByString:@","];
    CLLocation *OldLocation = [[CLLocation alloc] initWithLatitude:[foo[0] doubleValue] longitude:[foo[1] doubleValue]];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:[foo1[0] doubleValue]longitude:[foo1[1] doubleValue]];
    CLLocationDistance meters = [newLocation distanceFromLocation:OldLocation];
    return (meters/MILE_UNIT_METER);
}

- (int)roundValue:(float)value
{
    //get the remainder of value/interval
    //make sure that the remainder is positive by getting its absolute value
    float tempValue = fabsf(fmodf(value, SLIDER_INTERVAL)); //need to import <math.h>
    
    //if the remainder is greater than or equal to the half of the interval then return the higher interval
    //otherwise, return the lower interval
    if(tempValue >= (SLIDER_INTERVAL / 2.0)){
        return (int)(value - tempValue + SLIDER_INTERVAL);
    }
    else{
        return (int)(value - tempValue);
    }
}

- (void) loadData{
    NSInteger ind_val = [g_massageType integerValue];
    [self.mTypeBtn setTitle:TYPES_MASSAGES[ind_val-1] forState:UIControlStateNormal];
}

- (void)doneSaveWithChooseDateView:(ChooseDateView *)chooseDateView Option:(NSDate *)option
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm a"];
    [self.mTimeBtn setTitle:[outputFormatter stringFromDate:option] forState:UIControlStateNormal];
}

- (void)doneUpdateLocation:(HNKMapViewController *)viewController CurLoc:(NSString *)mLoc CurAddr:(NSString *)mAddr{
    sel_Loc = mLoc;
    sel_address = mAddr;
    loc_ind = 0;
    [self setLayout];
}

- (void)setLayout{
    CALayer *imageLayer = self.mChooseLocBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    if(loc_ind == 0){
        [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    } else{
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    }
    
    imageLayer = self.mCurrentLocBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    if(loc_ind == 1){
        [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    } else{
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    }
    
    imageLayer = self.mHomeLocBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    if(loc_ind == 2){
        [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    } else{
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    }
    
    imageLayer = self.mDurBtn1.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    if(dur_ind == 0){
        [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    } else{
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    }
    
    imageLayer = self.mDurBtn2.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    if(dur_ind == 1){
        [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    } else{
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    }
    
    imageLayer = self.mDurBtn3.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    if(dur_ind == 2){
        [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    } else{
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    }
    
    imageLayer = self.mDurBtn4.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    if(dur_ind == 3){
        [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    } else{
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    }
    
    imageLayer = self.mFemaleBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    if(gen_ind == 0){
        [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    } else{
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    }
    
    imageLayer = self.mMaleBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    if(gen_ind == 1){
        [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    } else{
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    }
    
    imageLayer = self.mEitherBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    if(gen_ind == 2){
        [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
    } else{
        [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    }
    
    imageLayer = self.mSearchBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mRefineBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    [self.mTableView setShowsVerticalScrollIndicator:NO];
    
}

- (void) getAddressFromLocation:(CLLocationCoordinate2D)location {
    /*[[LMGeocoder sharedInstance] reverseGeocodeCoordinate:location
                                                  service:kLMGeocoderGoogleService
                                        completionHandler:^(NSArray *results, NSError *error) {
                                            if (results.count && !error) {
                                                LMAddress *address = [results firstObject];
                                                //NSLog(@"Address: %@", address.formattedAddress);
                                                NSString *locatedAt = [NSString stringWithFormat:@" %@, %@", address.locality, address.country];
                                                self->cur_address = locatedAt;
                                            }
                                        }];*/
    [SVProgressHUD show];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude]; //insert your coordinates
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  if (placemark) {
                      
                      //NSLog(@"placemark %@",placemark);
                      //String to hold address
                      NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                      //NSLog(@"addressDictionary %@", placemark.addressDictionary);
                      
                      //NSLog(@"placemark %@",placemark.region);
                      //NSLog(@"placemark %@",placemark.country);  // Give Country Name
                      //NSLog(@"placemark %@",placemark.locality); // Extract the city name
                      //NSLog(@"location %@",placemark.name);
                      //NSLog(@"location %@",placemark.ocean);
                      //NSLog(@"location %@",placemark.postalCode);
                      //NSLog(@"location %@",placemark.subLocality);
                      
                      //NSLog(@"location %@",placemark.location);
                      //Print the location to console
                      //NSLog(@"I am currently at %@",locatedAt);
                      
                      //NSString *locatedAt = [NSString stringWithFormat:@" %@, %@", address.locality, address.country];
                      self->cur_address = locatedAt;
                      [SVProgressHUD dismiss];
                  }
                  else {
                      [SVProgressHUD dismiss];
                      UIAlertController * alert=   [UIAlertController
                                                    alertControllerWithTitle:@"Warning!"
                                                    message:@"Google can not find address from your location. Please choose nearby location"
                                                    preferredStyle:UIAlertControllerStyleAlert];
                      
                      UIAlertAction* yesButton = [UIAlertAction
                                                  actionWithTitle:@"Ok"
                                                  style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                                                  {
                                                      //Handel your yes please button action here
                                                      
                                                  }];
                      [alert addAction:yesButton];
                      [self presentViewController:alert animated:YES completion:nil];
                  }
              }
     ];
    
}

- (void)showAlertDlg:(NSString*) title Msg:(NSString*)msg{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}
@end
