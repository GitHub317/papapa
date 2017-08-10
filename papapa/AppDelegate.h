//
//  AppDelegate.h
//  papapa
//
//  Created by 二师兄 on 2017/8/9.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GuideEndBlock)();
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *currentNav;

/**
 引导页结束回调
 */
@property(copy,nonatomic)GuideEndBlock guideEndBlock;

/**
 引导页
 */
@property(strong,nonatomic)UIScrollView *guidePageScrollView;

/**
 引导页上的pageControl
 */
@property(strong,nonatomic)UIPageControl * pageControl;

/**
 将某个viewcontroller设置为根视图
 
 @param classs 传入的viewcontroller
 */

- (void)singleViewControllerWithClass:(Class)classs;
/**
 present一个新的导航控制器
 
 @param class 要 present 的class
 @param animation 是否需要动画
 @param block 完成回调
 */
-(void)presentNewNavigationControllerWithClass:(Class)class Animation:(BOOL)animation block:(void(^)())block;


/**
 创建tabbar
 */
-(void)rootTabbarViewController;
@end

