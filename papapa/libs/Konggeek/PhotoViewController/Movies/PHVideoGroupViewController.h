//
//  PHVideoGroupViewController.h
//  KJProject
//
//  Created by wangyang on 2017/4/25.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^PHVideoGroupViewControllerBlock)(id result);

@interface PHVideoGroupViewController : BaseViewController

@property (copy, nonatomic) PHVideoGroupViewControllerBlock block;
/**
 可以选取图片的数量
 */
@property (assign, nonatomic) NSInteger count;

@property (assign, nonatomic) BOOL isVideo;
@end
