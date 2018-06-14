//
//  UProfileVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/22.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mUserImg;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRateLabel;

@property (weak, nonatomic) IBOutlet UITableView *mTodayTable;
@property (weak, nonatomic) IBOutlet UITableView *mHistoryTable;
@property (weak, nonatomic) IBOutlet UIView *mAppointView;

@property (nonatomic, strong) NSMutableArray* todaydata;
@property (nonatomic, strong) NSMutableArray* historydata;
@property (nonatomic, strong) NSString* savedEventId;

- (IBAction)onBack:(id)sender;
- (IBAction)onSetting:(id)sender;
- (IBAction)onChoosePhoto:(id)sender;
- (IBAction)onViewReviews:(id)sender;

@end
