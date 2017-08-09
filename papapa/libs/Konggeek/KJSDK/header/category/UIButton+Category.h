//
//  UIButton+Category.h
//  Renshine
//
//  Created by 王振 on 16/2/16.
//  Copyright © 2016年 杭州空极科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)
/**
 *  60 秒倒计时
 */
- (void)countdown:(void(^)(void))complete;
/**
 *  可点击状态
 */
- (void)lightState;
/**
 *  不可点击状态
 */
- (void)darkState;
@end
