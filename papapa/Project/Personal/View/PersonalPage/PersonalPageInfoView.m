//
//  PersonalPageInfoView.m
//  papapa
//
//  Created by 二师兄 on 2017/8/11.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "PersonalPageInfoView.h"

@implementation PersonalPageInfoView{
    //顶部毛玻璃背景
    __weak IBOutlet UIImageView *_topBackGroundImage;
    //头像
    __weak IBOutlet UIImageView *_headImg;
}
ESX_LoadNib_M(PersonalPageInfoView,@"PersonalPageInfoView")
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //此方法里不可修改xib中控件的属性，因为此时还没有加载Nib
        self.frame = RECT(0, 0, SCREEN_WIDTH, 350);
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    //添加毛玻璃效果
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 350-120);
    effectView.alpha = 0.99;
    [_topBackGroundImage addSubview:effectView];
    [_topBackGroundImage sendSubviewToBack:effectView];
}
//编辑
- (IBAction)editInfo:(id)sender {
    
}

/**
 根据UserModel现实内容
 
 @param model 用户信息
 @param backGroundImageUrl 用户背景图片
 */
- (void)showHeadViewWithModel:(UserModel *)model backGroundImage:(NSString *)backGroundImageUrl{
    if (model.avatarUrl.length > 0) {
         [_headImg sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:IMAGE(@"")];
    } else {
        [_headImg sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502455902044&di=9c15dc109cc08cc5fecdf753028217a5&imgtype=0&src=http%3A%2F%2Fimg.jsqq.net%2Fuploads%2Fallimg%2F150111%2F1_150111080328_19.jpg"]];
    }
    [_topBackGroundImage sd_setImageWithURL:[NSURL URLWithString:backGroundImageUrl]];
}
@end
