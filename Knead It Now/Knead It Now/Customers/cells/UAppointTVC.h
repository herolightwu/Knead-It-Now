//
//  UAppointTVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UAppointTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mPastTime;
@property (weak, nonatomic) IBOutlet UIImageView *mUserImage;
@property (weak, nonatomic) IBOutlet UILabel *mBookContent;
@property (weak, nonatomic) IBOutlet UIButton *mFinishBtn;
@property (weak, nonatomic) IBOutlet UIButton *mCancelBtn;
@end
