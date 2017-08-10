//
//  RongCloudManager.m
//  KJProject
//
//  Created by wangyang on 2017/5/25.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "RongCloudManager.h"
#import "LoginViewController.h"
static RongCloudManager *manager;

@implementation RongCloudManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RongCloudManager alloc] init];
    });
    return manager;
}

#pragma mark -
#pragma mark - <RCIMUserInfoDataSource, RCIMGroupInfoDataSource>

/*!
 获取用户信息
 
 @param userId      用户ID
 @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
 
 @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    if ([userId integerValue] == [[UserInfo shareManager].Id integerValue]) {
        RCUserInfo *rcUserInfo = [[RCIM sharedRCIM] getUserInfoCache:userId];
        if (!rcUserInfo) {
            rcUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:[UserInfo shareManager].nickName portrait:[UserInfo shareManager].avatarUrl];
            [[RCIM sharedRCIM] refreshUserInfoCache:rcUserInfo withUserId:userId];
        }
        return completion(rcUserInfo);
    }else {
        //根据存储联系人信息的模型，通过 userId 来取得对应的name和头像url，进行以下设置（此处因为项目接口尚未实现，所以就只能这样给大家说说，请见谅）
        __block RCUserInfo *rcUserInfo = [[RCIM sharedRCIM] getUserInfoCache:userId];
        if (!rcUserInfo) {
            [RongCloundUtils requestUserInfoWithUserId:userId complete:^(UserModel *userModel) {
                rcUserInfo = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%@",userModel.Id] name:userModel.nickName portrait:userModel.avatarUrl];
                [[RCIM sharedRCIM] refreshUserInfoCache:rcUserInfo withUserId:[NSString stringWithFormat:@"%@",userModel.Id]];
                return completion(rcUserInfo);
            }];
        }
        return completion(rcUserInfo);
    }
}

/*!
 获取群组信息
 
 @param groupId     群组ID
 @param completion  获取群组信息完成之后需要执行的Block [groupInfo:该群组ID对应的群组信息]
 
 @discussion SDK通过此方法获取用户信息并显示，请在completion的block中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion {
    [RongCloundUtils requestGroupInfoWithGroupId:groupId complete:^(ChatBaseModel *chatModel) {
        RCGroup *groupInfo = [[RCGroup alloc] initWithGroupId:[NSString stringWithFormat:@"%@",chatModel.Id] groupName:chatModel.name portraitUri:chatModel.logoUrl];
        [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:groupId];
        completion(groupInfo);
    }];
}

#pragma mark --
#pragma mark -- RCCCGroupDataSource

/*!
 获取当前群组信息的回调
 
 @param groupId     群ID
 @param resultBlock 获取成功 [groupInfo:群组信息]
 */
- (void)getGroupInfoByGroupId:(NSString *)groupId
                       result:(void (^)(RCCCGroupInfo *groupInfo))resultBlock {
    [RongCloundUtils requestGroupInfoWithGroupId:groupId complete:^(ChatBaseModel *chatModel) {
        RCCCGroupInfo *groupInfo = [[RCCCGroupInfo alloc] initWithGroupId:[NSString stringWithFormat:@"%@",chatModel.Id] groupName:chatModel.name portraitUri:chatModel.logoUrl];
        resultBlock(groupInfo);
    }];
}

#pragma mark --
#pragma mark -- RCIMConnectionStatusDelegate

/**
 监听连接状态
 
 @param status status description
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD(@"当前用户在其他设备上登录，此设备被踢下线，请重新登录")
            
            AppDelegate *app = APPDELEGATE;
            [app presentNewNavigationControllerWithClass:[LoginViewController class] Animation:YES block:^{
                //
                [app.currentNav popToRootViewControllerAnimated:YES];
            }];
        });
    }
}


@end
