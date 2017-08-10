//
//  ChatBaseModel.h
//  KJProject
//
//  Created by wangyang on 2017/5/9.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatBaseModel : NSObject

@property (copy, nonatomic) NSString *name;                     //聊天室 群聊名称
@property (copy, nonatomic) NSString *announcement;             //聊天室 群聊公告
@property (copy, nonatomic) NSString *province;                 //省
@property (copy, nonatomic) NSString *city;                     //市
@property (copy, nonatomic) NSString *level;                    //等级 0-普通成员  1-副管理员  2-正管理员
@property (copy, nonatomic) NSString *state;

@property (copy, nonatomic) NSString *logoUrl;                  //群聊头像
@property (copy, nonatomic) NSString *isManager;                //群聊管理员

@property (strong, nonatomic) NSNumber *Id;                     //聊天室 群聊id

@end
