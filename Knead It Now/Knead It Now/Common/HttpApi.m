//
//  HttpApi.m
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//
#import "HttpApi.h"
#import "AFHTTPSessionManager.h"
#import "Config.h"
#import "Common.h"

@implementation HttpApi

+ (void)callApiWithPath:path
                 Params:(NSMutableDictionary *)params
                 Images:(NSMutableArray *)images
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    if(images != nil) {
    //        manager.requestSerializer.timeoutInterval = 600;
    //    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager POST:[NSString stringWithFormat:@"%@/api/%@", SERVER_URL, path] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(images != nil) {
            for(NSDictionary *image in images) {
                [formData appendPartWithFileData:[NSData dataWithData:image[@"data"]]
                                            name:image[@"name"]
                                        fileName:[image[@"is_png"] boolValue] ? @"image.png" : @"image.jpg"
                                        mimeType:[image[@"is_png"] boolValue] ? @"image/png" : @"image/jpeg"];
            }
        }
    }
         progress:nil success:^(NSURLSessionTask *task, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *response = (NSDictionary *)responseObject;
             
             if([response[@"status"] isEqualToString:@"success"]) {
                 success(response[@"data"]);
                 return;
             }
             
             NSString *error = [[response[@"error"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
             fail(error);
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             NSDictionary *userInfo = [error userInfo];
             NSString *errorString = [userInfo objectForKey:@"NSLocalizedDescription"];
             fail(errorString);
         }];
}

+ (void)loginWithEmail:(NSString *)email
                 Password:(NSString *)password
                    Token:(NSString *)token
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail
{
    NSDictionary *parameters = @{
                                 @"email":email,
                                 @"password":password,
                                 @"token":token
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_LOGIN Params:params Images:nil Success:success Fail:fail];
    
}

+ (void)forgotPassword:(NSString *)email
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"email":email,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_FORGOTPASS Params:params Images:nil Success:success Fail:fail];
}

+ (void)signupToUser:(NSString *)email
            Password:(NSString *)password
           Firstname:(NSString *)firstname
            Lastname:(NSString *)lastname
               Phone:(NSString *)phone
               Token:(NSString *)token
             Success:(void (^)(NSDictionary *))success
                Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"email":email,
                                 @"password":password,
                                 @"firstname":firstname,
                                 @"lastname":lastname,
                                 @"phone":phone,
                                 @"token":token
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_SIGNUP_TO_USER Params:params Images:nil Success:success Fail:fail];
}

+ (void)loginWithSocial:(NSString *)email
               Username:(NSString *)username
               Lastname:(NSString *)lastname
               SocialID:(NSString *)socialID
                   Type:(NSString *)type
                  Photo:(NSString *)photo
                  Token:(NSString *)token
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"email":email,
                                 @"username":username,
                                 @"lastname":lastname,
                                 @"socialid":socialID,
                                 @"type":type,
                                 @"photo":photo,
                                 @"token":token,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_LOGIN_SOCIAL Params:params Images:nil Success:success Fail:fail];
}

+ (void)signupToSeller:(NSString *)password
              UserInfo:(UserModel *)userinfo
                 Token:(NSString *)token
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"password":password,
                                 @"email":userinfo.email,
                                 @"username":userinfo.userName,
                                 @"firstname":userinfo.firstName,
                                 @"lastname":userinfo.lastName,
                                 @"gender":userinfo.gender,
                                 @"birthday":userinfo.birthday,
                                 @"phone":userinfo.phone,
                                 @"location":userinfo.homeLoc,
                                 @"business_name":userinfo.businessInfo.bName,
                                 @"business_address":userinfo.businessInfo.bAddress,
                                 @"business_zip":userinfo.businessInfo.zipcode,
                                 @"business_license":userinfo.businessInfo.bLicense,
                                 @"business_active":userinfo.businessInfo.activeYear,
                                 @"business_parking":userinfo.businessInfo.parking,
                                 @"business_types":userinfo.businessInfo.bTypes,
                                 @"stp_id":userinfo.account_id,
                                 @"token":token,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_SIGNUP_TO_SELLER Params:params Images:nil Success:success Fail:fail];
}

