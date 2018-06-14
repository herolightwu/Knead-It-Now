//
//  TPaymentVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/16.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPaymentVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mCardTable;
@property (weak, nonatomic) IBOutlet UITableView *mHistoryTable;

@property (nonatomic, strong) NSMutableArray* cardArray;
@property (nonatomic, strong) NSMutableArray* payArray;

- (IBAction)onBack:(id)sender;
- (IBAction)onAddCard:(id)sender;

@end
