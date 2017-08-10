//
//  AppDelegate+RootViewController.h
//  wowobao_s
//
//  Created by 王振 DemoKing on 2016/10/17.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (RootViewController)<UITabBarControllerDelegate,UIScrollViewDelegate>

/**
 *  主页成为根数图控制器
 */
- (void)tabBarControllerWithControllers:(NSArray *)controllers darkImageNames:(NSArray *)darkImageNames lightImageNames:(NSArray *)lightImageNames tabBarNames:(NSArray *)names;

/**
 设置引导页

 @param images 引导页图片数组
 @param start 开始回调
 */
- (void)leaderPageWithImages:(NSArray *)images start:(void(^)(void))start;



@end
