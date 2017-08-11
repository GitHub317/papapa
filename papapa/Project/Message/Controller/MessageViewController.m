//
//  MessageViewController.m
//  papapa
//
//  Created by 二师兄 on 2017/8/10.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "MessageViewController.h"
#import "ChatListCell.h"
#import "BaseChatViewController.h"
@interface MessageViewController ()
//列表数据
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation MessageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self navigation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self controlView];
    [self chatSetUp];
    [self controlTableView];
}

- (void)navigation{
    self.navigationItem.title = @"消息";
    [self setNavBackgroundImage:IMAGE(@"ic_nav_background")];
    [self titleColor:@"ffffff" font:17];
}
-(void)controlView{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
}
/**
 会话列表需要显示哪些类型的会话
 */
-(void)chatSetUp {
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_GROUP)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    //    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
    //                                          @(ConversationType_GROUP)]];
    [[RCIM sharedRCIM] setUserInfoDataSource:[RongCloudManager shareManager]];
    [[RCIM sharedRCIM] setGroupInfoDataSource:[RongCloudManager shareManager]];
    [RCContactCardKit shareInstance].groupDataSource = [RongCloudManager shareManager];
}
#pragma mark -
#pragma mark - PRIVATE METHOD  获取当前cell的信息
- (void)loadCellWithUserInfo:(NSIndexPath *)indexPath Cell:(ChatListCell *)cell WithModel:(RCConversationModel *)model{
    //在此请求用户头像和名字
    if (model.conversationType == ConversationType_PRIVATE) {
        [RongCloundUtils requestUserInfoWithUserId:model.targetId complete:^(UserModel *userModel) {
            [cell showCellWithModel:model];
            [cell showNameWith:userModel.nickName showHeadImgWithUrl:userModel.avatarUrl];
        }];
    }else if (model.conversationType == ConversationType_GROUP) {
        [RongCloundUtils requestGroupInfoWithGroupId:model.targetId complete:^(ChatBaseModel *chatModel) {
            [cell showCellWithModel:model];
            [cell showNameWith:chatModel.name showHeadImgWithUrl:chatModel.logoUrl];
        }];
    }
}

#pragma mark -
#pragma mark - VIEWS

/**
 创建会话列表
 */
- (void)controlTableView {
    self.conversationListTableView.frame = RECT(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    self.conversationListTableView.backgroundColor = [UIColor whiteColor];
    //设置tableview上多余的线条
    self.conversationListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.conversationListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.conversationListTableView.delegate = self;
    self.conversationListTableView.dataSource = self;
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark -
#pragma mark - DATA SOURCE

/**
 数据源
 
 @param dataSource dataSource description
 @return return value description
 */
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
    [self.dataArray removeAllObjects];
    [dataSource enumerateObjectsUsingBlock:^(RCConversationModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        [self.dataArray addObject:model];
    }];
    return dataSource;
}

/*!
 即将显示Cell的回调
 
 @param cell        即将显示的Cell
 @param indexPath   该Cell对应的会话Cell数据模型在数据源中的索引值
 
 @discussion 您可以在此回调中修改Cell的一些显示属性。
 */
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = NO;
    cell.backgroundColor = [UIColor whiteColor];
}

