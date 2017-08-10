//
//  UIImageTools.m
//  KJProject
//
//  Created by wangyang on 2017/6/7.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "UIImageTools.h"

@implementation UIImageTools

//图片转字符串
+ (NSString *)stringToBase64Str:(UIImage *) image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//字符串转图片
+ (UIImage *)imageForBase64Str:(NSString *)encodedImageStr {
    NSData *decodedImageData   = [[NSData alloc] initWithBase64Encoding:encodedImageStr];
    UIImage *decodedImage      = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}

@end
