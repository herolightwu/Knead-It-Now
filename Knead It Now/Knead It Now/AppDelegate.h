//
//  AppDelegate.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@import GoogleSignIn;

@class AppDelegate;

extern AppDelegate *g_appDelegate;
extern NSInteger g_userType;
extern NSInteger g_nChoose;
extern BOOL g_bEditable;
extern NSString* g_massageType;
extern NSInteger g_loginType;
extern UserModel *g_user;
extern BOOL g_bLogin;

@protocol updateNotifications <NSObject>

-(void)updateNotificationDetails:(NSString *)badgeNumber;
@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) id<updateNotifications> notificationDelegate;

@property (strong, nonatomic) NSString *unreadNotificationsCount;
@end

