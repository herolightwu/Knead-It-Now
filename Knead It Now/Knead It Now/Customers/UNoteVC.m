//
//  UNoteVC.m
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/21.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "UNoteVC.h"
#import "Config.h"
#import "UAppointDetailsVC.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppDelegate.h"
#import "HttpApi.h"

@interface UNoteVC ()
{
    BOOL binclude;
}
@end

@implementation UNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CALayer *imageLayer = self.mNoteTxt.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mWithoutBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    imageLayer = self.mIncludeBtn.layer;
    [imageLayer setCornerRadius:1];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    binclude = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onWithout:(id)sender {
    binclude = NO;
    [self showConfirmDlg];
}

- (IBAction)onInclude:(id)sender {
    if([self.mNoteTxt.text length] == 0){
        [self showAlertDlg:@"Warning!" Msg:@"Please type your note."];
        return;
    }
    binclude = YES;
    [self showConfirmDlg];
}

- (void)requestAppoint{
    NSString* note = @"";
    if(binclude)
        note = self.mNoteTxt.text;
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [dateFormatter setDateFormat:@"hh:mm a"]; //Here we can set the format which we need
    NSString *booktime = [dateFormatter stringFromDate:todayDate];
    
    [SVProgressHUD showWithStatus:@"Requesting..."];
    [HttpApi requestAppointment:g_user.userId BookID:self.bookdata.book_id Type:self.bookdata.massage_type Note:note BookTime:booktime Success:^(NSDictionary *result){
        [SVProgressHUD dismiss];
        self.bookdata.buyer_note = note;
        self.bookdata.buyer_name = [NSString stringWithFormat:@"%@ %@", g_user.firstName, g_user.lastName];
        self.bookdata.buyer_rate = g_user.rate;
        self.bookdata.status = @"requested";
        UAppointDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_UAppointDetailsVC"];
        vc.bookdata = self.bookdata;
        [self.navigationController pushViewController:vc animated:YES];
    } Fail:^(NSString *errStr){
        [SVProgressHUD showErrorWithStatus:errStr];
    }];    
    
}

- (void) showConfirmDlg{
    NSString* msg = [NSString stringWithFormat:@"Are you sure you want to request appointment for today at %@ with %@ minutes duration at $%@ rate?", self.bookdata.start_time, self.bookdata.duration, self.bookdata.cost];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Confirm Request"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Request"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self requestAppoint];
                                }];
    UIAlertAction* noButton = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                }];
    
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertDlg:(NSString*) title Msg:(NSString*)msg{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}
@end
