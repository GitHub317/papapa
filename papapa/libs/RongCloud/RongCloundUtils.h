//
//  RongCloundUtils.h
//  KJProject
//
//  Created by wangyang on 2017/5/9.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatBaseModel.h"
#import "UserModel.h"
@interface RongCloundUtils : NSObject

/**
 重新获取融云token
 
 @param complete complete description
 */
+ (void)requestRongcloundToken:(void(^)(NSString *token))complete;

/**
 请求聊天室id

 @param province 省
 @param city 市
 @param complete 请求成功回调
 */
+ (void)requestChatRoomIdWithProvince:(NSString *)province city:(NSString *)city complete:(void(^)(ChatBaseModel *chatModel))complete;


/**
 根据用户id获取用户信息

 @param userId userId description
 @param complete complete description
 */
+ (void)requestUserInfoWithUserId:(NSString *)userId complete:(void(^)(UserModel *userModel))complete;

/**
 根据群组id获取群组信息
 
 @param groupId groupId description
 s
 */
+ (void)requestGroupInfoWithGroupId:(NSString *)groupId complete:(void(^)(ChatBaseModel *chatModel))complete;

/**
 发起群聊·

 @param groupName groupName description
 @param userId userId description
 complete:(void(^)(ChatBaseModel *chatModel))complete
 */
+ (void)requestGroupChatWithGroupName:(NSString *)groupName useId:(NSString *)userId complete:(void(^)(ChatBaseModel *chatModel))complete;

/**
 添加群聊成员

 @param groupId groupId description
 @param userId userId description
 @param complete complete description
 */
+ (void)requestAddGroupMemberWithGroupId:(NSNumber *)groupId userId:(NSString *)userId complete:(void(^)())complete;

/**
 删除群聊成员
 
 @param groupId groupId description
 @param userId userId description
 @param complete complete description
 */
+ (void)requestDeleteGroupMemberWithGroupId:(NSNumber *)groupId userId:(NSString *)userId complete:(void(^)())complete;

/**
 退出群聊/ 解散群组

 @param groupId groupId description
 @param isDelete isDelete description
 @param complete complete description
 */
+ (void)requestExitGroupWithGroupId:(NSNumber *)groupId isDelete:(BOOL)isDelete complete:(void(^)())complete;

/**
 修改群头像

 @param groupId groupId description
 @param logoUrl logoUrl description
 @param complete complete description
 */
+ (void)requestChangeGroupImageWithGroupId:(NSNumber *)groupId logoUrl:(NSString *)logoUrl complete:(void(^)())complete;

/**
 聊天室禁言

 @param userId userId description
 @param chatRoomId chatRoomId description
 @param duration duration description
 @param complete complete description
 */
+ (void)requestForbidTalkWithUserId:(NSString *)userId chatRoomId:(NSString *)chatRoomId duration:(NSNumber *)duration complete:(void(^)())complete;

/**
 聊天室解除禁言
 
 @param userId userId description
 @param chatRoomId chatRoomId description
 @param complete complete description
 */
+ (void)requestTalkWithUserId:(NSString *)userId chatRoomId:(NSString *)chatRoomId complete:(void(^)())complete;

/**
 设置群组 单聊 消息免打扰

 @param conversationType conversationType description
 @param targeId targeId description
 @param isBlocked isBlocked description
 @param complete complete description
 @param error error description
 */
+ (void)setNotificationWithConversationTye:(RCConversationType)conversationType
                                  targetId:(NSString *)targeId
                                 isBlocked:(BOOL)isBlocked
                                  complete:(void(^)())complete
                                     error:(void(^)(RCErrorCode status))error;
/**
 设置群组 单聊 置顶
 
 @param conversationType conversationType description
 @param targeId targeId description
 @param isTop isTop description
 @param complete complete description
 */
+ (void)setIsTopWithConversationTye:(RCConversationType)conversationType
                           targetId:(NSString *)targeId
                              isTop:(BOOL)isTop
                           complete:(void(^)())complete;
@end
