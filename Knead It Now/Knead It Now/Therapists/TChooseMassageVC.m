//
//  TChooseMassageVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TChooseMassageVC.h"
#import "Config.h"
#import "AppDelegate.h"

@interface TChooseMassageVC ()

@end

@implementation TChooseMassageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initLayout];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayout{
    if(g_userType == USER_CUSTOMER) g_bEditable = YES;
    if(g_bEditable){
        self.mDoneBtn.hidden = NO;
    } else{
        self.mDoneBtn.hidden = YES;
    }
    [self setEditableStatus];
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
    //update process;
    g_massageType = @"";
    if(self.mDeepCheck.on){
        g_massageType = @"1";
    }
    if(self.mSwedCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"2";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,2", g_massageType];
        }
    }
    if(self.mPreCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"3";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,3", g_massageType];
        }
    }
    if(self.mLympCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"4";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,4", g_massageType];
        }
    }
    if(self.mCranCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"5";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,5", g_massageType];
        }
    }
    if(self.mReflCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"6";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,6", g_massageType];
        }
    }
    if(self.mSportCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"7";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,7", g_massageType];
        }
    }
    if(self.mAromCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"8";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,8", g_massageType];
        }
    }
    if(self.mAcupCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"9";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,9", g_massageType];
        }
    }
    if(self.mMyofCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"10";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,10", g_massageType];
        }
    }
    if(self.mReikiCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"11";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,11", g_massageType];
        }
    }
    if(self.mShiaCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"12";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,12", g_massageType];
        }
    }
    if(self.mTrigCheck.on){
        if(g_massageType.length == 0){
            g_massageType = @"13";
        } else{
            g_massageType = [NSString stringWithFormat:@"%@,13", g_massageType];
        }
    }
    
    if(g_massageType.length == 0){
        if(g_userType == USER_CUSTOMER){
            [self showAlertDlg:@"Warning!" Msg:@"Please choose massage type."];
        } else{
            [self showAlertDlg:@"Warning!" Msg:@"Please choose one more massage types."];
        }
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)onDeepClick:(id)sender {
    BOOL bcheck = self.mDeepCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mDeepCheck.on = !bcheck;
}

- (IBAction)onSwedClick:(id)sender {
    BOOL bcheck = self.mSwedCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mSwedCheck.on = !bcheck;
}

- (IBAction)onPreClick:(id)sender {
    BOOL bcheck = self.mPreCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mPreCheck.on = !bcheck;
}

- (IBAction)onLympClick:(id)sender {
    BOOL bcheck = self.mLympCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mLympCheck.on = !bcheck;
}

- (IBAction)onCranClick:(id)sender {
    BOOL bcheck = self.mCranCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mCranCheck.on = !bcheck;
}

- (IBAction)onReflClick:(id)sender {
    BOOL bcheck = self.mReflCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mReflCheck.on = !bcheck;
}

- (IBAction)onSportClick:(id)sender {
    BOOL bcheck = self.mSportCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mSportCheck.on = !bcheck;
}

- (IBAction)onAromClick:(id)sender {
    BOOL bcheck = self.mAromCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mAromCheck.on = !bcheck;
}

- (IBAction)onAcupClick:(id)sender {
    BOOL bcheck = self.mAcupCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mAcupCheck.on = !bcheck;
}

- (IBAction)onMyofClick:(id)sender {
    BOOL bcheck = self.mMyofCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mMyofCheck.on = !bcheck;
}

- (IBAction)onReikiClick:(id)sender {
    BOOL bcheck = self.mReikiCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mReikiCheck.on = !bcheck;
}

- (IBAction)onShiaClick:(id)sender {
    BOOL bcheck = self.mShiaCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mShiaCheck.on = !bcheck;
}

- (IBAction)onTrigClick:(id)sender {
    BOOL bcheck = self.mTrigCheck.on;
    if(g_userType == USER_CUSTOMER)
        [self initAllCheckStatus];
    self.mTrigCheck.on = !bcheck;
}

