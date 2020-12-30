//
//  UPaymentCardTVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface UPaymentCardTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mCardNumber;
@property (weak, nonatomic) IBOutlet UIView *mCheckView;
@property (strong, nonatomic) IBOutlet BEMCheckBox* mCheck;
@end
