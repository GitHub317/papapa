//
//  UILabel+AutoSize.h
//  AutoSizeLabel
//
//  Created by 123 on 15/7/27.
//  Copyright (c) 2015年 Vision.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TextAligment) {
    Left = 0,
    Center,
    Right,
};

@interface UILabel (AutoSize)

- (void)autoSize;
- (void)autoWidthSize;
- (void)rect:(CGRect)rect center:(CGPoint)point aligment:(TextAligment)aligment font:(CGFloat)font isBold:(BOOL)isBold text:(NSString *)text textColor:(UIColor *)color superView:(UIView *)view;
- (void)rect:(CGRect)rect aligment:(TextAligment)aligment font:(CGFloat)font isBold:(BOOL)isBold text:(NSString *)text textColor:(UIColor *)color superView:(UIView *)view;
@end
