//
//  KJImagePickerController.h
//  Grass
//
//  Created by 王振 on 15/12/2.
//  Copyright © 2015年 王振. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, SourceType) {
    SourceTypeCamera = 1,
    SourceTypePhotoLibrary,
    SourceTypeSavedPhotosAlbum,
    
};
@interface KJImagePickerController : UIImagePickerController

/**
 *  系统图片选择器
 *
 *  @param upperViewController 视图控制器调用者
 *  @param sourceType          图片来源
 *  @param finish              成功选择
 *  @param cancel              取消选择
 *
 *  @return KJImagePickerController
 */
+ (id)showImagePickControllerIn:(UIViewController *)upperViewController sourceType:(SourceType)sourceType image:(void(^)(UIImage *image))finish imagePickerControllerDidCancel:(void(^)(void))cancel;

/**
 *  RSK 圆形图片选择器
 *
 *  @param upperViewController 视图控制器调用者
 *  @param sourceType          图片来源
 *  @param finish              成功选择
 *  @param cancel              取消选择
 *
 *  @return KJImagePickerController
 */
+ (id)showRSKCircleImagePickControllerIn:(UIViewController *)upperViewController sourceType:(SourceType)sourceType image:(void(^)(UIImage *image))finish imagePickerControllerDidCancel:(void(^)(void))cancel;

/**
 *  RSK 方形图片选择器
 *
 *  @param upperViewController 视图控制器调用者
 *  @param sourceType          图片来源
 *  @param finish              成功选择
 *  @param cancel              取消选择
 *
 *  @return KJImagePickerController
 */
+ (id)showRSKSquareImagePickControllerIn:(UIViewController *)upperViewController sourceType:(SourceType)sourceType image:(void(^)(UIImage *image))finish imagePickerControllerDidCancel:(void(^)(void))cancel;

/**
 *  RSK 自定义宽高比例图片选择器
 *
 *  @param upperViewController 视图控制器调用者
 *  @param sourceType          图片来源
 *  @param ratio               自定义宽高比例
 *  @param finish              成功选择
 *  @param cancel              取消选择
 *
 *  @return KJImagePickerController
 */
+ (id)showRSKCustomImagePickControllerIn:(UIViewController *)upperViewController sourceType:(SourceType)sourceType withRatio:(float)ratio image:(void(^)(UIImage *image))finish imagePickerControllerDidCancel:(void(^)(void))cancel;
@end
