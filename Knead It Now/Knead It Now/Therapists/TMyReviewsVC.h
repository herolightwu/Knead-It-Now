//
//  TMyReviewsVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMyReviewsVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray* reviewlist;

- (IBAction)onBack:(id)sender;

@end
