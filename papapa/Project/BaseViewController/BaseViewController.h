//
//  BaseViewController.h
//  wowobao_s
//
//  Created by 王振 DemoKing on 2016/10/17.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 web页的本地文件名称 html
 */
@property (copy, nonatomic) NSString *urlName;

/**
 web页URL
 */
@property (copy, nonatomic) NSString *urlString;
/**
 刷新页面所使用的index
 */
@property (assign, nonatomic) NSInteger pageNumber;
/**
 总页数
 */
@property (assign, nonatomic) NSInteger pageCount;

/**
 显示空白页
 */
- (void)showBlankViewWithImage:(NSString *)imageName frame:(CGRect)frame;

/**
 显示空白页
 */
- (void)showBlankViewWithImage:(NSString *)imageName;

/**
 显示空白页
 */
- (void)showBlankView;

/**
 隐藏空白页
 */
- (void)hiddenBlanView;

/**
 此方法在父类不做处理
 */
- (void)navigation;
/**
 此方法在父类不做处理
 */
-(void)controlView;

- (void)pushVC:(BaseViewController *)vc animated:(BOOL)animated;

- (void)goHomeVC;

/**
 是否在审核

 @return return value description
 */
- (BOOL)isCheckIng;
@end
