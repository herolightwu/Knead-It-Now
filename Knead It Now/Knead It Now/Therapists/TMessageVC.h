//
//  TMessageVC.h
//  Knead It Now
//
//  Created by meixiang wu on 2018/6/17.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"

@interface TMessageVC : JSQMessagesViewController <JSQMessagesComposerTextViewPasteDelegate>

@property (nonatomic, strong) NSString *bookid;
@property (nonatomic, strong) NSString *fromphoto;
@property (nonatomic, strong) NSString *fromname;
@property (nonatomic, strong) NSString *fromid;
@property (nonatomic, strong) NSMutableArray *m_messages;

//- (void)receiveMessagePressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIView *mTitleView;

- (IBAction)onBack:(id)sender;

@end
