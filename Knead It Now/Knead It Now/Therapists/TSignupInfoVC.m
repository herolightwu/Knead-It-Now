//
//  TSignupInfoVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/19.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TSignupInfoVC.h"
#import "TSignupTypeVC.h"
#import "Common.h"
#import "ChooseItemVC.h"
#import "AppDelegate.h"
#import "BusinessModel.h"
#import <LMGeocoder/LMGeocoder.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface TSignupInfoVC ()
{
    NSString* mGender;
    NSString* mParking;
    NSArray* genderArray;
    NSArray* parkingArray;
    BusinessModel* businessInfo;
}
@end

@implementation TSignupInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mGender = @"";
    mParking = @"";
    genderArray = @[@"Male", @"Female"];
    parkingArray = @[@"Free street parking", @"Meter pay street parking", @"Pay lot parking", @"Free lot parking", @"Other or no parking"];
    businessInfo = [[BusinessModel alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mFirstNameTxt.text = self.user.firstName;
    self.mLastNameTxt.text = self.user.lastName;
    mGender = self.user.gender;
    [self.mGenderBtn setTitle:mGender forState:UIControlStateNormal];
    if(self.user.businessInfo != nil){
        businessInfo = self.user.businessInfo;
        self.mBNameTxt.text = businessInfo.bName;
        if([businessInfo.bAddress length] > 0){
            NSArray* add_array = [businessInfo.bAddress componentsSeparatedByString:@","];
            if(add_array[0] != nil){
                self.mBAddressTxt.text = add_array[0];
            }
            if(add_array[1] != nil){
                self.mBCityTxt.text = add_array[1];
            }
            if(add_array[2] != nil){
                self.mBStateTxt.text = add_array[2];
            }
        }
        self.mLicenseTxt.text = businessInfo.bLicense;
        mParking = businessInfo.parking;
        [self.mParkingBtn setTitle:mParking forState:UIControlStateNormal];
        self.mBZipTxt.text = businessInfo.zipcode;
        self.mBPhoneTxt.text = self.user.phone;
        self.mYearTxt.text = businessInfo.activeYear;
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNext:(id)sender {
    if(![self checkValidField]) return;
    
    self.user.firstName = self.mFirstNameTxt.text;
    self.user.lastName = self.mLastNameTxt.text;
    self.user.phone = self.mBPhoneTxt.text;
    self.user.gender = mGender;
    self.user.birthday = self.mDobTxt.text;
    businessInfo.bName = self.mBNameTxt.text;
    businessInfo.bAddress = [NSString stringWithFormat:@"%@,%@,%@", self.mBAddressTxt.text, self.mBCityTxt.text, self.mBStateTxt.text];
    businessInfo.bLicense = self.mLicenseTxt.text;
    businessInfo.zipcode = self.mBZipTxt.text;
    businessInfo.activeYear = self.mYearTxt.text;
    businessInfo.parking = mParking;
    self.user.businessInfo = businessInfo;
    
    NSString* addrStr = [NSString stringWithFormat:@"%@ %@,%@ %@", self.mBAddressTxt.text, self.mBCityTxt.text, self.mBStateTxt.text, self.mBZipTxt.text];
    
    /*[SVProgressHUD showWithStatus:@"Updating..."];
    [[LMGeocoder sharedInstance] geocodeAddressString:addrStr
                                              service:kLMGeocoderGoogleService
                                    completionHandler:^(NSArray *results, NSError *error) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (results.count && !error) {
                                                [SVProgressHUD dismiss];
                                                LMAddress *address = [results firstObject];
                                                self.user.homeLoc = [NSString stringWithFormat:@"%f,%f", address.coordinate.latitude, address.coordinate.longitude];
                                                [self gotoChooseType];
                                            } else{
                                                [SVProgressHUD showErrorWithStatus:@"Address is wrong. Please type again."];
                                            }
                                        });
                                        
                                    }];
    
    CLLocationCoordinate2D m_coord = [self getLocationFromAddressString:addrStr];
    if(m_coord.latitude != 0 && m_coord.longitude != 0){
        self.user.homeLoc = [NSString stringWithFormat:@"%f,%f", m_coord.latitude, m_coord.longitude];
        [self gotoChooseType];
    }*/
    [self getLocationFromAddress:addrStr];
    
}

- (void)gotoChooseType{
    TSignupTypeVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TSignupTypeVC"];
    vc.user = self.user;
    vc.password = self.password;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onGender:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = genderArray;
    //viewC.direction = 1;
    g_nChoose = 0;
    CGPoint point = self.mGenderView.frame.origin;
    point.x+=self.mGenderView.frame.size.width;point.y += (104 + self.mGenderView.frame.size.height);
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        mGender = genderArray[g_nChoose];
        [self.mGenderBtn setTitle:mGender forState:UIControlStateNormal];
    }];
}

- (IBAction)onParking:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = parkingArray;
    viewC.direction = 1;
    g_nChoose = 0;
    CGPoint point = self.mParkingView.frame.origin;
    point.x+=self.mParkingView.frame.size.width;point.y += 104;
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        mParking = parkingArray[g_nChoose];
        [self.mParkingBtn setTitle:mParking forState:UIControlStateNormal];
    }];
}

- (IBAction)onDob:(id)sender {
}

- (BOOL)checkValidField{
    if([self.mFirstNameTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter first name."];
        return false;
    }
    if([self.mLastNameTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter last name."];
        return false;
    }
    
    if([self.mDobTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please select birthday."];
        return false;
    }
    
    NSString* dob_str = self.mDobTxt.text;
    NSArray* foo = [dob_str componentsSeparatedByString:@"/"];
    if(foo.count != 3 || [foo[0] integerValue] > 12 || [foo[1] integerValue] >31 || [foo[2] integerValue] > 2018 || [foo[2] integerValue] < 1950){
        [self showAlertDlg:@"Warning!" Msg:@"Please type birthday correctly."];
        return false;
    }
    
    if([mGender length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please select gender."];
        return false;
    }
    
    if([self.mBNameTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter business name."];
        return false;
    }
    
    if([self.mBAddressTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter business address."];
        return false;
    }
    
    if([self.mBCityTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter business city."];
        return false;
    }
    
    if([self.mBStateTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter business state."];
        return false;
    }
    
    if([self.mBZipTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter business zip."];
        return false;
    }
    
    if([self.mBPhoneTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter business phone number."];
        return false;
    }
    
    if([self.mLicenseTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter Washington State Massage License number."];
        return false;
    }
    
    if([self.mYearTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter year of activation."];
        return false;
    }
    NSInteger year_num = [self.mYearTxt.text integerValue];
    if(year_num < 1900 || year_num > 2050){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter year of activation correctly."];
        return false;
    }
    
    if([mParking length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please select parking."];
        return false;
    }
    return true;
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

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
}

-(void) getLocationFromAddress:(NSString *) addressStr{
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:addressStr completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            [self showAlertDlg:@"Warning!" Msg:@"Please type address correctly."];
            return; // Request failed, log error
        }
        
        // A location was generated, hooray!
        if (placemarks && [placemarks count] > 0) {
            CLPlacemark *placemark = placemarks[0]; // Our placemark
            
            // Do something with the generated placemark
            NSLog(@"Lat: %f, Long: %f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            CLLocationCoordinate2D center;
            center.latitude = placemark.location.coordinate.latitude;
            center.longitude = placemark.location.coordinate.longitude;
            self.user.homeLoc = [NSString stringWithFormat:@"%f,%f", center.latitude, center.longitude];
            [self gotoChooseType];
        }
    }];
}

@end
