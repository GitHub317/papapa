//
//  UserInfo.m
//  KJProject
//
//  Created by wangyang on 2017/3/9.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "UserInfo.h"
static UserInfo *userInfo;
@implementation UserInfo

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfo alloc] init];
    });
    return userInfo;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"
             };
}

+ (void)valueForUserInfo:(UserInfo *)result {
    [UserInfo shareManager].accessToken = result.accessToken;
    [UserInfo shareManager].Id = result.Id;
    [UserInfo shareManager].nickName = result.nickName;
    [UserInfo shareManager].avatarUrl = result.avatarUrl;
    [UserInfo shareManager].sex = result.sex;
    [UserInfo shareManager].amapId = result.amapId;
    [UserInfo shareManager].signature = result.signature;
    [UserInfo shareManager].province = result.province;
    [UserInfo shareManager].city = result.city;
    [UserInfo shareManager].level = result.level;
    [UserInfo shareManager].mobileNo = result.mobileNo;
    [UserInfo shareManager].state = result.state;
    [UserInfo shareManager].isReal = result.isReal;
    [UserInfo shareManager].isSos = result.isSos;
    [UserInfo shareManager].rongCloudToken = result.rongCloudToken;
    [UserInfo shareManager].dynamicBackgroundUrl = result.dynamicBackgroundUrl;
    [UserInfo shareManager].brand = result.brand;
    [UserInfo shareManager].model = result.model;
    [UserInfo shareManager].desciption = result.desciption;
}


@end
