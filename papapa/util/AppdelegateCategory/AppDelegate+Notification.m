//
//  AppDelegate+Notification.m
//  wowobao_s
//
//  Created by 王振 DemoKing on 2016/11/2.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import "AppDelegate+Notification.h"

@implementation AppDelegate (Notification)

- (void)registerUserNotification {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        /// ios7注册推送通知
        //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
        //         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

//初始化shareSDK
//- (void)registerShareSDK {
//    [ShareSDK registerApp:@"1d20ba843f470"
//          activePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
//                            @(SSDKPlatformTypeWechat),
//                            @(SSDKPlatformTypeQQ)]
//                 onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
//             default:
//                 break;
//         }
//     }
//          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         
//         switch (platformType)
//         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2847414792"
//                                           appSecret:@"b82c5326016fa6a3a816e89c855c1f22"
//                                         redirectUri:@"http://www.sharesdk.cn"
//                                            authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:@"wx0f61e4353402bea3"
//                                       appSecret:@"7bd199d3ebefdc1f67839e68d1a271af"];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:@"1106108812"
//                                      appKey:@"1ukIRCWRW8bPoi74"
//                                    authType:SSDKAuthTypeBoth];
//                 break;
//             default:
//                 break;
//         }
//     }];
//}

@end
