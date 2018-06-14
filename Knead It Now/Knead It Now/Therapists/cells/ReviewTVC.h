//
//  ReviewTVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface ReviewTVC : UITableViewCell

@property (strong, nonatomic) NSArray *colors;

@property (weak, nonatomic) IBOutlet UILabel *mUsername;
@property (weak, nonatomic) IBOutlet EDStarRating *mRatingBar;
@property (weak, nonatomic) IBOutlet UILabel *mDateAgo;
@property (weak, nonatomic) IBOutlet UITextView *mContent;

@end