+ (void)logout:(NSString *)uid
       Success:(void (^)(NSDictionary *))success
          Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"userID":uid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_LOGOUT Params:params Images:nil Success:success Fail:fail];
}

+ (void)getUserById:(NSString *)email
             UserID:(NSString *)userid
              Token:(NSString *)token
            Success:(void (^)(NSDictionary *))success
               Fail:(void (^)(NSString *))fail
{
    NSDictionary *parameters = @{
                                 @"userID":userid,
                                 @"email":email,
                                 @"token":token,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_USER_BY_ID Params:params Images:nil Success:success Fail:fail];
}

+ (void)uploadPhotoPost:(NSData *)photo
                 UserID:(NSString *)uid
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [images addObject:@{@"name":@"photo", @"data":photo, @"is_png":@0}];
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_UPLOAD_PHOTO Params:params Images:images Success:success Fail:fail];
}

+ (void)removePhoto:(NSString *)uid
            Success:(void (^)(NSDictionary *))success
               Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_REMOVE_PHOTO Params:params Images:nil Success:success Fail:fail];
}

+ (void)changePassword:(NSString *)email
               NewPass:(NSString *)newpass
               OldPass:(NSString *)oldpass
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"email":email,
                                 @"new_pass":newpass,
                                 @"old_pass":oldpass,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_CHANGE_PASSWORD Params:params Images:nil Success:success Fail:fail];
}

+ (void)updateSellerProfile:(UserModel *)userinfo
                    Success:(void (^)(NSDictionary *))success
                       Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":userinfo.userId,
                                 @"email":userinfo.email,
                                 @"firstname":userinfo.firstName,
                                 @"lastname":userinfo.lastName,
                                 @"gender":userinfo.gender,
                                 @"phone":userinfo.phone,
                                 @"location":userinfo.homeLoc,
                                 @"bid":userinfo.businessInfo.businessId,
                                 @"business_name":userinfo.businessInfo.bName,
                                 @"business_address":userinfo.businessInfo.bAddress,
                                 @"business_zip":userinfo.businessInfo.zipcode,
                                 @"business_license":userinfo.businessInfo.bLicense,
                                 @"business_active":userinfo.businessInfo.activeYear,
                                 @"business_parking":userinfo.businessInfo.parking,
                                 @"business_types":userinfo.businessInfo.bTypes,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_UPDATE_SELLER_PROFILE Params:params Images:nil Success:success Fail:fail];
}

+ (void)getReviews:(NSString *)userid
           Success:(void (^)(NSDictionary *))success
              Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":userid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_REVIEWS Params:params Images:nil Success:success Fail:fail];
}

+ (void)updateUserInfo:(NSString *)uid
              NewEmail:(NSString *)email
              NewPhone:(NSString *)phone
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"email":email,
                                 @"phone":phone,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_UPDATE_USERINFO Params:params Images:nil Success:success Fail:fail];
}

+ (void)updateHomeAddr:(NSString *)uid
              HomeAddr:(NSString *)newaddr
               HomeLoc:(NSString *)newloc
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"address":newaddr,
                                 @"location":newloc,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_UPDATE_HOMEADDR Params:params Images:nil Success:success Fail:fail];
}

+ (void)setAvailablity:(NSString *)uid
             StartDate:(NSString *)sdate
             StartTime:(NSString *)stime
              Duration:(NSString *)duration
                  Cost:(NSString *)cost
           AutoConfirm:(NSString *)auto_confirm
                  Note:(NSString *)note
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"start_date":sdate,
                                 @"start_time":stime,
                                 @"duration":duration,
                                 @"cost":cost,
                                 @"auto_confirm":auto_confirm,
                                 @"note":note,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_SET_AVAILABILITY Params:params Images:nil Success:success Fail:fail];
}