- (void)setEditableStatus{
    self.mDeepBtn.enabled = g_bEditable;
    self.mSwedBtn.enabled = g_bEditable;
    self.mPreBtn.enabled = g_bEditable;
    self.mLympBtn.enabled = g_bEditable;
    self.mCranBtn.enabled = g_bEditable;
    self.mReflBtn.enabled = g_bEditable;
    self.mSportBtn.enabled = g_bEditable;
    self.mAromBtn.enabled = g_bEditable;
    self.mAcuBtn.enabled = g_bEditable;
    self.mMyoBtn.enabled = g_bEditable;
    self.mReikiBtn.enabled = g_bEditable;
    self.mShiaBtn.enabled = g_bEditable;
    self.mTrigBtn.enabled = g_bEditable;
}

- (void)initAllCheckStatus{
    self.mDeepCheck.on = false;
    self.mSwedCheck.on = false;
    self.mPreCheck.on = false;
    self.mLympCheck.on = false;
    self.mCranCheck.on = false;
    self.mReflCheck.on = false;
    self.mSportCheck.on = false;
    self.mAromCheck.on = false;
    self.mAcupCheck.on = false;
    self.mMyofCheck.on = false;
    self.mReikiCheck.on = false;
    self.mShiaCheck.on = false;
    self.mTrigCheck.on = false;
}

