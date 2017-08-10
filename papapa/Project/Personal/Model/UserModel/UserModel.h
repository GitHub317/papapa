//
//  UserModel.h
//  KJProject
//
//  Created by wangyang on 2017/3/11.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (copy, nonatomic) NSString *nickName;                     //昵称
@property (copy, nonatomic) NSString *pinyin;

@property (copy, nonatomic) NSString *remark;                       //备注
@property (copy, nonatomic) NSString *mobileNo;                     //手机号
@property (copy, nonatomic) NSString *password;                     //密码
@property (copy, nonatomic) NSString *avatarUrl;                    //头像地址
@property (copy, nonatomic) NSString *sex;                          //性别
@property (copy, nonatomic) NSString *signature;                    //签名
@property (copy, nonatomic) NSString *province;                     //省
@property (copy, nonatomic) NSString *city;                         //市
@property (copy, nonatomic) NSString *level;                        //等级
@property (copy, nonatomic) NSString *deviceType;                   //设备类型（android、ios）
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *isFriend;                     //是否是好友
@property (copy ,nonatomic) NSString *banTime;                      //禁言时间
@property (copy ,nonatomic) NSString *brand;                        //汽车品牌
@property (copy ,nonatomic) NSString *model;                        //汽车型号
@property (copy ,nonatomic) NSString *desciption;                   //汽车描述

@property (copy, nonatomic) NSString *dynamicBackgroundUrl;         //动态背景图

@property (strong, nonatomic) NSNumber *Id;                         //用户id
@property (strong, nonatomic) NSNumber *amapId;                     //高德地图id
@property (strong, nonatomic) NSNumber *deviceId;                   //设备id
@property (strong, nonatomic) NSArray *imgUrlArray;                 //动态图片数组

@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) BOOL isExist;                         //判断是否已经存在该好友

@end