+ (void)getAvailability:(NSString *)uid
                  Today:(NSString *)todate
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"today":todate,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_AVAILABILITY Params:params Images:nil Success:success Fail:fail];
}

+ (void)searchBooks:(NSString *)massage_type
          StartDate:(NSString *)sdate
           Duration:(NSString *)duration
             Gender:(NSString *)gender
            Success:(void (^)(NSDictionary *))success
               Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"massage_type":massage_type,
                                 @"start_date":sdate,
                                 @"duration":duration,
                                 @"gender":gender,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_SEARCH_BOOKS Params:params Images:nil Success:success Fail:fail];
}

+ (void)getTherapistProfile:(NSString *)userid
                    Success:(void (^)(NSDictionary *))success
                       Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":userid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_THERAPIST_PROFILE Params:params Images:nil Success:success Fail:fail];
}

+ (void)requestAppointment:(NSString *)userid
                    BookID:(NSString *)bookid
                      Type:(NSString *)mtype
                      Note:(NSString *)note
                  BookTime:(NSString *)booktime
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"book_id":bookid,
                                 @"buyer_id":userid,
                                 @"massage_type":mtype,
                                 @"note":note,
                                 @"book_time":booktime,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_REQUEST_APPOINTMENT Params:params Images:nil Success:success Fail:fail];
}

+ (void)cancelAppointment:(NSString *)bookid
                  Success:(void (^)(NSDictionary *))success
                     Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"book_id":bookid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_CANCEL_APPOINTMENT Params:params Images:nil Success:success Fail:fail];
}

+ (void)getEvents:(NSString *)userid
          Success:(void (^)(NSDictionary *))success
             Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":userid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_EVENTS Params:params Images:nil Success:success Fail:fail];
}


+ (void)confirmAppointment:(NSString *)bookid
               ConfirmTime:(NSString *)confirmtime
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"book_id":bookid,
                                 @"confirm_time":confirmtime,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_CONFIRM_APPOINTMENT Params:params Images:nil Success:success Fail:fail];
}

+ (void)rejectAppointment:(NSString *)bookid
                  Success:(void (^)(NSDictionary *))success
                     Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"book_id":bookid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_REJECT_APPOINTMENT Params:params Images:nil Success:success Fail:fail];
}

+ (void)setEventRead:(NSString *)eventid
             Success:(void (^)(NSDictionary *))success
                Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"event_id":eventid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_READ_EVENT Params:params Images:nil Success:success Fail:fail];
}

+ (void)getAppointment:(NSString *)bookid
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"book_id":bookid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_APPOINTMENT Params:params Images:nil Success:success Fail:fail];
}

+ (void)getUserProfile:(NSString *)uid
                BookId:(NSString *)bookid
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"book_id":bookid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_USER_PROFILE Params:params Images:nil Success:success Fail:fail];
}

+ (void)reportReview:(NSString *)toid
              FormId:(NSString *)fromid
                Rate:(NSString *)rate
              BookId:(NSString *)bookid
             Content:(NSString *)content
            PostDate:(NSString *)postdate
             Success:(void (^)(NSDictionary *))success
                Fail:(void (^)(NSString *))fail{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString* ptime = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *parameters = @{
                                 @"to_user":toid,
                                 @"from_user":fromid,
                                 @"rate":rate,
                                 @"book_id":bookid,
                                 @"review":content,
                                 @"post_date":postdate,
                                 @"post_time":ptime,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_REPORT_REVIEW Params:params Images:nil Success:success Fail:fail];
}

+ (void)getPaymentInfo:(NSString *)bookid
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"book_id":bookid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_PAYMENTINFO Params:params Images:nil Success:success Fail:fail];
}

