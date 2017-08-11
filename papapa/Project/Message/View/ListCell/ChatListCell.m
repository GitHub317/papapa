//
//  ChatListCell.m
//  KJProject
//
//  Created by 二师兄 on 2017/4/25.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "ChatListCell.h"
@interface ChatListCell()
//上线
@property (nonatomic, strong) CALayer * topSeparator;
//下线
@property (nonatomic, strong) CALayer * bottomSeparator;

@property (nonatomic, strong) RCConversationModel *conversationModel;
@end

@implementation ChatListCell {
    UIImageView *_headImgView;
    UILabel *_unreadLabel;
    UILabel *_nameLabel;
    UILabel *_lastMessageLabel;
    UILabel *_timeLabel;
    UIImageView *_forbidView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self controlView];
    }
    return self;
}
- (void)controlView{
    _headImgView = [[UIImageView alloc] init];
    [self addSubview:_headImgView];
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.width.offset(45);
        make.height.offset(45);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    _headImgView.layer.cornerRadius = 45.0/2;
    _headImgView.layer.masksToBounds = YES;
    
    _unreadLabel = [[UILabel alloc]init];
    _unreadLabel.backgroundColor = [UIColor colorWithHexString:COLOR_COMMON];
    [self addSubview:_unreadLabel];
    [_unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgView.mas_top).offset(-8);
        make.left.equalTo(_headImgView.mas_right).offset(-8);
        make.width.offset(16);
        make.height.offset(16);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    _unreadLabel.textAlignment = NSTextAlignmentCenter;
    _unreadLabel.font = FONT(10);
    _unreadLabel.textColor = [UIColor colorWithHexString:@"232226"];
    _unreadLabel.layer.borderWidth = 1;
    _unreadLabel.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    _unreadLabel.layer.cornerRadius = [_unreadLabel getHeight] / 2.0;
    _unreadLabel.layer.masksToBounds = YES;
    _unreadLabel.hidden = YES;
    
    _nameLabel = [[UILabel alloc]init];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImgView.mas_right).offset(10);
        /*这里的效果是偏移头像中心Y点的一半*/
        make.centerY.equalTo(_headImgView.mas_centerY).offset(-70/2/2);
        make.right.offset(-80);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = FONT(16);
    _nameLabel.textColor = COLORHex(@"050505");
    
    _lastMessageLabel = [[UILabel alloc]init];
    [self addSubview:_lastMessageLabel];
    [_lastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImgView.mas_right).offset(10);
        /*这里的效果是偏移头像中心Y点的一半*/
        make.centerY.equalTo(_headImgView.mas_centerY).offset(70/2/2);
        make.right.offset(-12);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    _lastMessageLabel.textAlignment = NSTextAlignmentLeft;
    _lastMessageLabel.font = FONT(13);
    _lastMessageLabel.textColor = [UIColor colorWithHexString:@"676767"];
    
    _timeLabel = [[UILabel alloc]init];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(_nameLabel.mas_centerY).offset(0);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = FONT(11);
    _timeLabel.textColor = [UIColor colorWithHexString:COLOR_TEXTCOLOR];
    
    _forbidView = [[UIImageView alloc] initWithImage:IMAGE(@"icon_forbid")];
    [self addSubview:_forbidView];
    _forbidView.hidden = YES;
    [_forbidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SIZE(13, 16));
        make.top.equalTo(_timeLabel.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-30);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)showCellWithModel:(RCConversationModel *)model {
    self.conversationModel = model;
    //判断最后一条的消息类型
    NSLog(@"model.objectName === %@",model.objectName);
    if ([model.objectName isEqualToString:@"RC:TxtMsg"]) {
        //文字消息
        RCTextMessage * message = (RCTextMessage *)model.lastestMessage;
        _lastMessageLabel.text = message.content;
    } else if ([model.objectName isEqualToString:@"RC:ImgMsg"]) {
        //图片消息
        _lastMessageLabel.text = @"[图片]";
    }else if ([model.objectName isEqualToString:@"RC:VcMsg"]) {
        //语音消息
        _lastMessageLabel.text = @"[语音]";
    } else if ([model.objectName isEqualToString:@"RC:LBSMsg"]) {
        //位置消息
        _lastMessageLabel.text = @"[位置]";
    } else if ([model.objectName isEqualToString:@"RC:CardMsg"]) {
        //个人名片
        RCContactCardMessage *message = (RCContactCardMessage *)model.lastestMessage;
        _lastMessageLabel.text = [NSString stringWithFormat:@"%@向你推荐了%@",message.senderUserInfo.name,message.name];
    }else if ([model.objectName isEqualToString:@"RC:VideoMsg"]) {
        //视频
        _lastMessageLabel.text = @"[视频]";
    } else {
        _lastMessageLabel.text = @"";
    }
    if (model.lastestMessageDirection == 1) {
        // 发送   sentTime
        _timeLabel.text = [KJCommonMethods stringWith1970TimeString:[NSString stringWithFormat:@"%lld",model.sentTime] formatter:@"MM-dd HH:mm"];
    } else if (model.lastestMessageDirection == 2) {
        //接收  receivedTime
        _timeLabel.text = [KJCommonMethods stringWith1970TimeString:[NSString stringWithFormat:@"%lld",model.receivedTime] formatter:@"MM-dd HH:mm"];
    }
    if (model.unreadMessageCount == 0) {
        _unreadLabel.hidden = YES;
    }else {
        _unreadLabel.hidden = NO;
    }
    _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)model.unreadMessageCount];
