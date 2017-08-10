//
//  RongCloundUtils.m
//  KJProject
//
//  Created by wangyang on 2017/5/9.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "RongCloundUtils.h"

@implementation RongCloundUtils

/**
 重新获取融云token
 
 @param complete complete description
 */
+ (void)requestRongcloundToken:(void(^)(NSString *token))complete {
    if ([KJCommonMethods valueForkey:ACCESS_TOKEN]) {
        [RequestEngine postRequestWithDitionary:nil url:@"/user/get_rong_token.htm" block:^(ResponseMessage *responseMessage) {
            [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
                if (success) {
                    //
                    [UserInfo shareManager].rongCloudToken = responseMessage.responseObject[@"data"];
                    [KJCommonMethods saveValue:[UserInfo shareManager].rongCloudToken key:RONGYUN_TOKEN];
                    if (complete) {
                        complete(responseMessage.responseObject[@"data"]);
                    }
                }else {
//                    ERROR_MESSAGE
                }
            }];
        }];
    }
}
/**
 请求聊天室id
 
 @param province 省
 @param city 市
 @param complete 请求成功回调
 */
+ (void)requestChatRoomIdWithProvince:(NSString *)province city:(NSString *)city complete:(void(^)(ChatBaseModel *chatModel))complete {
    [RequestEngine postRequestWithDitionary:@{@"province":province,@"city":city} url:@"/chat_room/my_room.htm" block:^(ResponseMessage *responseMessage) {
        [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
            if (success) {
                //
                ChatBaseModel * chatRoomInfo = [ChatBaseModel mj_objectWithKeyValues:responseMessage.responseObject[@"data"]];
                if (complete) {
                    complete(chatRoomInfo);
                }
            }else {
                ERROR_MESSAGE
            }
        }];
    }];
}

/**
 根据用户id获取用户信息
 
 @param userId userId description
 @param complete complete description
 */
+ (void)requestUserInfoWithUserId:(NSString *)userId complete:(void(^)(UserModel *userModel))complete {
    [RequestEngine postRequestWithDitionary:@{@"userId":userId} url:@"/user/query_name_avatar.htm" block:^(ResponseMessage *responseMessage) {
        [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
            if (success) {
                //
                UserModel *userModel = [UserModel mj_objectWithKeyValues:responseMessage.responseObject[@"data"]];
                if (complete) {
                    complete(userModel);
                }
            }else {
                ERROR_MESSAGE
            }
        }];
    }];
}

/**
 根据群组id获取群组信息
 
 @param groupId groupId description
 @param complete complete description
 */
+ (void)requestGroupInfoWithGroupId:(NSString *)groupId complete:(void(^)(ChatBaseModel *chatModel))complete {
    PROGRESS_SHOW
    [RequestEngine postRequestWithDitionary:@{@"groupId":groupId} url:@"/group/query_group.htm" block:^(ResponseMessage *responseMessage) {
        [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
            PROGRESS_HIDDEN
            if (success) {
                //
                ChatBaseModel *chatModel = [ChatBaseModel mj_objectWithKeyValues:responseMessage.responseObject[@"data"]];
                if (complete) {
                    complete(chatModel);
                }
            }else {
                ERROR_MESSAGE
            }
        }];
    }];
}

/**
 发起群聊·
 
 @param groupName groupName description
 @param userId userId description
 complete:(void(^)(ChatBaseModel *chatModel))complete
 */
+ (void)requestGroupChatWithGroupName:(NSString *)groupName useId:(NSString *)userId complete:(void(^)(ChatBaseModel *chatModel))complete {
    PROGRESS_SHOW
    [RequestEngine postRequestWithDitionary:@{@"name":groupName,
                                              @"userId":userId}
                                        url:@"/group/add_group.htm"
                                      block:^(ResponseMessage *responseMessage) {
        [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
            PROGRESS_HIDDEN
            if (success) {
                //
                ChatBaseModel *chatModel = [ChatBaseModel mj_objectWithKeyValues:responseMessage.responseObject[@"data"]];
                if (complete) {
                    complete(chatModel);
                }
            }else {
                ERROR_MESSAGE
            }
        }];
    }];
}

/**
 添加群聊成员
 
 @param groupId groupId description
 @param userId userId description
 @param complete complete description
 */
+ (void)requestAddGroupMemberWithGroupId:(NSNumber *)groupId userId:(NSString *)userId complete:(void(^)())complete {
    PROGRESS_SHOW
    [RequestEngine postRequestWithDitionary:@{@"groupId":groupId,
                                              @"userId":userId}
                                        url:@"/group/add_member.htm"
                                      block:^(ResponseMessage *responseMessage) {
                                          [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
                                              PROGRESS_HIDDEN
                                              if (success) {
                                                  //
                                                  if (complete) {
                                                      complete();
                                                  }
                                              }else {
                                                  ERROR_MESSAGE
                                              }
                                          }];
                                      }];
}

/**
 删除群聊成员
 
 @param groupId groupId description
 @param userId userId description
 @param complete complete description
 */