+ (void)uploadPayInfo:(NSString *)eventid
               BookId:(NSString *)bookid
              PayTime:(NSString *)paytime
             ChargeId:(NSString *)chargeid
             CardName:(NSString *)cardname
         ChargeStatus:(NSString *)chatgestatus
              Success:(void (^)(NSDictionary *))success
                 Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"event_id":eventid,
                                 @"book_id":bookid,
                                 @"paytime":paytime,
                                 @"charge_id":chargeid,
                                 @"card_name":cardname,
                                 @"status":chatgestatus,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_DO_PAY Params:params Images:nil Success:success Fail:fail];
}

+ (void)getBookHistory:(NSString *)userid
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"user_id":userid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_HISTORY Params:params Images:nil Success:success Fail:fail];
}

+ (void)getMessages:(NSString *)bookid
            Success:(void (^)(NSDictionary *))success
               Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"book_id":bookid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_MESSAGES Params:params Images:nil Success:success Fail:fail];
}

+ (void)sendPrivateMessage:(NSString *)bookid
                Sid:(NSString *)sid
                Rid:(NSString *)rid
            Content:(NSString *)content
           SendTime:(NSString *)stime
            Success:(void (^)(NSDictionary *))success
               Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"book_id":bookid,
                                 @"sender_id":sid,
                                 @"receiver_id":rid,
                                 @"content":content,
                                 @"send_time":stime,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_SEND_MESSAGE Params:params Images:nil Success:success Fail:fail];
}

+ (void)getUserRate:(NSString *)userid
            Success:(void (^)(NSDictionary *))success
               Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":userid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_USER_RATE Params:params Images:nil Success:success Fail:fail];
}

+ (void)updateStpAccount:(NSString *)userid
                   StpId:(NSString *)stpid
                 Success:(void (^)(NSDictionary *))success
                    Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":userid,
                                 @"account_id":stpid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_UPDATE_STRIPE_ID Params:params Images:nil Success:success Fail:fail];
}

+ (void)getPayHistory:(NSString *)userid
              Success:(void (^)(NSDictionary *))success
                 Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":userid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_GET_PAY_HISTORY Params:params Images:nil Success:success Fail:fail];
}

+ (void)removeAccount:(NSString *)userid
              Success:(void (^)(NSDictionary *))success
                 Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"uid":userid,
                                 };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callApiWithPath:POST_REMOVE_ACCOUNT Params:params Images:nil Success:success Fail:fail];
}

//==========================================================================================================

+ (void)callStripeApiWithPath:path
                 Params:(NSMutableDictionary *)params
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    if(images != nil) {
    //        manager.requestSerializer.timeoutInterval = 600;
    //    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSString *authorize_str = [NSString stringWithFormat:@"Bearer %@", STRIPE_SECRET_KEY];
    [manager.requestSerializer setValue:authorize_str forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    [manager POST:[NSString stringWithFormat:@"%@/%@", STRIPE_SERVER_URL, path] parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *response = (NSDictionary *)responseObject;
             success(response);
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             NSDictionary *userInfo = [error userInfo];
             NSString *errorString = [userInfo objectForKey:@"NSLocalizedDescription"];
             fail(errorString);
         }];
}

+ (void)retriveCustomer:(NSString *)account_id
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{};
    NSString *path = [NSString stringWithFormat:@"customers/%@", account_id];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callStripeApiWithPath:path Params:params Success:success Fail:fail];
}

+ (void)getStripeCardToken:(NSString *)cardname
                   CardNum:(NSString *)cardnumber
                  ExpMonth:(NSString *)expmonth
                   ExpYear:(NSString *)expyear
                       Cvc:(NSString *)cvc
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"card[number]":cardnumber,
                                 @"card[exp_month]":expmonth,
                                 @"card[exp_year]":expyear,
                                 @"card[cvc]":cvc,
                                 @"card[name]":cardname,
                                 @"card[currency]":@"usd",
                                 };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callStripeApiWithPath:@"tokens" Params:params Success:success Fail:fail];
}

