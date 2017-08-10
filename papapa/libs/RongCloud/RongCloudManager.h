//
//  RongCloudManager.h
//  KJProject
//
//  Created by wangyang on 2017/5/25.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RongCloudManager : NSObject <RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCCCGroupDataSource, RCIMConnectionStatusDelegate>

+ (instancetype)shareManager;

@end
