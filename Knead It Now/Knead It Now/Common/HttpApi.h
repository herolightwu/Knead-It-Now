//
//  HttpApi.h
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface HttpApi : NSObject

+ (void)loginWithEmail:(NSString *)email
                 Password:(NSString *)password
                    Token:(NSString *)token
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)forgotPassword:(NSString *)email
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)signupToUser:(NSString *)email
            Password:(NSString *)password
           Firstname:(NSString *)firstname
            Lastname:(NSString *)lastname
               Phone:(NSString *)phone
               Token:(NSString *)token
             Success:(void (^)(NSDictionary *))success
                Fail:(void (^)(NSString *))fail;

+ (void)signupToSeller:(NSString *)password
              UserInfo:(UserModel *)userinfo
                 Token:(NSString *)token
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)loginWithSocial:(NSString *)email
              Username:(NSString *)username
               Lastname:(NSString *)lastname
               SocialID:(NSString *)socialID
                   Type:(NSString *)type
                  Photo:(NSString *)photo
                 Token:(NSString *)token
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail;


+ (void)logout:(NSString *)uid
       Success:(void (^)(NSDictionary *))success
          Fail:(void (^)(NSString *))fail;
    
+ (void)getUserById:(NSString *)email
             UserID:(NSString *)userid
              Token:(NSString *)token
            Success:(void (^)(NSDictionary *))success
               Fail:(void (^)(NSString *))fail;

+ (void)uploadPhotoPost:(NSData *)photo
                 UserID:(NSString *)uid
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail;

+ (void)removePhoto:(NSString *)uid
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail;

+ (void)changePassword:(NSString *)email
               NewPass:(NSString *)newpass
               OldPass:(NSString *)oldpass
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)updateSellerProfile:(UserModel *)userinfo
                    Success:(void (^)(NSDictionary *))success
                       Fail:(void (^)(NSString *))fail;

+ (void)getReviews:(NSString *)userid
           Success:(void (^)(NSDictionary *))success
              Fail:(void (^)(NSString *))fail;

+ (void)updateUserInfo:(NSString *)uid
              NewEmail:(NSString *)email
              NewPhone:(NSString *)phone
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)updateHomeAddr:(NSString *)uid
              HomeAddr:(NSString *)newaddr
               HomeLoc:(NSString *)newloc
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)setAvailablity:(NSString *)uid
             StartDate:(NSString *)sdate
             StartTime:(NSString *)stime
              Duration:(NSString *)duration
                  Cost:(NSString *)cost
           AutoConfirm:(NSString *)auto_confirm
                  Note:(NSString *)note
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)getAvailability:(NSString *)uid
                  Today:(NSString *)todate
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail;

+ (void)searchBooks:(NSString *)massage_type
          StartDate:(NSString *)sdate
           Duration:(NSString *)duration
             Gender:(NSString *)gender
            Success:(void (^)(NSDictionary *))success
               Fail:(void (^)(NSString *))fail;

+ (void)getTherapistProfile:(NSString *)userid
                    Success:(void (^)(NSDictionary *))success
                       Fail:(void (^)(NSString *))fail;

+ (void)requestAppointment:(NSString *)userid
                    BookID:(NSString *)bookid
                      Type:(NSString *)mtype
                      Note:(NSString *)note
                  BookTime:(NSString *)booktime
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail;

+ (void)cancelAppointment:(NSString *)bookid
                  Success:(void (^)(NSDictionary *))success
                     Fail:(void (^)(NSString *))fail;

+ (void)getEvents:(NSString *)userid
          Success:(void (^)(NSDictionary *))success
             Fail:(void (^)(NSString *))fail;

+ (void)confirmAppointment:(NSString *)bookid
               ConfirmTime:(NSString *)confirmtime
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail;

+ (void)rejectAppointment:(NSString *)bookid
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail;

+ (void)setEventRead:(NSString *)eventid
             Success:(void (^)(NSDictionary *))success
                Fail:(void (^)(NSString *))fail;

+ (void)getAppointment:(NSString *)bookid
                  Success:(void (^)(NSDictionary *))success
                     Fail:(void (^)(NSString *))fail;

+ (void)getUserProfile:(NSString *)uid
                BookId:(NSString *)bookid
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)reportReview:(NSString *)toid
              FormId:(NSString *)fromid
                Rate:(NSString *)rate
              BookId:(NSString *)bookid
             Content:(NSString *)content
            PostDate:(NSString *)postdate
             Success:(void (^)(NSDictionary *))success
                Fail:(void (^)(NSString *))fail;

+ (void)getPaymentInfo:(NSString *)bookid
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)uploadPayInfo:(NSString *)eventid
               BookId:(NSString *)bookid
              PayTime:(NSString *)paytime
             ChargeId:(NSString *)chargeid
             CardName:(NSString *)cardname
         ChargeStatus:(NSString *)chatgestatus
              Success:(void (^)(NSDictionary *))success
                 Fail:(void (^)(NSString *))fail;

