//
//  ConstantHeader.h
//  ShenGangTong_Driver
//
//  Created by mac on 16/7/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#ifndef ConstantHeader_h
#define ConstantHeader_h
#define COLOR_COMMON            @"e94780"
#define COLOR_LINE              @"e5e5e5"
#define COLOR_BACKGROUND        @"f7f7f7"
#define COLOR_CELL_BACKGROUND   @"403f46"
#define COLOR_WHITE             @"ffffff"
#define COLOR_MARGIN_SLIDE      @"182329"
#define COLOR_HOMEBG            @"1F1F1F"
#define COLOR_TEXTCOLOR         @"050505"
#define ACCESS_TOKEN            @"accessToken"
#define PRIMARY_KEY             @"primaryKey"
#define DEVICE_ID               @"deviceId"   //推送标示
#define REQUEST_VERSION         @"version"
#define BAIDU_KEY               @"QSqbbUXaMi3YmC51pVNHIpvdKuo1CzBs"
#define GAODE_KEY               @"a1dda0edf60133f4340fa46e6f2d1c84"
#define WX_APP_ID               @"wx7022c31cf6df30a1"
#define IS_LOGIN                @"isLogin"
#define CURRENT_PROVINCE        @"currentProvince"          //定位省份
#define CURRENT_CITY            @"currentCity"          //定位城市
#define CURRENT_ADRESS          @"currentAdress"          //定位详细地址
#define CURRENT_LATITUDE        @"currentLatitude"      //纬度

#define Sever_QQ    @"2458525201"
#define Sever_Mobile @"4008237355"
#define Sever_QQ                @"2458525201"
#define Sever_Mobile            @"4008237355"
/**
 *  个人信息
 */
#define USERINFO [UserInfo shareManager]
/**
 *  融云信息
 */
#define RONGYUN_USEINFO  [RCIM sharedRCIM].userInfoDataSource

#define RONGYUN_TOKEN           @"rongyunToken"  //连接融云所用的token


#define RONGYUN_TOKEN_TEST101           @"OqE76YEeB8Yyt+8OsOIjOaPH7uE6mN0vR3MemPklbYTPwfmgUreAh899/gk2HSmoiEBIfcEeTro="  //ID 为101 的测试连接融云所用的token
#define RONGYUN_TOKEN_TEST102           @"JupBMLKwup9uvWVN6DoHn6PH7uE6mN0vR3MemPklbYTPwfmgUreAh0KX7cR4GUeA60w+I2ns1hA="  //ID 为102 的测试连接融云所用的token
#define RONGYUN_TOKEN_TEST103           @"NCigomihVwMfvQzzyc/1VIeQMVJzc4iD0ulmahgv/1waTVhaPXBg5uF3ZIn9WfGqxvtDoueaQTcKO+udyzQ3kQ=="  //ID 为103 的测试连接融云所用的token
#define RONGYUN_TOKEN_TEST104           @"NPhFM6SRGoUtMsAEZw6ghFP8ek659CZly1CFpw3xXAfzUMWWoZPjZ7upBFU6qN/tkpZv5JfTcy32ggUY7HOZYA=="  //ID 为104 的测试连接融云所用的token


#define CHATROOM_ID             @"chatRoomId"  //融云聊天室id

#define FRIEND_LIST                 @"friendList"//用来区分索引   ，好友列表
#define SEVER_LIST                 @"severUser"//用来区分索引   ，手机联系人蚂蚁账户列表
#define ROOT_PHONE                  @"0571-83688888"

/**
 *  融云信息
 */
#define RONGYUN_USEINFO  [RCIM sharedRCIM].userInfoDataSource

#define CHANGE_CHATROOMID                    @"change_chatRoomId"    //地区更改后，发送通知更改聊天室

#define EXIT_GROUP_NOTIFICATION              @"exitGroup"            //退出群组发送通知

# define SINGLE_CLEAR_NOTIFICATION           @"ClearSingleHistoryMsg" //清除单聊历史信息

# define GROUP_CLEAR_NOTIFICATION           @"ClearGroupHistoryMsg" //清除群聊历史信息

# define CHATROOM_CLEAR_NOTIFICATION        @"ClearChatRoomHistoryMsg" //清除聊天室历史信息

# define CLEAR_NOTIFICATION                 @"ClearHistoryMsg" //清除历史信息

#define ALI_ROOT_URL        @"http://antscy-video.oss-cn-shanghai.aliyuncs.com"

#endif /* ConstantHeader_h */
