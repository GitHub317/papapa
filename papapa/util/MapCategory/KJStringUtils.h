//
//  KJStringUtils.h
//  KJProject
//
//  Created by wangyang on 2017/4/13.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJStringUtils : NSObject

/**
 获取内容的高
 @param width 宽度
 @param content 内容
 @param font 字号
 @return 高度
 */
+ (CGFloat)getHeightWithWidth:(CGFloat)width font:(CGFloat)font Content:(NSString *)content;

/**
 *  自适应字体
 */
+ (CGFloat)sizeWithString:(NSString*)string font:(UIFont*)font width:(float)width;


/**
 获取内容的宽

 @param string string description
 @param font font description
 @return <#return value description#>
 */
+ (CGFloat)sizeWithString:(NSString *)string font:(CGFloat)font;

@end
