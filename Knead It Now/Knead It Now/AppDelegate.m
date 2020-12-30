//
//  AppDelegate.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/14.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import <OneSignal/OneSignal.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "HttpApi.h"

@interface AppDelegate ()

@end


AppDelegate *g_appDelegate;
NSInteger g_userType;
NSInteger g_nChoose;
BOOL g_bEditable;
NSString* g_massageType;
NSInteger g_loginType;
UserModel *g_user;
BOOL g_bLogin;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    g_appDelegate = self;
    g_userType = USER_THERAPIST;
    g_massageType = @"";
    g_user = nil;
    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey:GOOGLE_API_KEY];
    //google sign in
    [GIDSignIn sharedInstance].clientID = GOOGLE_YOUR_CLIENT_ID;
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //facebook signin
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //Notification setting
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    // One Signal
    
    // (Optional) - Create block the will fire when a notification is recieved while the app is in focus.
    id notificationRecievedBlock = ^(OSNotification *notification) {
        OSNotificationPayload* payload = notification.payload;
        NSString *noti_id = payload.additionalData[@"notification_id"];
        NSString *alert_str = payload.additionalData[@"alert"];
        
        if([noti_id isEqualToString:NOTI_REQUEST] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REQUEST object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_CONFIRM]){
            NSString *bookId = payload.additionalData[@"book_id"];
            NSDictionary *info = @{@"id":noti_id, @"alert":alert_str, @"book_id":bookId};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONFIRM object:self userInfo:info];
        } else if([noti_id isEqualToString:NOTI_PAID] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAID object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_FINISH] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINISH object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_USER_RATE] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_URATE object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_SELLER_RATE] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SRATE object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_USER_MESSAGE]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UMESSAGE object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_SELLER_MESSAGE]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SMESSAGE object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_REJECT]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REJECT object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_CANCEL]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CANCEL object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_AUTO_CONFIRM]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AUTO_CONFIRM object:self userInfo:nil];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STATUS object:self userInfo:nil];
        
    };
    
    // (Optional) - Create block that will fire when a notification is tapped on.
    id notificationOpenedBlock = ^(OSNotificationOpenedResult *result) {
        OSNotificationPayload* payload = result.notification.payload;
        
        NSString *noti_id = payload.additionalData[@"notification_id"];
        NSString *alert_str = payload.additionalData[@"alert"];
        
        if([noti_id isEqualToString:NOTI_REQUEST] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REQUEST object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_CONFIRM]){
            NSString *bookId = payload.additionalData[@"book_id"];
            NSDictionary *info = @{@"id":noti_id, @"alert":alert_str, @"book_id":bookId};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONFIRM object:self userInfo:info];
        } else if([noti_id isEqualToString:NOTI_PAID] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAID object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_FINISH] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINISH object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_USER_RATE] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_URATE object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_SELLER_RATE] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SRATE object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_USER_MESSAGE]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UMESSAGE object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_SELLER_MESSAGE]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SMESSAGE object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_REJECT]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REJECT object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_CANCEL]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CANCEL object:self userInfo:nil];
        } else if([noti_id isEqualToString:NOTI_AUTO_CONFIRM]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AUTO_CONFIRM object:self userInfo:nil];
        }
        
        [AppDelegate increaseUnreadNotificationsCount:payload.additionalData];
        
    };
    
    // (Optional) - Configuration options for OneSignal settings.
    id oneSignalSetting = @{kOSSettingsKeyInFocusDisplayOption : @(OSNotificationDisplayTypeNotification), kOSSettingsKeyAutoPrompt : @YES};
    
    // (REQUIRED) - Initializes OneSignal
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:ONESIGNAL_APP_ID
          handleNotificationReceived:notificationRecievedBlock
            handleNotificationAction:notificationOpenedBlock
                            settings:oneSignalSetting];
    
    /*OSPermissionSubscriptionState* status = [OneSignal getPermissionSubscriptionState];
     NSString* userId = status.subscriptionStatus.userId;
     if(userId){
            //NSLog(@"UserId-  %@, pushToken-  %@", userId, pushToken);
        } else {
            NSLog(@"\n%@", @"ERROR: Could not get a pushToken from Apple! Make sure your provisioning profile has 'Push Notifications' enabled and rebuild your app.");
        }*/
    
    [self registerForRemoteNotifications];
    //user local notification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!error) {
                                  //NSLog(@"request authorization succeeded!");
                              }
                          }];
    return YES;
}

