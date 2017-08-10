//
//  BaseViewController.m
//  wowobao_s
//
//  Created by 王振 DemoKing on 2016/10/17.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeViewController.h"
#import "PersonalViewController.h"
#import <WebKit/WebKit.h>

@interface BaseViewController ()<UIGestureRecognizerDelegate>

// 空白页
@property (strong, nonatomic) UIImageView *blankButton;

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self barButtonItemImageName:@"ic_login_back" position:@"left"];
    //[self changeNavAlpha:1 color:[UIColor colorWithHexString:COLOR_COMMON]];
    [self setNavBackgroundImage:IMAGE(@"ic_nav_background")];
    [self titleColor:@"ffffff" font:17];
    [self navigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTapInSelf];
    [self controlView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //  防止根视图侧滑出现卡顿
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark -
#pragma mark - PRIVATE

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
- (void)setUrlName:(NSString *)urlName {
    _urlName = urlName;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    NSString *path = [[NSBundle mainBundle] pathForResource:urlName ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

#pragma mark -
#pragma mark - PRIVATE METHOD 空白页

/**
 显示空白页
 */
- (void)showBlankViewWithImage:(NSString *)imageName frame:(CGRect)frame {
    self.blankButton.frame = frame;
    [self showBlankViewWithImage:imageName];
}

- (void)showBlankViewWithImage:(NSString *)imageName {
    [self.view bringSubviewToFront:self.blankButton];
    self.blankButton.hidden = NO;
    _blankButton.image = IMAGE(imageName);
}
- (void)showBlankView {
    [self.view bringSubviewToFront:self.blankButton];
    self.blankButton.hidden = NO;
}
- (void)hiddenBlanView {
    self.blankButton.hidden = YES;
}
/**
 此方法在父类不做处理
 */
-(void)controlView{
    
}
/**
 此方法在父类不做处理
 */
- (void)navigation {
    
}

- (UIImageView *)blankButton {
    if (!_blankButton) {
        _blankButton = [[UIImageView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _blankButton.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _blankButton.contentMode = UIViewContentModeCenter;
        [self.view addSubview:_blankButton];
    }
    return _blankButton;
}

#pragma mark -
#pragma mark - PRIVATE METHOD self.view 添加手势

- (void)addTapInSelf {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInSelf)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark -
#pragma mark - PRIVATE METHOD 隐藏导航下的线条

- (void)setNavigationLineHidden {
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

/**
 更改状态栏（导航要重写 preferredStatusBarStyle）
 创建导航时需要调用导航的扩展方法（preferredStatusBarStyle）

 @return return value description
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView" ]) {
        return NO;
    } else if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"UITableViewCellContentView" ]) {
        return NO;
    } else if ([NSStringFromClass([touch.view.superview.superview class]) isEqualToString:@"ImageCell" ]) {
        return NO;
    } else if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"ThirdClassCell"]) {
        return NO;
    } else if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"ClassCollectionCell" ]) {
        return NO;
    } else if ([NSStringFromClass([touch.view class]) isEqualToString:@"ClearHistoryCollectionViewCell"]) {
        return NO;
    } else if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"ClearHistoryCollectionViewCell"]) {
        return NO;
    }else if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"EvaluateCell"]) {
        return NO;
    }
    return YES;
}
#pragma mark -
#pragma mark - INTERFACE

- (void)tapInSelf {
    [self.view endEditing:YES];
}

- (void)barImageTap:(UITapGestureRecognizer *)tap {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushVC:(BaseViewController *)vc animated:(BOOL)animated {
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)goHomeVC {
    UITabBarController * tabbrVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tabbrVC.navigationController popToRootViewControllerAnimated:YES];
    tabbrVC.selectedIndex = 0;
}

//是否隐藏第三方登录、分享等，防止审核不通过
- (BOOL)isCheckIng {
    NSString *latestPublishedVersion  = [[NSUserDefaults standardUserDefaults] objectForKey:@"latestPublishedVersion"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (latestPublishedVersion && [appVersion compare:latestPublishedVersion]!=NSOrderedDescending) {//如果当前app的版本不大于最新审核通过的版本，则显示第三方登录
        return NO;
    }else{
        return YES;
    }
}

- (void)dealloc {
    NSString *string = [NSString stringWithFormat:@"%@释放了",NSStringFromClass([self class])];
    NSLog(@"%@", string);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
