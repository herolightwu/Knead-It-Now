//
//  ForgotVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mEmailTxt;
@property (weak, nonatomic) IBOutlet UIButton *mSubmitBtn;

- (IBAction)onBack:(id)sender;
- (IBAction)onSubmit:(id)sender;

@end
