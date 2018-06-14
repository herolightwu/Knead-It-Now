//
//  UPaymentVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface UPaymentVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mAlertLabel;
@property (weak, nonatomic) IBOutlet UILabel *mDuration;
@property (weak, nonatomic) IBOutlet UILabel *mMassageType;
@property (weak, nonatomic) IBOutlet UILabel *mPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *mPayBtn;

@property (nonatomic, strong) NSString* book_id;
@property (nonatomic, strong) NSString* event_id;
@property (nonatomic, strong) NSString* event_time;
@property (nonatomic, strong) NSString* destination_id;
@property (nonatomic, strong) BookModel* bookdata;
@property (nonatomic, strong) NSMutableArray* cardArray;
@property (nonatomic, strong) NSString* charge_id;
@property (nonatomic, strong) NSString* charge_status;

- (IBAction)onBack:(id)sender;
- (IBAction)onPay:(id)sender;
- (IBAction)onMessage:(id)sender;

@end
