//
//  UIView+RefreshLayout.m
//  LangWind
//
//  Created by 二师兄 on 2017/5/16.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "UIView+RefreshLayout.h"

@implementation UIView (RefreshLayout)
-(void)refreshLayout{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self.superview layoutSubviews];
}
@end
