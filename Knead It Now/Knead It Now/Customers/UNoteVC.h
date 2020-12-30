//
//  UNoteVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@interface UNoteVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *mNoteTxt;
@property (weak, nonatomic) IBOutlet UIButton *mWithoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *mIncludeBtn;

@property (nonatomic, strong) BookModel* bookdata;

- (IBAction)onBack:(id)sender;
- (IBAction)onWithout:(id)sender;
- (IBAction)onInclude:(id)sender;

@end
