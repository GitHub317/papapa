//
//  AppDelegate.m
//  papapa
//
//  Created by 二师兄 on 2017/8/9.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "AppDelegate.h"
#import "RequestEngine.h"
#import <MJExtension.h>
#import <WXApi.h>
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "PersonalViewController.h"
@interface AppDelegate ()<WXApiDelegate,RCIMReceiveMessageDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self rootVCandGuide];
    //初始化各个组件
    [self OSSInitialize];
    //初始融云
    [self RongYunInit];
    //注册推送
    [self registerUserNotification];
    //[WXApi registerApp:WX_APP_ID];
    //隐藏状态蓝条
    application.statusBarHidden = YES;
    /**
     *  启动页延时 1 秒钟
     */
    [NSThread sleepForTimeInterval:1.0];
    //显示状态蓝条
    application.statusBarHidden = NO;
    [self.window makeKeyAndVisible];//显示窗口
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
#pragma mark -
#pragma mark - PRIVATE  Fuction
//初始化rootVC和引导页
- (void)rootVCandGuide{
    //引导页
    NSString * CFVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * oldCFVer = [KJCommonMethods valueForkey:@"CFVersion"];
    //将当前版本号转化为float进行比较
    float floatCFVer = [CFVer floatValue];
    NSLog(@"%f",floatCFVer);
    if (oldCFVer.length == 0) {
        //第一次启动，显示启动页，并存储现在版本号
        [KJCommonMethods saveValue:CFVer key:@"CFVersion"];
        typeof(self) weakSelf = self;
        [self leaderPageWithImages:@[@"guide1",@"guide2"] start:nil];
        self.guideEndBlock = ^{
            [weakSelf rootTabbarViewController];
        };
    } else {
       [self rootTabbarViewController];
    }
}

/**
 初始化阿里云
 */
- (void)OSSInitialize {
    [KJOSSManager initWithOSSServer:ALIYUN_OSS_SERVER rootUrl:ROOT_URL ossToken:ALIYUN_OSS_ACCESS_TOKEN ossBucketName:ALIYUN_OSS_BUCKET_NAME timeInterval:1800];
}
#pragma mark -
#pragma mark -  METHOD  publicFuction

/**
 *  登录页面视图控制器成为跟视图控制器
 */
- (void)singleViewControllerWithClass:(Class)classs {
    UIViewController *vc = [[classs alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIWindow *window = self.window;
    window.rootViewController = nav;
}

/**
 present一个新的导航控制器
 
 @param class 要 present 的class
 @param animation 是否需要动画
 */
-(void)presentNewNavigationControllerWithClass:(Class)class Animation:(BOOL)animation block:(void (^)())block {
    UIViewController * vc = [[class alloc]init];
    //导航控制器
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:vc];
    [self.window.rootViewController presentViewController:nav animated:animation completion:^{
        if (block) {
            block();
        }
    }];
}

/**
 初始化tabbar
 */
-(void)rootTabbarViewController
{
    [self tabBarControllerWithControllers:@[[HomeViewController class],[MessageViewController class],
                                            [PersonalViewController class]] darkImageNames:@[@"ic_tabbar_home_dark",@"ic_tabbar_message_dark",@"ic_tabbar_personal_dark"] lightImageNames:@[@"ic_tabbar_home_light",@"ic_tabbar_message_light",@"ic_tabbar_personal_light"] tabBarNames:@[@"",@"",@"",@""]];

}

#pragma mark --
#pragma mark --
#pragma mark -- Notifications 通知

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--->>>>  启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    NSLog(@"收到消息");
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用
/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""]  stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    NSLog(@"deviceID === %@",token);
    [KJCommonMethods saveValue:token key:DEVICE_ID];
    // 上传deviceToken 在首页推荐接口里
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送失败|||||||");
    NSLog(@"error -- %@",error);
}

#pragma mark - APP运行中接收到通知(推送)处理 (前台和后台)
/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo);
    application.applicationIconBadgeNumber = [userInfo[@"aps"][@"badge"] integerValue];;

    
    if (userInfo && !([application applicationState] == UIApplicationStateActive)) {
        //
        NSString *type = userInfo[@"type"];
        if ([type isEqualToString:@""]) {

        }else {
            [self clickNotification:userInfo];
        }
    }else {
        //
        NSString *type = userInfo[@"type"];
        if ([type isEqualToString:@""]) {

        }else {
            NSString *title = userInfo[@"title"];
            [KJCommonUI showAlertViewWithTitle:@"消息" message:title cancelButtonTitle:@"取消" sureButtonTitle:@"确定" inViewController:self.currentNav.topViewController cancelBlock:^{
                //
            } sureBlock:^{
                //
                [self clickNotification:userInfo];
            }];
        }
    }
    
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient]
                                     getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}
- (void)clickNotification:(NSDictionary *)userInfo {
}
#pragma mark -
#pragma mark - PRIVATE METHOD 支付宝

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",WX_APP_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //
    } else if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",WX_APP_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //
    } else if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
    }
    return YES;
}

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法
-(void)onResp:(BaseResp*)resp
{
    //这里判断回调信息是否为 支付
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
                //如果支付成功的话，全局发送一个通知，支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"成功"];
                break;
                
            default:
                //如果支付失败的话，全局发送一个通知，支付失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"失败"];
                break;
        }
    }
}


