//
//  UIButton+Category.m
//  Renshine
//
//  Created by 王振 on 16/2/16.
//  Copyright © 2016年 杭州空极科技有限公司. All rights reserved.
//

#import "UIButton+Category.h"

#define COLOR_TITLE_LIGHT @"ffffff"
#define COLOR_TITLE_DARK @"fe7d00"
#define COLOR_BG_LIGHT @"d66900"
#define COLOR_BG_DARK @"d66900"

#define COLOR_COMMON_CODE @"e87400"
#define COLOR_COUNTDOWN_CODE @"777777"

@implementation UIButton (Category)
/**
 *  60 秒倒计时
 */
- (void)countdown:(void (^)(void))complete {
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self setUserInteractionEnabled:YES];
                self.enabled = YES;
                [self setTitleColor:[UIColor colorWithHexString:COLOR_COMMON_CODE] forState:UIControlStateNormal];
                complete ();
            });
        }else{
            int seconds = timeout - 1;
            NSString *strTime = [NSString stringWithFormat:@"%d 秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:strTime forState:UIControlStateNormal];
                [self setTitleColor:[UIColor colorWithHexString:COLOR_COUNTDOWN_CODE] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
}
/**
 *  可点击状态
 */
- (void)lightState {
    self.enabled = YES;
    self.backgroundColor = [UIColor colorWithHexString:COLOR_BG_LIGHT];
    [self setTitleColor:[UIColor colorWithHexString:COLOR_TITLE_LIGHT] forState:UIControlStateNormal];
}
/**
 *  不可点击状态
 */
- (void)darkState {
    self.enabled = NO;
    self.backgroundColor = [UIColor colorWithHexString:COLOR_BG_DARK];
    [self setTitleColor:[UIColor colorWithHexString:COLOR_TITLE_DARK] forState:UIControlStateNormal];
}
@end
