//
//  TAppointmentTVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/17.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAppointmentTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mPastTime;
@property (weak, nonatomic) IBOutlet UIImageView *mUserImage;
@property (weak, nonatomic) IBOutlet UILabel *mBookContent;
@property (weak, nonatomic) IBOutlet UIButton *mConfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *mRejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *mImgBtn;

@end
