//
//  UNotificationsVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventModel.h"

@interface UNotificationsVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray* events;

- (IBAction)onBack:(id)sender;

@end