- (void)initLayout{
    self.mDeepCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mDeepView addSubview:self.mDeepCheck];
    self.mDeepCheck.on = NO;
    //self.mCheckBox.onFillColor = YELLOW_COLOR;
    self.mDeepCheck.onTintColor = WHITE_COLOR;
    self.mDeepCheck.tintColor = WHITE_COLOR;
    self.mDeepCheck.onCheckColor = PRIMARY_COLOR;
    //UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check0:)];
    //[self.mCheckBox0 addGestureRecognizer:singleFingerTap];
    self.mDeepCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mDeepCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mDeepCheck.boxType = BEMBoxTypeSquare;
    
    self.mSwedCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mSwedView addSubview:self.mSwedCheck];
    self.mSwedCheck.on = NO;
    self.mSwedCheck.onTintColor = WHITE_COLOR;
    self.mSwedCheck.tintColor = WHITE_COLOR;
    self.mSwedCheck.onCheckColor = PRIMARY_COLOR;
    self.mSwedCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mSwedCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mSwedCheck.boxType = BEMBoxTypeSquare;
    
    self.mPreCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mPreView addSubview:self.mPreCheck];
    self.mPreCheck.on = NO;
    self.mPreCheck.onTintColor = WHITE_COLOR;
    self.mPreCheck.tintColor = WHITE_COLOR;
    self.mPreCheck.onCheckColor = PRIMARY_COLOR;
    self.mPreCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mPreCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mPreCheck.boxType = BEMBoxTypeSquare;
    
    self.mLympCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mLympView addSubview:self.mLympCheck];
    self.mLympCheck.on = NO;
    self.mLympCheck.onTintColor = WHITE_COLOR;
    self.mLympCheck.tintColor = WHITE_COLOR;
    self.mLympCheck.onCheckColor = PRIMARY_COLOR;
    self.mLympCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mLympCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mLympCheck.boxType = BEMBoxTypeSquare;
    
    self.mCranCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mCranView addSubview:self.mCranCheck];
    self.mCranCheck.on = NO;
    self.mCranCheck.onTintColor = WHITE_COLOR;
    self.mCranCheck.tintColor = WHITE_COLOR;
    self.mCranCheck.onCheckColor = PRIMARY_COLOR;
    self.mCranCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mCranCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mCranCheck.boxType = BEMBoxTypeSquare;
    
    self.mReflCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mReflView addSubview:self.mReflCheck];
    self.mReflCheck.on = NO;
    self.mReflCheck.onTintColor = WHITE_COLOR;
    self.mReflCheck.tintColor = WHITE_COLOR;
    self.mReflCheck.onCheckColor = PRIMARY_COLOR;
    self.mReflCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mReflCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mReflCheck.boxType = BEMBoxTypeSquare;
    
    self.mSportCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mSportView addSubview:self.mSportCheck];
    self.mSportCheck.on = NO;
    self.mSportCheck.onTintColor = WHITE_COLOR;
    self.mSportCheck.tintColor = WHITE_COLOR;
    self.mSportCheck.onCheckColor = PRIMARY_COLOR;
    self.mSportCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mSportCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mSportCheck.boxType = BEMBoxTypeSquare;
    
    self.mAromCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mAromView addSubview:self.mAromCheck];
    self.mAromCheck.on = NO;
    self.mAromCheck.onTintColor = WHITE_COLOR;
    self.mAromCheck.tintColor = WHITE_COLOR;
    self.mAromCheck.onCheckColor = PRIMARY_COLOR;
    self.mAromCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mAromCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mAromCheck.boxType = BEMBoxTypeSquare;
    
    self.mAcupCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mAcupView addSubview:self.mAcupCheck];
    self.mAcupCheck.on = NO;
    self.mAcupCheck.onTintColor = WHITE_COLOR;
    self.mAcupCheck.tintColor = WHITE_COLOR;
    self.mAcupCheck.onCheckColor = PRIMARY_COLOR;
    self.mAcupCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mAcupCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mAcupCheck.boxType = BEMBoxTypeSquare;
    
    self.mMyofCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mMyofView addSubview:self.mMyofCheck];
    self.mMyofCheck.on = NO;
    self.mMyofCheck.onTintColor = WHITE_COLOR;
    self.mMyofCheck.tintColor = WHITE_COLOR;
    self.mMyofCheck.onCheckColor = PRIMARY_COLOR;
    self.mMyofCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mMyofCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mMyofCheck.boxType = BEMBoxTypeSquare;
    
    self.mReikiCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mReikiView addSubview:self.mReikiCheck];
    self.mReikiCheck.on = NO;
    self.mReikiCheck.onTintColor = WHITE_COLOR;
    self.mReikiCheck.tintColor = WHITE_COLOR;
    self.mReikiCheck.onCheckColor = PRIMARY_COLOR;
    self.mReikiCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mReikiCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mReikiCheck.boxType = BEMBoxTypeSquare;
    
    self.mShiaCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mShiaView addSubview:self.mShiaCheck];
    self.mShiaCheck.on = NO;
    self.mShiaCheck.onTintColor = WHITE_COLOR;
    self.mShiaCheck.tintColor = WHITE_COLOR;
    self.mShiaCheck.onCheckColor = PRIMARY_COLOR;
    self.mShiaCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mShiaCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mShiaCheck.boxType = BEMBoxTypeSquare;
    
    self.mTrigCheck = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.mTrigView addSubview:self.mTrigCheck];
    self.mTrigCheck.on = NO;
    self.mTrigCheck.onTintColor = WHITE_COLOR;
    self.mTrigCheck.tintColor = WHITE_COLOR;
    self.mTrigCheck.onCheckColor = PRIMARY_COLOR;
    self.mTrigCheck.onAnimationType = BEMAnimationTypeBounce;
    self.mTrigCheck.offAnimationType = BEMAnimationTypeBounce;
    self.mTrigCheck.boxType = BEMBoxTypeSquare;
    
    NSArray* valTypes = [g_massageType componentsSeparatedByString:@","];
    for(int i = 0 ; i < [valTypes count]; i++){
        NSInteger ival = [valTypes[i] integerValue];
        switch (ival) {
            case 1:
                self.mDeepCheck.on = YES;
                break;
            case 2:
                self.mSwedCheck.on = YES;
                break;
            case 3:
                self.mPreCheck.on = YES;
                break;
            case 4:
                self.mLympCheck.on = YES;
                break;
            case 5:
                self.mCranCheck.on = YES;
                break;
            case 6:
                self.mReflCheck.on = YES;
                break;
            case 7:
                self.mSportCheck.on = YES;
                break;
            case 8:
                self.mAromCheck.on = YES;
                break;
            case 9:
                self.mAcupCheck.on = YES;
                break;
            case 10:
                self.mMyofCheck.on = YES;
                break;
            case 11:
                self.mReikiCheck.on = YES;
                break;
            case 12:
                self.mShiaCheck.on = YES;
                break;
            case 13:
                self.mTrigCheck.on = YES;
                break;
                
            default:
                break;
        }
    }
    
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
