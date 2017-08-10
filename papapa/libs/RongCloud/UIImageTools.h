//
//  UIImageTools.h
//  KJProject
//
//  Created by wangyang on 2017/6/7.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageTools : NSObject

//图片转字符串
+ (NSString *)stringToBase64Str:(UIImage *)image;

//字符串转图片
+ (UIImage *)imageForBase64Str:(NSString *)encodedImageStr;

@end
