//
//  TSetAvailabilityVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TSetAvailabilityVC.h"
#import "Config.h"
#import "ChooseDateView.h"
#import "ChooseItemVC.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"

@interface TSetAvailabilityVC ()<ChooseDateViewDelegate>{
    NSArray* durationArray;
    NSInteger nDuration;
    NSString* start_time;
}

@end

@implementation TSetAvailabilityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    durationArray = @[@"30 minutes", @"60 minutes", @"90 minutes", @"120 minutes"];
    CALayer *imageLayer = self.mNoteTxt.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mSetBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayout{
    nDuration = 0;
    [self.mSwitch setOn:false];
    self.mRateTxt.text = @"55";
    start_time = @"01:00 PM";
    [self.mStartBtn setTitle:start_time forState:UIControlStateNormal];
    [self.mDurationBtn setTitle:durationArray[nDuration] forState:UIControlStateNormal];
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

- (IBAction)onSwitch:(id)sender {
}

- (IBAction)onSet:(id)sender {
    NSString* msg = [NSString stringWithFormat:@"Are you sure you want to set availability for today at %@ with %@ duration at $%@ rate?", self.mStartBtn.titleLabel.text, self.mDurationBtn.titleLabel.text, self.mRateTxt.text];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Confirm Availability"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelBtn = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                }];
    UIAlertAction* confirmBtn = [UIAlertAction
                                   actionWithTitle:@"Confirm"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [self postAvailability];
                                   }];
    [alert addAction:cancelBtn];
    [alert addAction:confirmBtn];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}

- (IBAction)onStartTime:(id)sender {
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

- (IBAction)onDuration:(id)sender {
    ChooseItemVC *viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_ChooseItemVC"];
    viewC.data = durationArray;
    //viewC.direction = 1;
    g_nChoose = 0;
    CGPoint point = self.mDurationView.frame.origin;
    point.x+=self.mDurationView.frame.size.width;point.y += (88 + self.mDurationView.frame.size.height);
    [viewC ShowPopover:self ShowAtPoint:point DismissHandler:^{
        nDuration = g_nChoose;
        [self.mDurationBtn setTitle:durationArray[g_nChoose] forState:UIControlStateNormal];
    }];
}

- (void)doneSaveWithChooseDateView:(ChooseDateView *)chooseDateView Option:(NSDate *)option
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm a"];
    start_time = [outputFormatter stringFromDate:option];
    [self.mStartBtn setTitle:start_time forState:UIControlStateNormal];
}

- (void)postAvailability{
    if(![self checkValidField]) return;
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [dateFormatter setDateFormat:@"dd/MM/yyyy"]; //Here we can set the format which we need
    NSString *todayString = [dateFormatter stringFromDate:todayDate];
    NSString *dur_str = [NSString stringWithFormat:@"%ld", (nDuration + 1) * 30];
    NSString *auto_str = @"0";
    if(self.mSwitch.on) auto_str = @"1";
    [SVProgressHUD show];
    [HttpApi setAvailablity:g_user.userId StartDate:todayString StartTime:start_time Duration:dur_str Cost:self.mRateTxt.text AutoConfirm:auto_str Note:self.mNoteTxt.text Success:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } Fail:^(NSString* errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
    
}

- (BOOL)checkValidField{
    if([self.mRateTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter rate."];
        return false;
    }
    
    NSInteger rate_val = [self.mRateTxt.text integerValue];
    if(rate_val < 0 || rate_val > 500){
        [self showAlertDlg:@"Warning!" Msg:@"Please enter rate correctly."];
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
@end
