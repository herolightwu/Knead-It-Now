//
//  TBusinessInfoVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TBusinessInfoVC.h"
#import "AppDelegate.h"
#import "Config.h"
#import "Common.h"
#import "ChooseItemVC.h"
#import "TChooseMassageVC.h"
#import "BusinessModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"
#import <LMGeocoder/LMGeocoder.h>

@interface TBusinessInfoVC (){
    NSArray* genderArray;
    NSArray* parkingArray;
    NSString* genderStr;
    NSString* parkingStr;
}

@end

@implementation TBusinessInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    genderArray = @[@"Male", @"Female"];
    parkingArray = @[@"Free street parking", @"Meter pay street parking", @"Pay lot parking", @"Free lot parking", @"Other or no parking"];
    g_massageType = g_user.businessInfo.bTypes;
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setLayout];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onEdit:(id)sender {
    if(g_bEditable && [self checkValidField]){
        //update process
        /*UserModel* one = [[UserModel alloc] init];
        one.userId = g_user.userId;
        one.firstName = self.mFirstNameTxt.text;
        one.lastName = self.mLastNameTxt.text;
        one.email = self.mEmailTxt.text;
        one.gender = genderStr;
        one.phone = self.mBPhoneTxt.text;
        BusinessModel* bOne = [[BusinessModel alloc] init];
        bOne.businessId = g_user.businessInfo.businessId;
        bOne.bName = self.mBNameTxt.text;
        bOne.bAddress = [NSString stringWithFormat:@"%@,%@,%@", self.mBAddressTxt.text, self.mBCityTxt.text, self.mBStateTxt.text];
        bOne.zipcode = self.mBZipTxt.text;
        bOne.bLicense = self.mLicenseTxt.text;
        bOne.activeYear = self.mYearTxt.text;
        bOne.parking = parkingStr;
        bOne.bTypes = g_massageType;
        one.businessInfo = bOne;
        
        NSString* addrStr = [NSString stringWithFormat:@"%@,%@,%@ %@", self.mBAddressTxt.text, self.mBCityTxt.text, self.mBStateTxt.text, self.mBZipTxt.text];
        
        [SVProgressHUD showWithStatus:@"Updating..."];*/
        /*[[LMGeocoder sharedInstance] geocodeAddressString:addrStr
                                                  service:kLMGeocoderGoogleService
                                        completionHandler:^(NSArray *results, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (results.count && !error) {
                                                    LMAddress *address = [results firstObject];
                                                    //NSLog(@"Coordinate: (%f, %f)", address.coordinate.latitude, address.coordinate.longitude);
                                                    one.homeLoc = [NSString stringWithFormat:@"%f,%f", address.coordinate.latitude, address.coordinate.longitude];
                                                    [HttpApi updateSellerProfile:one Success:^(NSDictionary *result){
                                                        [SVProgressHUD showSuccessWithStatus:@"Business Info was updated successfully."];
                                                        g_user = [[UserModel alloc] initWithDictionary:result];
                                                        [self setLayout];
                                                    } Fail:^(NSString* errstr){
                                                        [SVProgressHUD showErrorWithStatus:errstr];
                                                    }];
                                                } else{
                                                    [SVProgressHUD showErrorWithStatus:@"Address is wrong. Please type again."];
                                                }
                                            });
                                        }];*/
        
        /*CLLocationCoordinate2D m_coord = [self getLocationFromAddressString:addrStr];
        if(m_coord.latitude != 0 && m_coord.longitude != 0){
            one.homeLoc = [NSString stringWithFormat:@"%f,%f", m_coord.latitude, m_coord.longitude];
            [HttpApi updateSellerProfile:one Success:^(NSDictionary *result){
                [SVProgressHUD showSuccessWithStatus:@"Business Info was updated successfully."];
                g_user = [[UserModel alloc] initWithDictionary:result];
                [self setLayout];
            } Fail:^(NSString* errstr){
                [SVProgressHUD showErrorWithStatus:errstr];
            }];
        } else{
            [SVProgressHUD showErrorWithStatus:@"Address is wrong. Please type again."];
        }*/
        [self getLocationFromAddress];
    }
    g_bEditable = !g_bEditable;
    [self setLayout];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTypeView:(id)sender {
    TChooseMassageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TChooseMassageVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onGender:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = genderArray;
    //viewC.direction = 1;
    g_nChoose = 0;
    CGPoint point = self.mGenderView.frame.origin;
    point.x+=self.mGenderView.frame.size.width;point.y += (64 + self.mGenderView.frame.size.height);
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        genderStr = genderArray[g_nChoose];
        [self.mGenderBtn setTitle:genderStr forState:UIControlStateNormal];
    }];
}

- (IBAction)onParking:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = parkingArray;
    viewC.direction = 1;
    g_nChoose = 0;
    CGPoint point = self.mParkingView.frame.origin;
    point.x+=self.mParkingView.frame.size.width;point.y += 64;
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        parkingStr = parkingArray[g_nChoose];
        [self.mParkingBtn setTitle:parkingStr forState:UIControlStateNormal];
    }];
}

