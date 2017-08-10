//
//  BaseCell.h
//  LangWind
//
//  Created by 二师兄 on 2017/5/11.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "HLBaseCell.h"
typedef void (^CanClickBlock)();
typedef void (^SwitchActionBlock)();
typedef void (^bottomButtomBlock) ();
typedef void (^customButtomBlock) ();
typedef void (^CellDidEndEditingBlock) (NSString *text);

@interface BaseCell : HLBaseCell<UITextFieldDelegate>
/**
 输入框结束输入时回调
 */
@property (copy, nonatomic) CellDidEndEditingBlock cellDidEndEditingBlock;
/**
 自定义按钮点击回调
 */
@property (copy, nonatomic) customButtomBlock cellCustomButtonClickBlock;
/**
 图标
 */
@property (nonatomic, strong) UIImageView * imageView_icon;
/**
 子图标
 */
@property (nonatomic, strong) UIImageView * customImage;
//标题
@property (nonatomic, strong) UILabel * labelTitle;
//子标题
@property (nonatomic, strong) UILabel * labelSubTitle;
//自定义标题
@property (nonatomic, strong) UILabel * labelCustomTitle;
//输入框
@property (nonatomic, strong) UITextField * textField;
//subIcon
@property (nonatomic, strong) UIImageView * subIcon;
//添加、移除 按钮
@property (nonatomic, strong) UIButton *customButton;
//cell是否可点击
@property (nonatomic, assign) BOOL isCanClick;
//可点击的回调
@property (nonatomic, copy) CanClickBlock clickBlock;
//如果是开关 开关回调
@property (nonatomic, copy) SwitchActionBlock switchBlock;
//可点击的轻拍手势
@property (nonatomic, strong) UITapGestureRecognizer * tapGes;
//可选择的图片
@property (nonatomic, strong) UIImageView * imageView_isSelected;
//设置选择
@property (nonatomic, assign) BOOL isSelected;
//time
@property (nonatomic, strong) UILabel * labelTime;
//是否被选中使用优惠券
@property (nonatomic, assign) BOOL useYouhui;
//是否被选中使用积分
@property (nonatomic, assign) BOOL useJiFen;
@end
