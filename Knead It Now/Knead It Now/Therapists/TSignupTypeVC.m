//
//  TSignupTypeVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "TSignupTypeVC.h"
#import "TSignupPaymentVC.h"
#import "Config.h"
#import "BusinessModel.h"

@interface TSignupTypeVC (){
    NSString* massage_types;
}

@end

@implementation TSignupTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    massage_types = @"";
    [self initLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    BusinessModel* one = self.user.businessInfo;
    if(one.bTypes != nil){
        massage_types = one.bTypes;
        NSArray* type_array = [massage_types componentsSeparatedByString:@","];
        for(int i = 0; i < type_array.count; i++){
            NSInteger ind = [type_array[i] integerValue];
            switch (ind) {
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
    [self configureTypes];
    TSignupPaymentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TSignupPaymentVC"];
    vc.user = self.user;
    vc.password = self.password;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configureTypes{
    massage_types = @"";
    if(self.mDeepCheck.on){
        massage_types = @"1";
    }
    if(self.mSwedCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,2", massage_types];
        } else{
            massage_types = @"2";
        }
    }
    if(self.mPreCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,3", massage_types];
        } else{
            massage_types = @"3";
        }
    }
    if(self.mLympCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,4", massage_types];
        } else{
            massage_types = @"4";
        }
    }
    if(self.mCranCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,5", massage_types];
        } else{
            massage_types = @"5";
        }
    }
    if(self.mReflCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,6", massage_types];
        } else{
            massage_types = @"6";
        }
    }
    if(self.mSportCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,7", massage_types];
        } else{
            massage_types = @"7";
        }
    }
    if(self.mAromCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,8", massage_types];
        } else{
            massage_types = @"8";
        }
    }
    if(self.mAcupCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,9", massage_types];
        } else{
            massage_types = @"9";
        }
    }
    if(self.mMyofCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,10", massage_types];
        } else{
            massage_types = @"10";
        }
    }
    if(self.mReikiCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,11", massage_types];
        } else{
            massage_types = @"11";
        }
    }
    if(self.mShiaCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,12", massage_types];
        } else{
            massage_types = @"12";
        }
    }
    if(self.mTrigCheck.on){
        if([massage_types length] > 0){
            massage_types = [NSString stringWithFormat:@"%@,13", massage_types];
        } else{
            massage_types = @"13";
        }
    }
    self.user.businessInfo.bTypes = massage_types;
}

- (IBAction)onDeepClick:(id)sender {
    BOOL bcheck = self.mDeepCheck.on;
    self.mDeepCheck.on = !bcheck;
}

- (IBAction)onSwedClick:(id)sender {
    BOOL bcheck = self.mSwedCheck.on;
    self.mSwedCheck.on = !bcheck;
}

- (IBAction)onPreClick:(id)sender {
    BOOL bcheck = self.mPreCheck.on;
    self.mPreCheck.on = !bcheck;
}

- (IBAction)onLympClick:(id)sender {
    BOOL bcheck = self.mLympCheck.on;
    self.mLympCheck.on = !bcheck;
}

- (IBAction)onCranClick:(id)sender {
    BOOL bcheck = self.mCranCheck.on;
    self.mCranCheck.on = !bcheck;
}

- (IBAction)onReflClick:(id)sender {
    BOOL bcheck = self.mReflCheck.on;
    self.mReflCheck.on = !bcheck;
}

- (IBAction)onSportClick:(id)sender {
    BOOL bcheck = self.mSportCheck.on;
    self.mSportCheck.on = !bcheck;
}

- (IBAction)onAromClick:(id)sender {
    BOOL bcheck = self.mAromCheck.on;
    self.mAromCheck.on = !bcheck;
}

- (IBAction)onAcupClick:(id)sender {
    BOOL bcheck = self.mAcupCheck.on;
    self.mAcupCheck.on = !bcheck;
}

- (IBAction)onMyofClick:(id)sender {
    BOOL bcheck = self.mMyofCheck.on;
    self.mMyofCheck.on = !bcheck;
}

- (IBAction)onReikiClick:(id)sender {
    BOOL bcheck = self.mReikiCheck.on;
    self.mReikiCheck.on = !bcheck;
}

- (IBAction)onShiaClick:(id)sender {
    BOOL bcheck = self.mShiaCheck.on;
    self.mShiaCheck.on = !bcheck;
}

- (IBAction)onTrigClick:(id)sender {
    BOOL bcheck = self.mTrigCheck.on;
    self.mTrigCheck.on = !bcheck;
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
    
}
@end
