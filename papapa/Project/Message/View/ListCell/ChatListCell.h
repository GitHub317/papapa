//
//  ChatListCell.h
//  KJProject
//
//  Created by 二师兄 on 2017/4/25.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface ChatListCell : RCConversationBaseCell
//是否显示上下线 左右顶格
- (void)showTopSeparator:(BOOL)topShow
         bottomSeparator:(BOOL)bottomShow;
-(void)showCellWithModel:(RCConversationModel *)model;
-(void)showNameWith:(NSString *)name showHeadImgWithUrl:(NSString *)imgUrl;
@end
