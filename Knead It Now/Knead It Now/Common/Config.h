//
//  Config.h
//  
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

//======define Keys =================
#define GOOGLE_API_KEY @"AIzaSyBeZQOTRAYFRWwvrddWUP8rwijrWt_rq-Q"//@"AIzaSyCa1NeX8PGx6jZ6heSK_KStAxZVPPnrvzM"
#define GOOGLE_YOUR_CLIENT_ID @"406088376499-nv69cb62tcg678tudr2ctd2mddcp7pgo.apps.googleusercontent.com"
#define ONESIGNAL_APP_ID @"85fcb7ab-993f-48d0-911f-b07852580fa8"
#define STRIPE_SECRET_KEY @"sk_live_rPmPGqZTc9cSrayzGFdOMVLF" //@"sk_test_BgvPICWeFH2awYuRE0NSItse" //
#define STRIPE_PUBLISH_KEY @"pk_live_ygojYwXT7kTja6W4xVpFsAiG" //@"pk_test_FCInwJaX9qMlrJSmFUIrpEOS" //

//=================color ======================================
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 120.0) blue:((b) / 50.0) alpha:1.0]
#define PRIMARY_COLOR  [UIColor colorWithRed:(0.0/255.0) green:(60.0/255.0) blue:(255.0/255.0) alpha:1.0]
#define WHITE_COLOR  [UIColor colorWithRed:(1.0) green:(1.0) blue:(1.0) alpha:1.0]
#define CONTROLL_EDGE_COLOR  [UIColor colorWithRed:(67.0/255.0) green:(67.0/255.0) blue:(67.0/255.0) alpha:1.0]
#define PRIMARY_TEXT_COLOR [UIColor colorWithRed:(0.0/255.0) green:(128.0/255.0) blue:(255.0/255.0) alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//User Type
#define USER_THERAPIST 0
#define USER_CUSTOMER 1

#define USER_TYPE_CUSTOMER @"1"
#define USER_TYPE_THERAPIST @"2"

#define LOGIN_TYPE_GENERAL 1
#define LOGIN_TYPE_SOCIAL 2

//Edit mode
#define EDITABLE_MODE YES
#define NOEDITABLE_MODE NO

//define constant
#define TYPES_MASSAGES @[@"Deep Tissue", @"Swedish", @"Pre-natal", @"Lymphatic drainage", @"Craniosacral", @"Reflexology", @"Sports", @"Aromatherapy", @"Acupressure", @"Myofascial release", @"Reiki", @"Shiatsu", @"Trigger Point"]
#define SLIDER_INTERVAL 5
#define SELTIME_INTERVAL 10

#define MAX_DISTANCE 24855
#define MILE_UNIT_METER 1609.344

/* Stripe API Part*/
#define STRIPE_SERVER_URL @"https://api.stripe.com/v1"

/*  Server API Url Part*/
#define SERVER_URL @"http://kneaditnowapp.com/kneaditnow"

#define PHOTO_BASE_URL @"assets/uploads/profiles/"

//=== notification identifier ==========
#define NOTI_REQUEST @"11"
#define NOTI_CONFIRM @"1"
#define NOTI_PAID @"2"
#define NOTI_FINISH @"12"
#define NOTI_USER_RATE @"3"
#define NOTI_SELLER_RATE @"13"
#define NOTI_USER_MESSAGE @"4"
#define NOTI_SELLER_MESSAGE @"14"
#define NOTI_REJECT @"5"
#define NOTI_CANCEL @"15"
#define NOTI_AUTO_CONFIRM @"16"

#define NOTI_AUTO_CANCEL @"20"

#define TIMER_LIMIT_VAL 120   //15 minutes=900

//====== notification names=================
#define NOTIFICATION_REQUEST @"user_requested"
#define NOTIFICATION_CONFIRM @"seller_confirmed"
#define NOTIFICATION_PAID @"user_finished"
#define NOTIFICATION_FINISH @"seller_finished"
#define NOTIFICATION_URATE @"seller_rated"
#define NOTIFICATION_SRATE @"user_rated"
#define NOTIFICATION_UMESSAGE @"seller_message"
#define NOTIFICATION_SMESSAGE @"user_message"
#define NOTIFICATION_REJECT @"seller_reject"
#define NOTIFICATION_CANCEL @"user_cancel"
#define NOTIFICATION_AUTO_CONFIRM @"seller_autoconfirm"
#define NOTIFICATION_STATUS @"status_changed"

#define NOTIFICATION_TIME_OUT @"time_out_paid"

//=========== users api=========================
#define POST_LOGIN @"users/login"
#define POST_FORGOTPASS @"users/forgotpassword"
#define POST_SIGNUP_TO_USER @"users/signup_to_user"
#define POST_SIGNUP_TO_SELLER @"users/signup_to_seller"
#define POST_LOGIN_SOCIAL @"users/login_social"
#define POST_LOGOUT @"users/logout"
#define POST_GET_USER_BY_ID @"users/getUserById"
#define POST_UPLOAD_PHOTO @"users/uploadPhoto"
#define POST_REMOVE_PHOTO @"users/removePhoto"
#define POST_CHANGE_PASSWORD @"users/changepassword"
#define POST_UPDATE_SELLER_PROFILE @"users/updateSellerProfile"
#define POST_GET_REVIEWS @"users/getReviews"
#define POST_UPDATE_USERINFO @"users/updateUserInfo"
#define POST_UPDATE_HOMEADDR @"users/updateHomeAddr"
#define POST_GET_THERAPIST_PROFILE @"users/getTherapistProfile"
#define POST_GET_USER_RATE @"users/getUserRate"
#define POST_UPDATE_STRIPE_ID @"users/updateStpAccount"
#define POST_REMOVE_ACCOUNT @"users/removeAccount"

//-----------book api--------------------
#define POST_SET_AVAILABILITY @"book/postBook"
#define POST_GET_AVAILABILITY @"book/getAvailability"
#define POST_SEARCH_BOOKS @"book/searchBooks"
#define POST_REQUEST_APPOINTMENT @"book/requestAppointment"
#define POST_CANCEL_APPOINTMENT @"book/cancelAppointment"
#define POST_GET_EVENTS @"book/getEvents"
#define POST_CONFIRM_APPOINTMENT @"book/confirmAppointment"
#define POST_REJECT_APPOINTMENT @"book/rejectAppointment"
#define POST_READ_EVENT @"book/setEventRead"
#define POST_GET_APPOINTMENT @"book/getAppointment"
#define POST_GET_USER_PROFILE @"book/getCustomerProfile"
#define POST_REPORT_REVIEW @"book/reportReview"
#define POST_GET_PAYMENTINFO @"book/getPaymentInfo"
#define POST_DO_PAY @"book/doPay"
#define POST_GET_HISTORY @"book/getBookHistory"
#define POST_GET_MESSAGES @"book/getMessages"
#define POST_SEND_MESSAGE @"book/sendPrivateMessage"
#define POST_GET_PAY_HISTORY @"book/getPaymentHistory"



