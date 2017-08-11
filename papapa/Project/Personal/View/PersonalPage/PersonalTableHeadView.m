//
//  PersonalTableHeadView.m
//  papapa
//
//  Created by 二师兄 on 2017/8/11.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "PersonalTableHeadView.h"
#import "PersonalPageInfoView.h"
@implementation PersonalTableHeadView{
    PersonalPageInfoView * _infoView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self controlView];
    }
    return self;
}

-(void)controlView{
    _infoView = [PersonalPageInfoView loadNib];
    [self addSubview:_infoView];
    [_infoView showHeadViewWithModel:nil backGroundImage:@""];
}

/**
 根据UserModel现实内容
 
 @param model 用户信息
 @param backGroundImageUrl 用户背景图片
 */
- (void)showHeadViewWithModel:(UserModel *)model backGroundImage:(NSString *)backGroundImageUrl{
    [_infoView showHeadViewWithModel:model backGroundImage:backGroundImageUrl];
}
@end
