//
//  UIView+RefreshLayout.h
//  LangWind
//
//  Created by 二师兄 on 2017/5/16.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (RefreshLayout)

/**
 刷新layout ，让使用Masonry约束过的View可以立即使用frame参数
 */
-(void)refreshLayout;
@end
