//
//  ReviewTVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "ReviewTVC.h"

@implementation ReviewTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.colors = @[ [UIColor colorWithRed:1.0f green:0.58f blue:0.0f alpha:1.0f], [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f], [UIColor colorWithRed:0.1f green:1.0f blue:0.1f alpha:1.0f]];
    // Setup control using iOS7 tint Color
    self.mRatingBar.backgroundColor  = self.colors[1];//[UIColor whiteColor];
    self.mRatingBar.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRatingBar.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.mRatingBar.maxRating = 5.0;
    self.mRatingBar.delegate = (id)self;
    self.mRatingBar.horizontalMargin = 2.0;
    self.mRatingBar.editable=NO;
    float rating = 4.65f;
    self.mRatingBar.rating= rating;
    self.mRatingBar.displayMode=EDStarRatingDisplayAccurate;
    [self.mRatingBar  setNeedsDisplay];
    self.mRatingBar.tintColor = self.colors[0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
