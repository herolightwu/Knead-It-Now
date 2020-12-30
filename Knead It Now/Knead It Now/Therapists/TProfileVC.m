//
//  TProfileVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/15.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TProfileVC.h"
#import "Config.h"
#import "TZImagePickerController.h"
#import "TOCropViewController.h"
#import "TBusinessInfoVC.h"
#import "TMyAccountVC.h"
#import "TMyReviewsVC.h"
#import "TPaymentVC.h"
#import "TSetAvailabilityVC.h"
#import "TNotificationsVC.h"
#import "TAppointmentDetailVC.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "BookModel.h"

@interface TProfileVC ()<TOCropViewControllerDelegate>{
    
    TOCropViewController *m_cropViewController;
    TZImagePickerController *imagePickerVc;
    NSInteger type;
}
@property(strong, nonatomic) UIImage *selImage;

@end

@implementation TProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processRequestAccept:) name:NOTIFICATION_REQUEST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processFinishAccept:) name:NOTIFICATION_FINISH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processRateAccept:) name:NOTIFICATION_SRATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processRequestAccept:) name:NOTIFICATION_SMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCancelAccept:) name:NOTIFICATION_CANCEL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processFinishAccept:) name:NOTIFICATION_AUTO_CONFIRM object:nil];
    
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mMyImageView.layer;
    [imageLayer setCornerRadius:50];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mAvailView0.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mAvailView1.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mAvailView2.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mAvailView3.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    self.avail_data = [[NSMutableArray alloc] init];
    self.unreadNotiView.hidden = YES;
    type = 0;
    [self setLayout];
    [self retrieveSTPAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)processRequestAccept:(NSNotification*)msg{
    self.unreadNotiView.hidden = NO;
}

- (void)processFinishAccept:(NSNotification*)msg{
    self.unreadNotiView.hidden = NO;
    [self loadData];
}

- (void)processCancelAccept:(NSNotification*)msg{
    [self loadData];
}

- (void)processRateAccept:(NSNotification*)msg{
    self.unreadNotiView.hidden = NO;
    [HttpApi getUserRate:g_user.userId Success:^(NSDictionary* result){
        g_user.rate = result[@"rate"];
        g_user.rate_count = result[@"count"];
    } Fail:^(NSString* errStr){
       
    }];
}

