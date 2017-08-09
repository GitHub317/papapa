//
//  PHMoviesViewController.h
//  KJProject
//
//  Created by wangyang on 2017/4/25.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "BaseViewController.h"
#import <Photos/Photos.h>
typedef void(^PHGroupViewControllerBlock)(id result);

@interface PHMoviesViewController : BaseViewController
@property (copy, nonatomic) PHGroupViewControllerBlock block;
/**
 可以选取图片的数量
 */
@property (assign, nonatomic) NSInteger count;
@property (copy, nonatomic) NSString *titleString;

/**
 集合对象
 */
@property (strong, nonatomic) PHAssetCollection *assetCollection;
@end
