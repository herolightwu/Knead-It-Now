//
//  TAddCardVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAddCardVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *mCVV;
@property (weak, nonatomic) IBOutlet UITextField *mCardName;
@property (weak, nonatomic) IBOutlet UIButton *mExpireBtn;

@property (nonatomic, strong) NSString* card_token;

- (IBAction)onBack:(id)sender;
- (IBAction)onDone:(id)sender;
- (IBAction)onExpireDate:(id)sender;

@end
