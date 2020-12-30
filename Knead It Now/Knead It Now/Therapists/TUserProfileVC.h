//
//  TUserProfileVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/18.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "BookModel.h"

@interface TUserProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mUserImg;
@property (weak, nonatomic) IBOutlet UILabel *mUsername;
@property (weak, nonatomic) IBOutlet UILabel *mRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *mReviewCount;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *mConfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *mRejectBtn;
@property (weak, nonatomic) IBOutlet UILabel *mMassageType;
@property (weak, nonatomic) IBOutlet UILabel *mBookTime;
@property (weak, nonatomic) IBOutlet UILabel *mDuration;
@property (weak, nonatomic) IBOutlet UIView *mBookView;

@property (nonatomic) NSArray* colors;
@property (nonatomic) NSString* userid;
@property (nonatomic) NSString* bookid;
@property (nonatomic, strong) UserModel* user_data;
@property (nonatomic, strong) BookModel* book_data;
@property (nonatomic, strong) NSMutableArray* reviews;

- (IBAction)onBack:(id)sender;
- (IBAction)onConfirm:(id)sender;
- (IBAction)onReject:(id)sender;
@end
