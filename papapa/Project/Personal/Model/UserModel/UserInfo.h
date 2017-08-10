//
//  UserInfo.h
//  KJProject
//
//  Created by wangyang on 2017/3/9.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *mobileNo;                     //手机号
@property (copy, nonatomic) NSString *password;                     //密码
@property (copy, nonatomic) NSString *avatarUrl;                    //头像地址
@property (copy, nonatomic) NSString *sex;                          //性别
@property (copy, nonatomic) NSString *signature;                    //签名
@property (copy, nonatomic) NSString *province;                     //省
@property (copy, nonatomic) NSString *city;                         //市
@property (copy, nonatomic) NSString *level;                        //等级
@property (copy, nonatomic) NSString *deviceType;                   //设备类型（android、ios）
@property (copy, nonatomic) NSString *nickName;                     //昵称
@property (copy, nonatomic) NSString *state;                        //用户状态 （normal sos）
@property (copy, nonatomic) NSString *isReal;                       //是否实名认证
@property (copy, nonatomic) NSString *isSos;                        //是否发布sos
@property (copy, nonatomic) NSString *rongCloudToken;               //融云token
@property (copy, nonatomic) NSString *dynamicBackgroundUrl;         //动态背景图

@property (copy ,nonatomic) NSString *brand;                        //汽车品牌
@property (copy ,nonatomic) NSString *model;                        //汽车型号
@property (copy ,nonatomic) NSString *desciption;                   //汽车描述

@property (strong, nonatomic) NSNumber *Id;                         //用户id
@property (strong, nonatomic) NSNumber *amapId;                     //高德地图id
@property (strong, nonatomic) NSNumber *deviceId;                   //设备id



+ (instancetype)shareManager;

+ (void)valueForUserInfo:(UserInfo *)result;

@end
