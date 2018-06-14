//
//  TCardDetailVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardModel.h"

@interface TCardDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mCardName;
@property (weak, nonatomic) IBOutlet UILabel *mCardNumber;
@property (weak, nonatomic) IBOutlet UIButton *mDelBtn;
@property (weak, nonatomic) IBOutlet UISwitch *mSwitch;
@property (weak, nonatomic) IBOutlet UIButton *mExpireBtn;
@property (weak, nonatomic) IBOutlet UIView *mSwitchView;

@property (nonatomic, strong) CardModel* carddata;
@property (nonatomic) NSInteger card_count;

- (IBAction)onBack:(id)sender;
- (IBAction)onDelete:(id)sender;
- (IBAction)onSwitch:(id)sender;
- (IBAction)onDone:(id)sender;
- (IBAction)onExpireClick:(id)sender;

@end