- (void)setLayout{
    
    if(g_loginType == LOGIN_TYPE_SOCIAL){
        [self.mMyImageView sd_setImageWithURL:[NSURL URLWithString:g_user.photo]];
    } else{
        NSString* filename = g_user.photo;
        if([filename length] > 0) {
            NSString* url = [NSString stringWithFormat:@"%@/%@%@", SERVER_URL, PHOTO_BASE_URL, filename];
            [self.mMyImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        } else{
            [self.mMyImageView setImage:[UIImage imageNamed:@"ic_therapist.png"]];
        }
    }
    float rate_val = [g_user.rate floatValue];
    self.mRatingLabel.text = [NSString stringWithFormat:@"%.1f", rate_val];
    self.mNameLabel.text = [NSString stringWithFormat:@"%@ %@", g_user.firstName, g_user.lastName];
     
    if(self.avail_data.count > 0){
        self.mAvailSetView0.hidden = YES;
        BookModel* one = self.avail_data[0];
        self.mTime0.text = one.start_time;
        self.mPeriod0.text = [NSString stringWithFormat:@"%@ minutes", one.duration];
        self.mPrice0.text = [NSString stringWithFormat:@" $ %@", one.cost];
        if([one.status isEqualToString:@"confirmed"]||[one.status isEqualToString:@"finished"]){
            self.mStatusLabel0.hidden = NO;
            self.mStatusLabel0.text = one.status;
        } else{
            self.mStatusLabel0.hidden = YES;
        }
    } else{
        self.mAvailSetView0.hidden = NO;
    }
    if(self.avail_data.count > 1){
        self.mAvailSetView1.hidden = YES;
        BookModel* one = self.avail_data[1];
        self.mTime1.text = one.start_time;
        self.mPeriod1.text = [NSString stringWithFormat:@"%@ minutes", one.duration];
        self.mPrice1.text = [NSString stringWithFormat:@" $ %@", one.cost];
        if([one.status isEqualToString:@"confirmed"]||[one.status isEqualToString:@"finished"]){
            self.mStatusLabel1.hidden = NO;
            self.mStatusLabel1.text = one.status;
        } else{
            self.mStatusLabel1.hidden = YES;
        }
    } else{
        self.mAvailSetView1.hidden = NO;
    }
    if(self.avail_data.count > 2){
        self.mAvailSetView2.hidden = YES;
        BookModel* one = self.avail_data[2];
        self.mTime2.text = one.start_time;
        self.mPeriod2.text = [NSString stringWithFormat:@"%@ minutes", one.duration];
        self.mPrice2.text = [NSString stringWithFormat:@" $ %@", one.cost];
        if([one.status isEqualToString:@"confirmed"]||[one.status isEqualToString:@"finished"]){
            self.mStatusLabel2.hidden = NO;
            self.mStatusLabel2.text = one.status;
        } else{
            self.mStatusLabel2.hidden = YES;
        }
    } else{
        self.mAvailSetView2.hidden = NO;
    }
    if(self.avail_data.count > 3){
        self.mAvailSetView3.hidden = YES;
        BookModel* one = self.avail_data[3];
        self.mTime3.text = one.start_time;
        self.mPeriod3.text = [NSString stringWithFormat:@"%@ minutes", one.duration];
        self.mPrice3.text = [NSString stringWithFormat:@" $ %@", one.cost];
        if([one.status isEqualToString:@"confirmed"]||[one.status isEqualToString:@"finished"]){
            self.mStatusLabel3.hidden = NO;
            self.mStatusLabel3.text = one.status;
        } else{
            self.mStatusLabel3.hidden = YES;
        }
    } else{
        self.mAvailSetView3.hidden = NO;
    }
    
}

- (void)loadData{
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [dateFormatter setDateFormat:@"dd/MM/yyyy"]; //Here we can set the format which we need
    NSString *todayString = [dateFormatter stringFromDate:todayDate];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    [HttpApi getAvailability:g_user.userId Today:todayString Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        self.avail_data = [[NSMutableArray alloc] init];
        NSArray* resp_data = (NSArray*)result;
        for(int i = 0; i < resp_data.count; i++){
            BookModel* one = [[BookModel alloc] initWithDictionary:resp_data[i]];
            [self.avail_data addObject:one];
        }
        [self setLayout];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

- (void)retrieveSTPAccount{
    if([g_user.account_id length] > 0){
        [HttpApi retrieveAccount:g_user.account_id Success:^(NSDictionary* result){
            NSDictionary* tos_accept = result[@"tos_acceptance"];
            NSString* tos_date = tos_accept[@"date"];
            NSDictionary* legal_dic = result[@"legal_entity"];
            NSString* fname_str = legal_dic[@"first_name"];
            if([fname_str isEqual:nil] || [fname_str isEqual:[NSNull null]]){
                type = 1;
            } else{
                type = 0;
            }
            if([tos_date isEqual:nil] || [tos_date isEqual:[NSNull null]]){
                [self updateStripeAccount];
            }
        } Fail:^(NSString* errstr){
            //[SVProgressHUD showErrorWithStatus:errstr];
        }];
    }
}

- (void)updateStripeAccount{
    if([HttpApi updateTOSAcceptance:g_user.account_id FirstName:g_user.firstName LastName:g_user.lastName Dob:g_user.birthday IpAddress:g_user.ip_address Type:type Success:^(NSDictionary* result){
        //[self showAlertDlg:@"Warning!" Msg:@"Account updateing failed!"];
    } Fail:^(NSString* errstr){
        //[self showAlertDlg:@"Warning!" Msg:@"Account updateing failed!"];
    }]){
        
    } else{
        [self showAlertDlg:@"Warning!" Msg:@"Account updateing failed!"];
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

- (IBAction)onNotification:(id)sender {
    self.unreadNotiView.hidden = YES;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    TNotificationsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TNotificationsVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBusinessInfo:(id)sender {
    TBusinessInfoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TBusinessInfoVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onPayment:(id)sender {
    TPaymentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TPaymentVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onMyAccount:(id)sender {
    TMyAccountVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TMyAccountVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onReviews:(id)sender {
    TMyReviewsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TMyReviewsVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onSelectImage:(id)sender {
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
        popPresenter.sourceView = self.mMyImageView;
        popPresenter.sourceRect = self.mMyImageView.bounds;
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)onSetAvail0:(id)sender {
    if([g_user.account_id length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please add payments."];
        return;
    }
    TSetAvailabilityVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TSetAvailabilityVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onSetAvail1:(id)sender {
    if([g_user.account_id length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please add payments."];
        return;
    }
    TSetAvailabilityVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TSetAvailabilityVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onSetAvail2:(id)sender {
    if([g_user.account_id length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please add payments."];
        return;
    }
    TSetAvailabilityVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TSetAvailabilityVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onSetAvail3:(id)sender {
    if([g_user.account_id length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please add payments."];
        return;
    }
    TSetAvailabilityVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TSetAvailabilityVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onAppoint0:(id)sender {
    BookModel* one = self.avail_data[0];
    if(![one.status isEqualToString:@"posted"]){
        TAppointmentDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TAppointmentDetailVC"];
        vc.bookid = one.book_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onAppoint1:(id)sender {
    BookModel* one = self.avail_data[1];
    if(![one.status isEqualToString:@"posted"]){
        TAppointmentDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TAppointmentDetailVC"];
        vc.bookid = one.book_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onAppoint2:(id)sender {
    BookModel* one = self.avail_data[2];
    if(![one.status isEqualToString:@"posted"]){
        TAppointmentDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TAppointmentDetailVC"];
        vc.bookid = one.book_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onAppoint3:(id)sender {
    BookModel* one = self.avail_data[3];
    if(![one.status isEqualToString:@"posted"]){
        TAppointmentDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TAppointmentDetailVC"];
        vc.bookid = one.book_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        self.selImage = image;
        [self uploadPhoto];
        
    }];
}

- (void)uploadPhoto{
    UIImage *small = [Common resizeImage:self.selImage];
    NSData *postData = UIImageJPEGRepresentation(small, 1.0);
    [SVProgressHUD show];
    [HttpApi  uploadPhotoPost:postData UserID:g_user.userId Success:^(NSDictionary *result) {
        [SVProgressHUD dismiss];
        g_user.photo = (NSString*)result;
        [self.mMyImageView setImage:self.selImage];
    } Fail:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
}

- (void)removePhoto{
    [SVProgressHUD show];
    [HttpApi removePhoto:g_user.userId Success:^(NSDictionary *result) {
        [SVProgressHUD dismiss];
        g_user.photo = @"";
        [self.mMyImageView setImage:[UIImage imageNamed:@"ic_therapist.png"]];
    } Fail:^(NSString *strError) {
        [SVProgressHUD showErrorWithStatus:strError];
    }];
    
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
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
