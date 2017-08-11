//
//  BaseChatViewController.m
//  KJProject
//
//  Created by wangyang on 2017/5/16.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "BaseChatViewController.h"
#import "FriendInfoViewController.h"
#import "LoginViewController.h"
#import "RongCloudManager.h"
#import "UIImage+FixOrientation.h"

@interface BaseChatViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *_pickerVC;
    UIImage                 *_thumbImage;
    CGFloat                 *_uploadProgress;
    BOOL                    _isCanClick;
}
@end

@implementation BaseChatViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    if (self.conversationMessageCollectionView) {
        [self.conversationMessageCollectionView reloadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isCanClick = YES;
    [self addObserVerReloadData];
    [self Navigation];
    [self setDelegate];
    [self addPickerViewController];
    [self resetFunctionView];
}

#pragma mark -
#pragma mark - PRIVATE

- (void)Navigation{
    [self barButtonItemImageName:@"ic_login_back" position:@"left"];
    [self setNavBackgroundImage:IMAGE(@"ic_nav_background")];
    [self titleColor:@"ffffff" font:17];
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_WHITE];
    if (self.conversationType == ConversationType_PRIVATE) {
        [self barButtonItemImageName:@"icon_singleset" position:@"right"];
        self.title = self.model.nickName;
        self.displayUserNameInCell = NO;
    }else if (self.conversationType == ConversationType_CHATROOM) {
        [self barButtonItemImageName:@"icon_chatRoomInfo" position:@"right"];
        self.title = self.chatModel.name;
        self.displayUserNameInCell = YES;
        NSString *title = [NSString stringWithFormat:@"%@欢迎你",self.chatModel.name];
        HUD(title)
    }else {
        [self barButtonItemImageName:@"icon_chatRoomInfo" position:@"right"];
        self.title = self.chatModel.name;
        self.displayUserNameInCell = YES;
    }
    //self.enableNewComingMessageIcon = YES;
}

- (void)addPickerViewController {
    _pickerVC = [[UIImagePickerController alloc] init];
    _pickerVC.delegate = self;
    _pickerVC.allowsEditing = NO;
    _pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    _pickerVC.mediaTypes = [NSArray arrayWithObjects:availableMedia[1], nil];
    _pickerVC.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //不需要编辑
    _pickerVC.allowsEditing = false;
}

/**
 更新pluginBoardView
 */
- (void)resetFunctionView {
    [self.chatSessionInputBarControl.pluginBoardView updateItemWithTag:1001 image:IMAGE(@"icon_photo") title:@"照片"];
    [self.chatSessionInputBarControl.pluginBoardView updateItemWithTag:1002 image:IMAGE(@"icon_camera") title:@"拍照"];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:IMAGE(@"icon_gold") title:@"送金币" tag:1003];
}

/**
 设置融云代理
 */
- (void)setDelegate {
//    [self registerClass:[KJDynamicCell class] forMessageClass:[KJDynamicContent class]];
//    [self registerClass:[KJVideoCell class] forMessageClass:[KJVideoMessage class]];
}


/**
 清除历史消息
 */
- (void)addObserVerReloadData {
    //清除历史消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearHistoryMSG:)
                                                 name:CLEAR_NOTIFICATION
                                               object:nil];
}

- (void)clearHistoryMSG:(NSNotification *)notification {
    [self.conversationDataRepository removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationMessageCollectionView reloadData];
    });
}

#pragma mark -
#pragma mark - VIEWS


#pragma mark --
#pragma mark -- RCPluginBoardViewDelegate

-(void)pluginBoardView:(RCPluginBoardView*)pluginBoardView clickedItemWithTag:(NSInteger)tag {
if (tag == 1003) {
    //送金币
    
        
    }else if (tag == 1002) {
        [KJPhotoKitManager showCameraInViewController:self sure:^(UIImage *image) {
            __block ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
            
            
            [lib writeImageToSavedPhotosAlbum:[image fixOrientation].CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                
                NSLog(@"assetURL = %@, error = %@", assetURL, error);
                lib = nil;
                
            }];
            RCImageMessage *message = [RCImageMessage messageWithImage:image];
            [[RCIM sharedRCIM] sendMediaMessage:self.conversationType targetId:self.targetId content:message pushContent:nil pushData:nil progress:^(int progress, long messageId) {
                //
            } success:^(long messageId) {
                //
            } error:^(RCErrorCode errorCode, long messageId) {
                //
            } cancel:^(long messageId) {
                //
            }];
        } cancel:nil dimiss:^{
            
        }];
    }else {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
}


#pragma mark -
#pragma mark - INTERFACE

/*!
 点击Cell中头像的回调
 
 @param userId  点击头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId {
    //
    FriendInfoViewController *vc = [[FriendInfoViewController alloc] init];
    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

/*!
 点击Cell中的消息内容的回调
 
 @param model 消息Cell的数据模型
 
 @discussion SDK在此点击事件中，针对SDK中自带的图片、语音、位置等消息有默认的处理，如查看、播放等。
 您在重写此回调时，如果想保留SDK原有的功能，需要注意调用super。
 */
- (void)didTapMessageCell:(RCMessageModel *)model {
    if ([model.objectName isEqualToString:@"RC:VcMsg"]) {
        model.receivedStatus = ReceivedStatus_LISTENED;
    }else {
        model.receivedStatus = ReceivedStatus_READ;
    }
    if ([model.content isKindOfClass:[RCContactCardMessage class]]) {
        RCContactCardMessage *message = (RCContactCardMessage *)model.content;
        FriendInfoViewController *vc = [[FriendInfoViewController alloc] init];
        vc.userId = message.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    else if ([model.content isKindOfClass:[KJDynamicContent class]]) {
//        KJDynamicContent *message = (KJDynamicContent *)model.content;
//        VideoWebViewController *vc = [[VideoWebViewController alloc] init];
//        vc.urlString = message.url;
//        vc.title = message.content;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    else {
        [super didTapMessageCell:model];
    }
}

- (void)barImageTap:(UITapGestureRecognizer *)tap {
    if (tap.view.tag == 2) {

    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