//Google/Facebook Sign in
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    
    NSString* urlStr = url.absoluteString;
    NSString* preChar = @"";
    for(int i=0;i<2;i++) {
        char character = [urlStr characterAtIndex:i];
        preChar = [NSString stringWithFormat:@"%@%c", preChar, character];
    }
    if([preChar isEqualToString:@"fb"]) {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                      openURL:url
                                                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                        ];
        return handled;
    } else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSString* urlStr = url.absoluteString;
    NSString* preChar = @"";
    for(int i=0;i<2;i++) {
        char character = [urlStr characterAtIndex:i];
        preChar = [NSString stringWithFormat:@"%@%c", preChar, character];
    }
    if([preChar isEqualToString:@"fb"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    } else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
        
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerForRemoteNotifications {
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        // Code for old versions
    }
}

//Called when a notification is delivered to a foreground app.

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    //NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    NSString *noti_id = notification.request.content.userInfo[@"notification_id"];
    
    if([noti_id isEqualToString:NOTI_AUTO_CANCEL] ){
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_OUT object:self userInfo:nil];
        NSString *bookId =notification.request.content.userInfo[@"book_id"];
        [SVProgressHUD showWithStatus:@"Cancelling..."];
        [HttpApi cancelAppointment:bookId Success:^(NSDictionary* result){
            [SVProgressHUD showSuccessWithStatus:@"This Appointment was cancelled automatically."];
            
        } Fail:^(NSString* errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
    }
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    //NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
    NSString *noti_id = response.notification.request.content.userInfo[@"notification_id"];
    
    if([noti_id isEqualToString:NOTI_AUTO_CANCEL] ){
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_OUT object:self userInfo:nil];
        NSString *bookId =response.notification.request.content.userInfo[@"book_id"];
        [SVProgressHUD showWithStatus:@"Cancelling..."];
        [HttpApi cancelAppointment:bookId Success:^(NSDictionary* result){
            [SVProgressHUD showSuccessWithStatus:@"This Appointment was cancelled automatically."];
            
        } Fail:^(NSString* errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
    }
}

// RemoteNotification
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)(void))completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // NSLog(@"Error %@",error.localizedDescription);
}

/*-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *badgenumber=[NSString stringWithFormat:@"%@",userInfo[@"aps"][@"badge"]];
    [self.notificationDelegate updateNotificationDetails:badgenumber];
    //[[Common simpleAlert:@"Notification" desc:userInfo[@"aps"][@"alert"]] show];
    NSString *noti_id = userInfo[@"notification_id"];
    
    if([noti_id isEqualToString:NOTI_AUTO_CANCEL] ){
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_OUT object:self userInfo:nil];
        NSString *bookId = userInfo[@"book_id"];
        [SVProgressHUD showWithStatus:@"Cancelling..."];
        [HttpApi cancelAppointment:bookId Success:^(NSDictionary* result){
            [SVProgressHUD showSuccessWithStatus:@"This Appointment was cancelled automatically."];
            
        } Fail:^(NSString* errstr){
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
    }
}*/

+ (void)increaseUnreadNotificationsCount:(NSDictionary *)userInfo
{
    if(g_appDelegate.unreadNotificationsCount == nil)
        return;
    g_appDelegate.unreadNotificationsCount = [NSString stringWithFormat:@"%ld", [g_appDelegate.unreadNotificationsCount integerValue] + 1];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [g_appDelegate.unreadNotificationsCount integerValue];
    //[[Common simpleAlert:@"Notification" desc:userInfo[@"alert"]] show];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STATUS object:self userInfo:nil];
}

/*- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString *noti_id = notification.userInfo[@"notification_id"];
    
    if([noti_id isEqualToString:NOTI_AUTO_CANCEL] ){
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_OUT object:self userInfo:nil];
        NSString *bookId = notification.userInfo[@"book_id"];
        //[SVProgressHUD showWithStatus:@"Cancelling..."];
        [HttpApi cancelAppointment:bookId Success:^(NSDictionary* result){
            //[SVProgressHUD showSuccessWithStatus:@"This Appointment was cancelled automatically."];
            NSLog(@"msg: %@", @"This Appointment was cancelled automatically.");
        } Fail:^(NSString* errstr){
            //[SVProgressHUD showErrorWithStatus:errstr];
            NSLog(@"error: %@", errstr);
        }];
    }
}*/

@end
