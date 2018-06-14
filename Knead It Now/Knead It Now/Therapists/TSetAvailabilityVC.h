//
//  TSetAvailabilityVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSetAvailabilityVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *mStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *mDurationBtn;
@property (weak, nonatomic) IBOutlet UITextField *mRateTxt;
@property (weak, nonatomic) IBOutlet UISwitch *mSwitch;
@property (weak, nonatomic) IBOutlet UITextView *mNoteTxt;
@property (weak, nonatomic) IBOutlet UIButton *mSetBtn;
@property (weak, nonatomic) IBOutlet UIView *mDurationView;

- (IBAction)onBack:(id)sender;
- (IBAction)onSwitch:(id)sender;
- (IBAction)onSet:(id)sender;
- (IBAction)onStartTime:(id)sender;
- (IBAction)onDuration:(id)sender;

@end