+ (void)createStripeCustomer:(NSString *)email
                Source:(NSString *)stoken
                  Desc:(NSString *)desc
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"description":desc,
                                 @"source":stoken,
                                 @"email":email,
                                 };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callStripeApiWithPath:@"customers" Params:params Success:success Fail:fail];
}

+ (void)addCardToCustomer:(NSString *)act_id
                   Source:(NSString *)stoken
                  Success:(void (^)(NSDictionary *))success
                     Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"source":stoken,
                                 };
    NSString *path = [NSString stringWithFormat:@"customers/%@/sources", act_id];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callStripeApiWithPath:path Params:params Success:success Fail:fail];
}

+ (void)getCardListFromCustomer:(NSString *)act_id
                        Success:(void (^)(NSDictionary *))success
                           Fail:(void (^)(NSString *))fail{
    NSString *path = [NSString stringWithFormat:@"customers/%@/sources?object=card", act_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    if(images != nil) {
    //        manager.requestSerializer.timeoutInterval = 600;
    //    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSString *authorize_str = [NSString stringWithFormat:@"Bearer %@", STRIPE_SECRET_KEY];
    [manager.requestSerializer setValue:authorize_str forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    [manager GET:[NSString stringWithFormat:@"%@/%@", STRIPE_SERVER_URL, path] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        success(response);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSDictionary *userInfo = [error userInfo];
        NSString *errorString = [userInfo objectForKey:@"NSLocalizedDescription"];
        fail(errorString);
    }];
}

+ (void)updateCustomerCard:(NSString *)act_id
                    CardId:(NSString *)card_id
                      Name:(NSString *)name
                  Ex_month:(NSString *)emonth
                   Ex_year:(NSString *)eyear
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail{
    NSNumber *num_month = [[NSNumber alloc] initWithInteger:[emonth integerValue]];
    NSNumber *num_year = [[NSNumber alloc] initWithInteger:[eyear integerValue]];
    NSDictionary *parameters = @{
                                 @"name":name,
                                 @"exp_month":num_month,
                                 @"exp_year":num_year,
                                 };
    NSString *path = [NSString stringWithFormat:@"customers/%@/sources/%@", act_id, card_id];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callStripeApiWithPath:path Params:params Success:success Fail:fail];
}

+ (void)deleteCustomerCard:(NSString *)act_id
                    CardId:(NSString *)card_id
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail{
    NSString *path = [NSString stringWithFormat:@"customers/%@/sources/%@", act_id, card_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    if(images != nil) {
    //        manager.requestSerializer.timeoutInterval = 600;
    //    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSString *authorize_str = [NSString stringWithFormat:@"Bearer %@", STRIPE_SECRET_KEY];
    [manager.requestSerializer setValue:authorize_str forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    [manager DELETE:[NSString stringWithFormat:@"%@/%@", STRIPE_SERVER_URL, path] parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        success(response);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSDictionary *userInfo = [error userInfo];
        NSString *errorString = [userInfo objectForKey:@"NSLocalizedDescription"];
        fail(errorString);
    }];
}

+ (void)deleteStripeCustomer:(NSString *)act_id
                     Success:(void (^)(NSDictionary *))success
                        Fail:(void (^)(NSString *))fail{
    NSString *path = [NSString stringWithFormat:@"customers/%@", act_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    if(images != nil) {
    //        manager.requestSerializer.timeoutInterval = 600;
    //    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSString *authorize_str = [NSString stringWithFormat:@"Bearer %@", STRIPE_SECRET_KEY];
    [manager.requestSerializer setValue:authorize_str forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    [manager DELETE:[NSString stringWithFormat:@"%@/%@", STRIPE_SERVER_URL, path] parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        success(response);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSDictionary *userInfo = [error userInfo];
        NSString *errorString = [userInfo objectForKey:@"NSLocalizedDescription"];
        fail(errorString);
    }];
}

+ (void)chargeSTPPayment:(NSString *)customer_id
                  CardId:(NSString *)cardid
                  Amount:(NSString *)amount
                  AppFee:(NSString *)appfee
               AccountId:(NSString *)act_id
                    Desc:(NSString *)desc
                 Success:(void (^)(NSDictionary *))success
                    Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"amount":amount,
                                 @"currency":@"usd",
                                 @"application_fee":appfee,
                                 @"customer":customer_id,
                                 @"source":cardid,
                                 @"destination[account]":act_id,
                                 @"description":desc,
                                 };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callStripeApiWithPath:@"charges" Params:params Success:success Fail:fail];
}

+ (void)addCardToAccount:(NSString *)act_id
                  Source:(NSString *)stoken
                 Success:(void (^)(NSDictionary *))success
                    Fail:(void (^)(NSString *))fail{
    
    NSDictionary *parameters = @{
                                 @"external_account":stoken,
                                 };
    NSString *path = [NSString stringWithFormat:@"accounts/%@/external_accounts", act_id];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callStripeApiWithPath:path Params:params Success:success Fail:fail];
}

+ (void)createSTPAccount:(NSString *)email
                  Source:(NSString *)stoken
                 Success:(void (^)(NSDictionary *))success
                    Fail:(void (^)(NSString *))fail{
    NSDictionary *parameters = @{
                                 @"type":@"custom",
                                 @"country":@"US",
                                 @"email":email,
                                 @"external_account":stoken,
                                 };
    NSString *path = [NSString stringWithFormat:@"accounts"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callStripeApiWithPath:path Params:params Success:success Fail:fail];
}

+ (void)getCardListFromAccount:(NSString *)act_id
                       Success:(void (^)(NSDictionary *))success
                          Fail:(void (^)(NSString *))fail{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/external_accounts?object=card", act_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    if(images != nil) {
    //        manager.requestSerializer.timeoutInterval = 600;
    //    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSString *authorize_str = [NSString stringWithFormat:@"Bearer %@", STRIPE_SECRET_KEY];
    [manager.requestSerializer setValue:authorize_str forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    [manager GET:[NSString stringWithFormat:@"%@/%@", STRIPE_SERVER_URL, path] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        success(response);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSDictionary *userInfo = [error userInfo];
        NSString *errorString = [userInfo objectForKey:@"NSLocalizedDescription"];
        fail(errorString);
    }];
}

+ (BOOL)updateTOSAcceptance:(NSString *)act_id
                  FirstName:(NSString *)firstname
                   LastName:(NSString *)lastname
                        Dob:(NSString *)mDob
                  IpAddress:(NSString *)ipaddress
                       Type:(NSInteger)type
                    Success:(void (^)(NSDictionary *))success
                       Fail:(void (^)(NSString *))fail{
    
    NSString* date_stamp = [Common timeStamp];
    NSString* ip_str = ipaddress;
    if([ipaddress length] == 0){
        ip_str = [Common getIPAddress];
        if([ip_str isEqualToString:@"error"]){
            return NO;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"accounts/%@", act_id];
    NSMutableDictionary *params;
    if(type == 1){
        NSArray* foo = [mDob componentsSeparatedByString:@"/"];
        NSDictionary *parameters = @{
                                     @"tos_acceptance[date]":date_stamp,
                                     @"tos_acceptance[ip]":ip_str,
                                     @"legal_entity[dob][day]":foo[1],
                                     @"legal_entity[dob][month]":foo[0],
                                     @"legal_entity[dob][year]":foo[2],
                                     @"legal_entity[first_name]":firstname,
                                     @"legal_entity[last_name]":lastname,
                                     @"legal_entity[type]":@"individual",
                                     };
        params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    } else{
        NSDictionary *parameters = @{
                                     @"tos_acceptance[date]":date_stamp,
                                     @"tos_acceptance[ip]":ip_str,
                                     //@"legal_entity[dob][day]":foo[1],
                                     //@"legal_entity[dob][month]":foo[0],
                                     //@"legal_entity[dob][year]":foo[2],
                                     //@"legal_entity[first_name]":firstname,
                                     //@"legal_entity[last_name]":lastname,
                                     //@"legal_entity[type]":@"individual",
                                     };
        params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    }
    
    [HttpApi callStripeApiWithPath:path Params:params Success:success Fail:fail];
    return YES;
}

+ (void)retrieveAccount:(NSString *)act_id
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail{
    NSString *path = [NSString stringWithFormat:@"accounts/%@", act_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    if(images != nil) {
    //        manager.requestSerializer.timeoutInterval = 600;
    //    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSString *authorize_str = [NSString stringWithFormat:@"Bearer %@", STRIPE_SECRET_KEY];
    [manager.requestSerializer setValue:authorize_str forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    [manager GET:[NSString stringWithFormat:@"%@/%@", STRIPE_SERVER_URL, path] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        success(response);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSDictionary *userInfo = [error userInfo];
        NSString *errorString = [userInfo objectForKey:@"NSLocalizedDescription"];
        fail(errorString);
    }];
}

+ (void)updateAccountCard:(NSString *)act_id
                   CardId:(NSString *)card_id
                     Name:(NSString *)name
                 Ex_month:(NSString *)emonth
                  Ex_year:(NSString *)eyear
              DefaultCard:(NSString *)def_str
                  Success:(void (^)(NSDictionary *))success
                     Fail:(void (^)(NSString *))fail{
    NSNumber *num_month = [[NSNumber alloc] initWithInteger:[emonth integerValue]];
    NSNumber *num_year = [[NSNumber alloc] initWithInteger:[eyear integerValue]];
    NSDictionary *parameters = @{
                                 @"name":name,
                                 @"exp_month":num_month,
                                 @"exp_year":num_year,
                                 @"default_for_currency":def_str,
                                 };
    NSString *path = [NSString stringWithFormat:@"accounts/%@/external_accounts/%@", act_id, card_id];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [HttpApi callStripeApiWithPath:path Params:params Success:success Fail:fail];
}

+ (void)deleteAccountCard:(NSString *)act_id
                   CardId:(NSString *)card_id
                  Success:(void (^)(NSDictionary *))success
                     Fail:(void (^)(NSString *))fail{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/external_accounts/%@", act_id, card_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    if(images != nil) {
    //        manager.requestSerializer.timeoutInterval = 600;
    //    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSString *authorize_str = [NSString stringWithFormat:@"Bearer %@", STRIPE_SECRET_KEY];
    [manager.requestSerializer setValue:authorize_str forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    [manager DELETE:[NSString stringWithFormat:@"%@/%@", STRIPE_SERVER_URL, path] parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        success(response);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSDictionary *userInfo = [error userInfo];
        NSString *errorString = [userInfo objectForKey:@"NSLocalizedDescription"];
        fail(errorString);
    }];
}

+ (void)deleteSTPAccount:(NSString *)act_id
                 Success:(void (^)(NSDictionary *))success
                    Fail:(void (^)(NSString *))fail{
    NSString *path = [NSString stringWithFormat:@"accounts/%@", act_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    if(images != nil) {
    //        manager.requestSerializer.timeoutInterval = 600;
    //    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSString *authorize_str = [NSString stringWithFormat:@"Bearer %@", STRIPE_SECRET_KEY];
    [manager.requestSerializer setValue:authorize_str forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    [manager DELETE:[NSString stringWithFormat:@"%@/%@", STRIPE_SERVER_URL, path] parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        success(response);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSDictionary *userInfo = [error userInfo];
        NSString *errorString = [userInfo objectForKey:@"NSLocalizedDescription"];
        fail(errorString);
    }];
}
@end