+ (void)requestDeleteGroupMemberWithGroupId:(NSNumber *)groupId userId:(NSString *)userId complete:(void(^)())complete {
    PROGRESS_SHOW
    [RequestEngine postRequestWithDitionary:@{@"groupId":groupId,
                                              @"userId":userId}
                                        url:@"/group/delete_member.htm"
                                      block:^(ResponseMessage *responseMessage) {
                                          [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
                                              PROGRESS_HIDDEN
                                              if (success) {
                                                  //
                                                  if (complete) {
                                                      complete();
                                                  }
                                              }else {
                                                  ERROR_MESSAGE
                                              }
                                          }];
                                      }];
}

/**
 退出群聊/ 解散群组
 
 @param groupId groupId description
 @param isDelete isDelete description
 @param complete complete description
 */
+ (void)requestExitGroupWithGroupId:(NSNumber *)groupId isDelete:(BOOL)isDelete complete:(void(^)())complete {
    NSString *url;
    if (isDelete) {
        url = @"/group/quit_group.htm";
    }else {
        url = @"/group/quit_group.htm";
    }
    PROGRESS_SHOW
    [RequestEngine postRequestWithDitionary:@{@"groupId":groupId} url:url block:^(ResponseMessage *responseMessage) {
        [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
            PROGRESS_HIDDEN
            if (success) {
                //
                [[NSNotificationCenter defaultCenter] postNotificationName:EXIT_GROUP_NOTIFICATION object:nil];
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:[NSString stringWithFormat:@"%@",groupId]];
                if (complete) {
                    complete();
                }
            }else {
                ERROR_MESSAGE
            }
        }];
    }];
}

/**
 修改群头像
 
 @param groupId groupId description
 @param logoUrl logoUrl description
 @param complete complete description
 */
+ (void)requestChangeGroupImageWithGroupId:(NSNumber *)groupId logoUrl:(NSString *)logoUrl complete:(void(^)())complete {
    PROGRESS_SHOW
    [RequestEngine postRequestWithDitionary:@{@"groupId":groupId,
                                              @"logoUrl":logoUrl}
                                        url:@"/group/update_logo.htm"
                                      block:^(ResponseMessage *responseMessage) {
                                          [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
                                              PROGRESS_HIDDEN
                                              if (success) {
                                                  //
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:EXIT_GROUP_NOTIFICATION object:nil];
                                                  if (complete) {
                                                      complete();
                                                  }
                                              }else {
                                                  ERROR_MESSAGE
                                              }
                                          }];
                                      }];
}

/**
 聊天室禁言
 
 @param userId userId description
 @param chatRoomId chatRoomId description
 @param duration duration description
 @param complete complete description
 */
+ (void)requestForbidTalkWithUserId:(NSString *)userId chatRoomId:(NSString *)chatRoomId duration:(NSNumber *)duration complete:(void(^)())complete {
    PROGRESS_SHOW
    [RequestEngine postRequestWithDitionary:@{@"userId":userId,
                                              @"chatRoomId":chatRoomId,
                                              @"duration":duration}
                                        url:@"/chat_room/set_silence.htm"
                                      block:^(ResponseMessage *responseMessage) {
                                          [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
                                              PROGRESS_HIDDEN
                                              if (success) {
                                                  //
                                                  if (complete) {
                                                      complete();
                                                  }
                                              }else {
                                                  ERROR_MESSAGE
                                              }
                                          }];
                                      }];
}

/**
 聊天室解除禁言
 
 @param userId userId description
 @param chatRoomId chatRoomId description
 @param complete complete description
 */
+ (void)requestTalkWithUserId:(NSString *)userId chatRoomId:(NSString *)chatRoomId complete:(void(^)())complete {
    PROGRESS_SHOW
    [RequestEngine postRequestWithDitionary:@{@"userId":userId,
                                              @"chatRoomId":chatRoomId}
                                        url:@"/chat_room/remove_silence.htm"
                                      block:^(ResponseMessage *responseMessage) {
                                          [RequestEngine checkResponseMessage:responseMessage success:^(BOOL success) {
                                              PROGRESS_HIDDEN
                                              if (success) {
                                                  //
                                                  if (complete) {
                                                      complete();
                                                  }
                                              }else {
                                                  ERROR_MESSAGE
                                              }
                                          }];
                                      }];
}

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
                                     error:(void(^)(RCErrorCode status))error {
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:conversationType targetId:targeId isBlocked:isBlocked success:^(RCConversationNotificationStatus nStatus) {
        //
        if (complete) {
            complete();
        }
    } error:^(RCErrorCode status) {
        //
        if (error) {
            error(status);
        }
    }];
}

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
                           complete:(void(^)())complete {
    BOOL isSuccess = [[RCIMClient sharedRCIMClient] setConversationToTop:conversationType targetId:targeId isTop:isTop];
    if (isSuccess) {
        if (complete) {
            complete();
        }
    }
}








@end
