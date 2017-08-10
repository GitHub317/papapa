//
//  AppDelegate+RootViewController.m
//  wowobao_s
//
//  Created by 王振 DemoKing on 2016/10/17.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import "AppDelegate+RootViewController.h"
/**
 *  自定义button 让点击事件通过block回调
 */

typedef void (^ButtonBlock)(void);
@interface Button : UIButton

@property (strong, nonatomic) ButtonBlock touch;

@end
@implementation Button
- (void)target {
    [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonClick {
    if (_touch) {
        _touch();
    }
}
@end
@implementation AppDelegate (RootViewController)

/**
 *  主页成为根数图控制器
 */
- (void)tabBarControllerWithControllers:(NSArray *)controllers darkImageNames:(NSArray *)darkImageNames lightImageNames:(NSArray *)lightImageNames tabBarNames:(NSArray *)names {
    UIWindow *window = self.window;
    
    NSArray *arrayColor = @[COLOR_COMMON,@"595656",@"36bcde",@"36bcde"];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < controllers.count; i ++) {
        //图标
        UIImage * image1 = IMAGE(lightImageNames [i]);
        image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * image2 = IMAGE(darkImageNames [i]);
        image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIViewController *vc = [[[controllers [i] class] alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [nav preferredStatusBarStyle];
        nav.tabBarItem.title = names [i];
        nav.tabBarItem.image = image2;
        nav.tabBarItem.selectedImage = image1;
        nav.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0);
        [array addObject:nav];
        // 设置标题样式
        [nav.tabBarItem setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:arrayColor [i]],
          NSForegroundColorAttributeName,
          [UIFont fontWithName:@"ProximaNova-Semibold" size:0.0],
          NSFontAttributeName,
          nil]
                                      forState:UIControlStateSelected];
        if (i == 0) {
            self.currentNav = nav;
        }
    }
    
    // 创建 tabBar
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    tabBarController.viewControllers = array;
    
    // 递交跟视图控制器
    window.rootViewController = tabBarController;
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
   // NSLog(@"--tabbaritem.title--%@",viewController.tabbaritem.title);
    
    //这里我判断的是当前点击的tabBar
    self.currentNav = (UINavigationController *)viewController;
    return YES;
}



/**
 *  设置引导页
 *
 *  @param images images
 */
- (void)leaderPageWithImages:(NSArray *)images start:(void(^)(void))start {
    UIViewController *viewController = [[UIViewController alloc] init];
    self.window.rootViewController = viewController;
    
    self.guidePageScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.guidePageScrollView.pagingEnabled = YES;
    self.guidePageScrollView.delegate = self;
    self.guidePageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * images.count, SCREEN_HEIGHT);
    self.guidePageScrollView.showsHorizontalScrollIndicator = FALSE;
    [viewController.view addSubview:self.guidePageScrollView];
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.numberOfPages = images.count;
    self.pageControl.pageIndicatorTintColor = COLORHex(@"d6d6d7");
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"ffffff"];
    self.pageControl.frame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 20);
    [viewController.view addSubview:self.pageControl];


    for (int i = 0; i < images.count; i ++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        image.image = IMAGE(images [i]);
        [self.guidePageScrollView addSubview:image];
        image.userInteractionEnabled = YES;
//        if (i==images.count-1) {
//            Button *button = [[Button alloc] init];
//            [image addSubview:button];
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.offset(-90*HEIGHT_MULTIPLE);
//                make.centerX.offset(0);
//                make.width.offset(130);
//                make.height.offset(45);
//            }];
//            [button target];
//            button.backgroundColor = [UIColor clearColor];
//            button.touch = ^{
//                start();
//            };
//        }
    }
    

}
#pragma mark -
#pragma mark - PRIVATE METHOD 滑动代理以及pageControl滑动事件
//滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.guidePageScrollView)
    {
        //根据scrollView的偏移量，改变pageControl的当前页数
        self.pageControl.currentPage = self.guidePageScrollView.contentOffset.x /SCREEN_WIDTH;
        if (self.guidePageScrollView.contentOffset.x /SCREEN_WIDTH > 1.1) {
            [UIView animateWithDuration:0.5 animations:^{
                self.guidePageScrollView.frame = RECT(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                if (self.guideEndBlock) {
                    self.guideEndBlock();
                }
            }];
        }
    }
}



@end