/*!
 自定义会话Cell显示时的回调
 
 @param tableView       当前TabelView
 @param indexPath       该Cell对应的会话Cell数据模型在数据源中的索引值
 @return                自定义会话需要显示的Cell
 */
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"RongYunListCell%ld_%ld",indexPath.section,indexPath.row]];
    if (!cell) {
        cell = [[ChatListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"RongYunListCell%ld_%ld",indexPath.section,indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.frame = RECT(0, 0, SCREEN_WIDTH, 70.0);
    [cell showTopSeparator:YES bottomSeparator:YES];
    RCConversationModel *model = self.dataArray[indexPath.row];
    //暂时只显示消息
    [cell showCellWithModel:model];
    [cell showNameWith:@"基尔加丹" showHeadImgWithUrl:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502443041809&di=ba7450d07e0925964c906afad8d37e6e&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201505%2F19%2F20150519224037_4cPze.jpeg"];
    //暂时不显示名字头像
    //[self loadCellWithUserInfo:indexPath Cell:cell WithModel:model];
    
    return cell;
}

/*!
 点击会话列表中Cell的回调
 
 @param conversationModelType   当前点击的会话的Model类型
 @param model                   当前点击的会话的Model
 @param indexPath               当前会话在列表数据源中的索引值
 
 @discussion 您需要重写此点击事件，跳转到指定会话的会话页面。
 如果点击聚合Cell进入具体的子会话列表，在跳转时，需要将isEnteredToCollectionViewController设置为YES。
 */
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    if (model.conversationType == ConversationType_PRIVATE) {
        __block BaseChatViewController *conversationVC = [[BaseChatViewController alloc] initWithConversationType:model.conversationType targetId:model.targetId];
        //暂时不请求头像名字
        //conversationVC.model = userModel;
        [conversationVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:conversationVC animated:YES];
//        [RongCloundUtils requestUserInfoWithUserId:model.targetId complete:^(UserModel *userModel) {
//            conversationVC.model = userModel;
//            [self.navigationController pushViewController:conversationVC animated:YES];
//        }];
        
    }
}

/*!
 左滑删除自定义会话时的回调
 
 @param tableView       当前TabelView
 @param editingStyle    当前的Cell操作，默认为UITableViewCellEditingStyleDelete
 @param indexPath       该Cell对应的会话Cell数据模型在数据源中的索引值
 
 @discussion 自定义会话Cell在删除时会回调此方法，您可以在此回调中，定制删除的提示UI、是否删除。
 如果确定删除该会话，您需要在调用RCIMClient中的接口删除会话或其中的消息，
 并从conversationListDataSource和conversationListTableView中删除该会话。
 */
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    BOOL isDelete = [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType
                                                             targetId:model.targetId];
    if (isDelete) {
        [self refreshConversationTableViewIfNeeded];
    }
    
}

/*!
 自定义会话Cell显示时的回调
 
 @param tableView       当前TabelView
 @param indexPath       该Cell对应的会话Cell数据模型在数据源中的索引值
 @return                自定义会话需要显示的Cell的高度
 */
- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 70.0;
}

#pragma mark - 收到消息监听
/*!
 在会话列表中，收到新消息的回调
 
 @param notification    收到新消息的notification
 
 @discussion SDK在此方法中有针对消息接收有默认的处理（如刷新等），如果您重写此方法，请注意调用super。
 
 notification的object为RCMessage消息对象，userInfo为NSDictionary对象，其中key值为@"left"，value为还剩余未接收的消息数的NSNumber对象。
 */
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    __weak typeof(&*self) blockSelf = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        
        if (message.conversationType != ConversationType_SYSTEM) {
            NSLog(@"好友消息要发系统消息！！！");
#if DEBUG
            @throw [[NSException alloc]
                    initWithName:@"error"
                    reason:@"好友消息要发系统消息！！！"
                    userInfo:nil];
#endif
        }
        RCContactNotificationMessage *_contactNotificationMsg =
        (RCContactNotificationMessage *)message.content;
        if (_contactNotificationMsg.sourceUserId == nil ||
            _contactNotificationMsg.sourceUserId.length == 0) {
            return;
        }
        //该接口需要替换为从消息体获取好友请求的用户信息
        RCConversationModel *customModel = [RCConversationModel new];
        customModel.conversationModelType =
        RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        customModel.conversationType = message.conversationType;
        customModel.targetId = message.targetId;
        customModel.sentTime = message.sentTime;
        customModel.receivedTime = message.receivedTime;
        customModel.senderUserId = message.senderUserId;
        customModel.lastestMessage = _contactNotificationMsg;
        //[_myDataSource insertObject:customModel atIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf
             refreshConversationTableViewWithConversationModel:
             customModel];
            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            NSNumber *left =
            [notification.userInfo objectForKey:@"left"];
            if (0 == left.integerValue) {
                [super refreshConversationTableViewIfNeeded];
            }
        });
    } else {
        //调用父类刷新未读消息数
        [super didReceiveMessageNotification:notification];
    }
}

#pragma mark -
#pragma mark - INTERFACE




@end
