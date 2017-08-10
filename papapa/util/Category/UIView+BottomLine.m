//
//  UIView+BottomLine.m
//  Yidexuepin
//
//  Created by 二师兄 on 2017/7/28.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "UIView+BottomLine.h"

@implementation UIView (BottomLine)

/**
 添加底部灰色线条
 */
-(void)bottomLineWithColor:(UIColor *)color{
    UILabel * label = [[UILabel alloc]init];
    [self addSubview:label];
    [self refreshLayout];
    label.frame = RECT(0, self.frame.size.height-1, self.frame.size.width, 1);
    label.backgroundColor = color;
}
@end
