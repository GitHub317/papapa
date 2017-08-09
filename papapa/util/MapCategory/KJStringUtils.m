//
//  KJStringUtils.m
//  KJProject
//
//  Created by wangyang on 2017/4/13.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "KJStringUtils.h"

@implementation KJStringUtils

/**
 获取内容的高
 @param width 宽度
 @param content 内容
 @param font 字号
 @return 高度
 */
+ (CGFloat)getHeightWithWidth:(CGFloat)width font:(CGFloat)font Content:(NSString *)content {
    UILabel *label = [[UILabel alloc] initWithFrame:RECT(0, 0, width, 100)];
    label.font = FONT(font);
    label.text = content;
    [label autoSize];
    CGFloat height = label.frame.size.height;
    label = nil;
    return height;
}


/**
 *  自适应字体
 */
+ (CGFloat)sizeWithString:(NSString*)string font:(UIFont*)font width:(float)width {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width,80000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    CGFloat height = ceil(CGRectGetWidth(rect));
    return height;
}

/**
 获取内容的宽
 
 @param string string description
 @param font font description
 @return return value description
 */
+ (CGFloat)sizeWithString:(NSString *)string font:(CGFloat)font {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(8000,font) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(font)} context:nil];
    CGFloat width = ceil(CGRectGetWidth(rect));
    return width;
}
@end
