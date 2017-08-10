//
//  UserModel.m
//  KJProject
//
//  Created by wangyang on 2017/3/11.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "UserModel.h"
#import "NSString+Utils.h"

@implementation UserModel

- (void)setNickName:(NSString *)nickName{
    if (nickName) {
        _nickName = nickName;
        _pinyin = _nickName.pinyin;
    }
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"
             };
}

@end
