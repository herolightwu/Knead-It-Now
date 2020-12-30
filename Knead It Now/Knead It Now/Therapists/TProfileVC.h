//
//  TProfileVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/15.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mMyImageView;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRatingLabel;
@property (weak, nonatomic) IBOutlet UIView *mAvailView0;
@property (weak, nonatomic) IBOutlet UIView *mAvailSetView0;
@property (weak, nonatomic) IBOutlet UIView *mAvailView1;
@property (weak, nonatomic) IBOutlet UIView *mAvailSetView1;
@property (weak, nonatomic) IBOutlet UIView *mAvailView2;
@property (weak, nonatomic) IBOutlet UIView *mAvailSetView2;
@property (weak, nonatomic) IBOutlet UIView *mAvailView3;
@property (weak, nonatomic) IBOutlet UIView *mAvailSetView3;
@property (weak, nonatomic) IBOutlet UILabel *mTime0;
@property (weak, nonatomic) IBOutlet UILabel *mPeriod0;
@property (weak, nonatomic) IBOutlet UILabel *mPrice0;
@property (weak, nonatomic) IBOutlet UILabel *mTime1;
@property (weak, nonatomic) IBOutlet UILabel *mPeriod1;
@property (weak, nonatomic) IBOutlet UILabel *mPrice1;
@property (weak, nonatomic) IBOutlet UILabel *mTime2;
@property (weak, nonatomic) IBOutlet UILabel *mPeriod2;
@property (weak, nonatomic) IBOutlet UILabel *mPrice2;
@property (weak, nonatomic) IBOutlet UILabel *mTime3;
@property (weak, nonatomic) IBOutlet UILabel *mPeriod3;
@property (weak, nonatomic) IBOutlet UILabel *mPrice3;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel0;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel1;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel2;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel3;
@property (weak, nonatomic) IBOutlet UIView *unreadNotiView;

@property (nonatomic, strong) NSMutableArray* avail_data;


- (IBAction)onNotification:(id)sender;
- (IBAction)onBusinessInfo:(id)sender;
- (IBAction)onPayment:(id)sender;
- (IBAction)onMyAccount:(id)sender;
- (IBAction)onReviews:(id)sender;
- (IBAction)onSelectImage:(id)sender;

- (IBAction)onSetAvail0:(id)sender;
- (IBAction)onSetAvail1:(id)sender;
- (IBAction)onSetAvail2:(id)sender;
- (IBAction)onSetAvail3:(id)sender;

- (IBAction)onAppoint0:(id)sender;
- (IBAction)onAppoint1:(id)sender;
- (IBAction)onAppoint2:(id)sender;
- (IBAction)onAppoint3:(id)sender;


@end