+ (void)getBookHistory:(NSString *)userid
               Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)getMessages:(NSString *)bookid
            Success:(void (^)(NSDictionary *))success
               Fail:(void (^)(NSString *))fail;

+ (void)sendPrivateMessage:(NSString *)bookid
                       Sid:(NSString *)sid
                       Rid:(NSString *)rid
                   Content:(NSString *)content
                  SendTime:(NSString *)stime
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail;

+ (void)getUserRate:(NSString *)userid
            Success:(void (^)(NSDictionary *))success
               Fail:(void (^)(NSString *))fail;

+ (void)updateStpAccount:(NSString *)userid
                   StpId:(NSString *)stpid
                 Success:(void (^)(NSDictionary *))success
                    Fail:(void (^)(NSString *))fail;

+ (void)getPayHistory:(NSString *)userid
              Success:(void (^)(NSDictionary *))success
                 Fail:(void (^)(NSString *))fail;

+ (void)removeAccount:(NSString *)userid
              Success:(void (^)(NSDictionary *))success
                 Fail:(void (^)(NSString *))fail;

//============payment API==
+ (void)retriveCustomer:(NSString *)account_id
                Success:(void (^)(NSDictionary *))success
                   Fail:(void (^)(NSString *))fail;

+ (void)getStripeCardToken:(NSString *)cardname
                   CardNum:(NSString *)cardnumber
                  ExpMonth:(NSString *)expmonth
                   ExpYear:(NSString *)expyear
                       Cvc:(NSString *)cvc
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail;

+ (void)createStripeCustomer:(NSString *)email
                Source:(NSString *)stoken
                  Desc:(NSString *)desc
                Success:(void (^)(NSDictionary *))success
                  Fail:(void (^)(NSString *))fail;

+ (void)addCardToCustomer:(NSString *)act_id
                   Source:(NSString *)stoken
                  Success:(void (^)(NSDictionary *))success
                     Fail:(void (^)(NSString *))fail;

+ (void)getCardListFromCustomer:(NSString *)act_id
                        Success:(void (^)(NSDictionary *))success
                           Fail:(void (^)(NSString *))fail;

+ (void)updateCustomerCard:(NSString *)act_id
                    CardId:(NSString *)card_id
                      Name:(NSString *)name
                  Ex_month:(NSString *)emonth
                   Ex_year:(NSString *)eyear
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail;

+ (void)deleteCustomerCard:(NSString *)act_id
                    CardId:(NSString *)card_id
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail;

+ (void)deleteStripeCustomer:(NSString *)act_id
                     Success:(void (^)(NSDictionary *))success
                        Fail:(void (^)(NSString *))fail;

+ (void)chargeSTPPayment:(NSString *)customer_id
                  CardId:(NSString *)cardid
                  Amount:(NSString *)amount
                  AppFee:(NSString *)appfee
               AccountId:(NSString *)act_id
                    Desc:(NSString *)desc
                 Success:(void (^)(NSDictionary *))success
                    Fail:(void (^)(NSString *))fail;

//------------------------------

+ (void)createSTPAccount:(NSString *)email
                  Source:(NSString *)stoken
                 Success:(void (^)(NSDictionary *))success
                    Fail:(void (^)(NSString *))fail;

+ (void)addCardToAccount:(NSString *)act_id
                  Source:(NSString *)stoken
                 Success:(void (^)(NSDictionary *))success
                    Fail:(void (^)(NSString *))fail;

+ (void)getCardListFromAccount:(NSString *)act_id
                       Success:(void (^)(NSDictionary *))success
                          Fail:(void (^)(NSString *))fail;

+ (BOOL)updateTOSAcceptance:(NSString *)act_id
                  FirstName:(NSString *)firstname
                   LastName:(NSString *)lastname
                        Dob:(NSString *)mDob
                  IpAddress:(NSString *)ipaddress
                       Type:(NSInteger)type
                    Success:(void (^)(NSDictionary *))success
                       Fail:(void (^)(NSString *))fail;

+ (void)retrieveAccount:(NSString *)act_id
                    Success:(void (^)(NSDictionary *))success
                       Fail:(void (^)(NSString *))fail;

+ (void)updateAccountCard:(NSString *)act_id
                    CardId:(NSString *)card_id
                      Name:(NSString *)name
                 Ex_month:(NSString *)emonth
                  Ex_year:(NSString *)eyear
               DefaultCard:(NSString *)def_str
                   Success:(void (^)(NSDictionary *))success
                      Fail:(void (^)(NSString *))fail;

+ (void)deleteAccountCard:(NSString *)act_id
                   CardId:(NSString *)card_id
                  Success:(void (^)(NSDictionary *))success
                     Fail:(void (^)(NSString *))fail;

+ (void)deleteSTPAccount:(NSString *)act_id
                 Success:(void (^)(NSDictionary *))success
                    Fail:(void (^)(NSString *))fail;
@end