//    if (model.isTop) {
//        self.backgroundColor = [UIColor colorWithHexString:@"4c4b53"];
//    }else {
//        self.backgroundColor = [UIColor colorWithHexString:@"403f46"];
//    }
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:model.conversationType targetId:model.targetId success:^(RCConversationNotificationStatus nStatus) {
        //
        if (nStatus == DO_NOT_DISTURB) {
            //
            _forbidView.hidden = NO;
        }else {
            //
            _forbidView.hidden = YES;
        }
    } error:^(RCErrorCode status) {
        //
    }];
}

-(void)showNameWith:(NSString *)name showHeadImgWithUrl:(NSString *)imgUrl {
    _nameLabel.text = name;
    if (self.conversationModel.conversationType == ConversationType_PRIVATE) {
        //暂时注释掉剪切头像
        //NSString *avatar = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fill,w_90,h_90,limit_0/auto-orient,0/quality,q_90",imgUrl];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:IMAGE(@"icon_header")];
    }else if (self.conversationModel.conversationType == ConversationType_GROUP) {
        //
        NSString *avatar = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fill,w_90,h_90,limit_0/auto-orient,0/quality,q_90",imgUrl];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:IMAGE(@"icon_groupHeader")];
    }
}
#pragma mark -
#pragma mark - getter
/*
 * bref 上线
 */
- (CALayer *)topSeparator {
    if (!_topSeparator) {
        _topSeparator = [[CALayer alloc] init];
        _topSeparator.backgroundColor = [UIColor colorWithHexString:@"c2c0c1"].CGColor;
        [self.layer addSublayer:_topSeparator];
    }
    return _topSeparator;
}

/*
 * bref 下线
 */
- (CALayer *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = [[CALayer alloc] init];
        _bottomSeparator.backgroundColor = [UIColor colorWithHexString:@"c2c0c1"].CGColor;
        [self.layer addSublayer:_bottomSeparator];
    }
    return _bottomSeparator;
}

//是否显示上下线 左右顶格
- (void)showTopSeparator:(BOOL)topShow
         bottomSeparator:(BOOL)bottomShow {
    if (topShow == YES) {
        self.topSeparator.hidden = NO;
        self.topSeparator.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    } else {
        self.topSeparator.hidden = YES;
    }
    if (bottomShow == YES) {
        self.bottomSeparator.hidden = NO;
        self.bottomSeparator.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    } else {
        self.bottomSeparator.hidden = YES;
    }
}
@end