#pragma mark -
#pragma mark - PRIVATE METHOD 融云
- (void)RongYunInit {
    //添加测试token
    [KJCommonMethods saveValue:@"OqE76YEeB8Yyt+8OsOIjOaPH7uE6mN0vR3MemPklbYTPwfmgUreAh899/gk2HSmoiEBIfcEeTro=" key:ACCESS_TOKEN];
    //添加假的  101（当前登陆用户的融云token）
    [KJCommonMethods saveValue:RONGYUN_TOKEN_TEST101 key:RONGYUN_TOKEN];
    
    //初始化融云
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUND_APPKEY];
    if ([KJCommonMethods valueForkey:ACCESS_TOKEN]) {
        NSString *rongCloundToken = [KJCommonMethods valueForkey:RONGYUN_TOKEN];
        if (rongCloundToken) {
            [[RCIM sharedRCIM] connectWithToken:rongCloundToken success:^(NSString *userId) {
                NSLog(@"融云登陆成功。当前登录的用户userId：%@", userId);
                [self setDelegate];
            } error:^(RCConnectErrorCode status) {
                NSLog(@"融云登陆的错误码为:%ld", (long)status);
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"融云聊天token错误");
                [RongCloundUtils requestRongcloundToken:^(NSString *token) {
                    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                        NSLog(@"融云登陆成功。当前登录的用户userId：%@", userId);
                        [self setDelegate];
                    } error:^(RCConnectErrorCode status) {
                        NSLog(@"融云登陆的错误码为:%ld", (long)status);
                    } tokenIncorrect:^{
                        NSLog(@"融云聊天token错误");
                    }];
                }];
            }];
        }
    }
}

/**
 设置融云代理
 */
- (void)setDelegate {
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:[RongCloudManager shareManager]];
    [[RCIM sharedRCIM] setUserInfoDataSource:[RongCloudManager shareManager]];
    [[RCIM sharedRCIM] setGroupInfoDataSource:[RongCloudManager shareManager]];
    [RCContactCardKit shareInstance].groupDataSource = [RongCloudManager shareManager];
    //注册自定义消息
//    [[RCIM sharedRCIM] registerMessageType:[KJDynamicContent class]];
//    [[RCIM sharedRCIM] registerMessageType:[KJVideoMessage class]];
}
#pragma mark --
#pragma mark -- RCIMReceiveMessageDelegate
/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param left        还剩余的未接收的消息数，left>=0
 
 @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left {
    
    BOOL haveNewMessage = NO;
    if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] > 0) {
        haveNewMessage = YES;
    }
    HomeViewController *homeVC = (HomeViewController *)self.currentNav.viewControllers[0];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //显示新消息（红点提示）
        
    });
}

/*!
 当App处于后台时，接收到消息并弹出本地通知的回调方法
 
 @param message     接收到的消息
 @param senderName  消息发送者的用户名称
 @return            当返回值为NO时，SDK会弹出默认的本地通知提示；当返回值为YES时，SDK针对此消息不再弹本地通知提示
 
 @discussion 如果您设置了IMKit消息监听之后，当App处于后台，收到消息时弹出本地通知之前，会执行此方法。
 如果App没有实现此方法，SDK会弹出默认的本地通知提示。
 流程：
 SDK接收到消息 -> App处于后台状态 -> 通过用户/群组/群名片信息提供者获取消息的用户/群组/群名片信息
 -> 用户/群组信息为空 -> 不弹出本地通知
 -> 用户/群组信息存在 -> 回调此方法准备弹出本地通知 -> App实现并返回YES        -> SDK不再弹出此消息的本地通知
 -> App未实现此方法或者返回NO -> SDK弹出默认的本地通知提示
 
 
 您可以通过RCIM的disableMessageNotificaiton属性，关闭所有的本地通知(此时不再回调此接口)。
 
 @warning 如果App在后台想使用SDK默认的本地通知提醒，需要实现用户/群组/群名片信息提供者，并返回正确的用户信息或群组信息。
 参考RCIMUserInfoDataSource、RCIMGroupInfoDataSource与RCIMGroupUserInfoDataSource
 */
-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message
                      withSenderName:(NSString *)senderName {
    return NO;
}

/*!
 当App处于前台时，接收到消息并播放提示音的回调方法
 
 @param message 接收到的消息
 @return        当返回值为NO时，SDK会播放默认的提示音；当返回值为YES时，SDK针对此消息不再播放提示音
 
 @discussion 到消息时播放提示音之前，会执行此方法。
 如果App没有实现此方法，SDK会播放默认的提示音。
 流程：
 SDK接收到消息 -> App处于前台状态 -> 回调此方法准备播放提示音 -> App实现并返回YES        -> SDK针对此消息不再播放提示音
 -> App未实现此方法或者返回NO -> SDK会播放默认的提示音
 
 您可以通过RCIM的disableMessageAlertSound属性，关闭所有前台消息的提示音(此时不再回调此接口)。
 */
-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message {
    return NO;
}


@end
