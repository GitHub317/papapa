//
//  PersonalPageInfoView.h
//  papapa
//
//  Created by 二师兄 on 2017/8/11.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalPageInfoView : UIView
ESX_LoadNib_H(PersonalPageInfoView)

/**
 根据UserModel现实内容

 @param model 用户信息
 @param backGroundImageUrl 用户背景图片
 */
- (void)showHeadViewWithModel:(UserModel *)model backGroundImage:(NSString *)backGroundImageUrl;
@end
