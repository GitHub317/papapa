//
//  ChatBaseModel.m
//  KJProject
//
//  Created by wangyang on 2017/5/9.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "ChatBaseModel.h"

@implementation ChatBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}

@end