- (void)setLayout{
    [self setEditableStatus];
    if(g_bEditable){
        [self.mEditBtn setTitle:@"Update" forState:UIControlStateNormal];
    } else{
        [self.mEditBtn setTitle:@"Edit" forState:UIControlStateNormal];
    }
    genderStr = g_user.gender;
    parkingStr = g_user.businessInfo.parking;
    
    self.mFirstNameTxt.text = g_user.firstName;
    self.mLastNameTxt.text = g_user.lastName;
    self.mEmailTxt.text = g_user.email;
    [self.mGenderBtn setTitle:genderStr forState:UIControlStateNormal];
    BusinessModel* businessInfo = g_user.businessInfo;
    self.mBNameTxt.text = businessInfo.bName;
    if([businessInfo.bAddress length] > 0){
        NSArray* sAddr = [businessInfo.bAddress componentsSeparatedByString:@","];
        if(sAddr[0] != nil){
            self.mBAddressTxt.text = sAddr[0];
        }
        if(sAddr.count > 1 && sAddr[1] != nil){
            self.mBCityTxt.text = sAddr[1];
        }
        if(sAddr.count > 2 && sAddr[2] != nil){
            self.mBStateTxt.text = sAddr[2];
        }
    }
    self.mBZipTxt.text = businessInfo.zipcode;
    self.mBPhoneTxt.text = g_user.phone;
    self.mLicenseTxt.text = businessInfo.bLicense;
    self.mYearTxt.text = businessInfo.activeYear;
    [self.mParkingBtn setTitle:parkingStr forState:UIControlStateNormal];    
}

- (void)setEditableStatus{
    self.mFirstNameTxt.enabled = g_bEditable;
    self.mLastNameTxt.enabled = g_bEditable;
    self.mEmailTxt.enabled = g_bEditable;
    self.mGenderBtn.enabled = g_bEditable;
    self.mBNameTxt.enabled = g_bEditable;
    self.mBAddressTxt.enabled = g_bEditable;
    self.mBCityTxt.enabled = g_bEditable;
    self.mBStateTxt.enabled = g_bEditable;
    self.mBZipTxt.enabled = g_bEditable;
    self.mBPhoneTxt.enabled = g_bEditable;
    self.mLicenseTxt.enabled = g_bEditable;
    self.mYearTxt.enabled = g_bEditable;
    self.mParkingBtn.enabled = g_bEditable;
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
    
    if([self.mEmailTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email address."];
        return false;
    }
    if(![Common IsValidEmail:self.mEmailTxt.text]){
        [self showAlertDlg:@"Warning!" Msg:@"Please type email address correctly."];
        return false;
    }
    
    if([genderStr length] == 0){
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
    
    if([parkingStr length] == 0){
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
    //NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    //NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
}

-(void) getLocationFromAddress{
    //update process
    UserModel* one = [[UserModel alloc] init];
    one.userId = g_user.userId;
    one.firstName = self.mFirstNameTxt.text;
    one.lastName = self.mLastNameTxt.text;
    one.email = self.mEmailTxt.text;
    one.gender = genderStr;
    one.phone = self.mBPhoneTxt.text;
    BusinessModel* bOne = [[BusinessModel alloc] init];
    bOne.businessId = g_user.businessInfo.businessId;
    bOne.bName = self.mBNameTxt.text;
    bOne.bAddress = [NSString stringWithFormat:@"%@,%@,%@", self.mBAddressTxt.text, self.mBCityTxt.text, self.mBStateTxt.text];
    bOne.zipcode = self.mBZipTxt.text;
    bOne.bLicense = self.mLicenseTxt.text;
    bOne.activeYear = self.mYearTxt.text;
    bOne.parking = parkingStr;
    bOne.bTypes = g_massageType;
    one.businessInfo = bOne;
    
    NSString* addrStr = [NSString stringWithFormat:@"%@ %@,%@ %@", self.mBAddressTxt.text, self.mBCityTxt.text, self.mBStateTxt.text, self.mBZipTxt.text];
    CLGeocoder *geocoder = [CLGeocoder new];
    [SVProgressHUD showWithStatus:@"Updating..."];
    [geocoder geocodeAddressString:addrStr completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            [SVProgressHUD showErrorWithStatus:@"Address is wrong. Please type again."];
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
            one.homeLoc = [NSString stringWithFormat:@"%f,%f", center.latitude, center.longitude];
            [HttpApi updateSellerProfile:one Success:^(NSDictionary *result){
                [SVProgressHUD showSuccessWithStatus:@"Business Info was updated successfully."];
                g_user = [[UserModel alloc] initWithDictionary:result];
                [self setLayout];
            } Fail:^(NSString* errstr){
                [SVProgressHUD showErrorWithStatus:errstr];
            }];
        } else{
            [SVProgressHUD showErrorWithStatus:@"Address is wrong. Please type again."];
        }
    }];
}


@end
