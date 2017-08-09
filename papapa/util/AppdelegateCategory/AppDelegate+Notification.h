//
//  AppDelegate+Notification.h
//  wowobao_s
//
//  Created by 王振 DemoKing on 2016/11/2.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import "AppDelegate.h"

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
//#import "WXApi.h"

//新浪微博SDK头文件
//#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@interface AppDelegate (Notification)
// 注册通知
- (void)registerUserNotification;

//初始化shareSDK
- (void)registerShareSDK;


@end
