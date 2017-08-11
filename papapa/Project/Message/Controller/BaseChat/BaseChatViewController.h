//
//  BaseChatViewController.h
//  KJProject
//
//  Created by wangyang on 2017/5/16.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface BaseChatViewController : RCConversationViewController

@property (strong, nonatomic) UserModel *model;

@property (strong, nonatomic) ChatBaseModel *chatModel;

@property (strong, nonatomic) NSString *pushType;

@end
