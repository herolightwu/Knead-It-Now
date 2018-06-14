//
//  WelcomeVC.h
//  Book Me Now
//
//  Created by meixiang wu on 2018/6/13.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mTherapistView;
@property (weak, nonatomic) IBOutlet UIView *mUserView;
- (IBAction)onTherapistClick:(id)sender;
- (IBAction)mUserClick:(id)sender;

@end
