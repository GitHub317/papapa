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
@interface AppDelegate ()<WXApiDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self rootVCandGuide];
    //初始化各个组件
    [self OSSInitialize];
    
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


@end
