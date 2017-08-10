//
//  BaseCell.m
//  LangWind
//
//  Created by 二师兄 on 2017/5/11.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.reuseIdentifier isEqualToString:@"friendListCell"]) {
        for (UIView *subView in self.subviews) {
            if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
                UIView *bgView=(UIView *)[subView.subviews firstObject];
                NSLog(@"%@",NSStringFromClass([[bgView.subviews firstObject] class]));
                for(UIView *suview in bgView.subviews){
                    if ([NSStringFromClass([suview class]) isEqualToString:@"UIButtonLabel"]) {
                        UILabel *textLabel=(UILabel *)suview;
                        textLabel.textAlignment = NSTextAlignmentCenter;
                        textLabel.font=[UIFont systemFontOfSize:15];
                        UILabel * lable = [[UILabel alloc]initWithFrame:RECT(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
                        [textLabel addSubview:lable];
                        lable.textColor = [UIColor blackColor];
                        lable.text = @"  备注";
                        lable.font = FONT(15);
                        lable.backgroundColor = [UIColor colorWithHexString:COLOR_COMMON];
                    }
                }
            }
        }
    }
}
#pragma mark -
#pragma mark - getter
- (UIImageView *)imageView_icon {
    if (!_imageView_icon) {
        _imageView_icon = [[UIImageView alloc] init];
        _imageView_icon.tag = 10;
        [self addSubview:_imageView_icon];
    }
    return _imageView_icon;
}
-(UIImageView *)customImage{
    if (!_customImage) {
        _customImage = [[UIImageView alloc] init];
        _customImage.tag = 14;
        [self addSubview:_customImage];
    }
    return _customImage;
}
- (UILabel *)labelTitle {
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.tag = 11;
        [self addSubview:_labelTitle];
    }
    return _labelTitle;
}

- (UILabel *)labelSubTitle {
    if (!_labelSubTitle) {
        _labelSubTitle = [[UILabel alloc] init];
        _labelSubTitle.tag = 12;
        [self addSubview:_labelSubTitle];
    }
    return _labelSubTitle;
}
-(UILabel *)labelCustomTitle{
    if (!_labelCustomTitle) {
        _labelCustomTitle = [[UILabel alloc] init];
        _labelCustomTitle.tag = 17;
        [self addSubview:_labelCustomTitle];
    }
    return _labelCustomTitle;
}
- (UIImageView *)subIcon {
    if (!_subIcon) {
        _subIcon = [[UIImageView alloc] init];
        _subIcon.tag = 16;
        [self addSubview:_subIcon];
    }
    return _subIcon;
}

- (UIButton *)customButton {
    if (!_customButton) {
        _customButton = [UIButton buttonWithType:0];
        _customButton.frame = RECT(self.frame.size.width - 20 * WIDTH_MULTIPLE - 60, (self.frame.size.height - 30) / 2.0, 60, 30);
        _customButton.tag = 17;
        [_customButton addTarget:self action:@selector(customButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_customButton];
    }
    return _customButton;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.tag = 13;
        _textField.delegate = self;
        [self addSubview:_textField];
    }
    return _textField;
}

- (UITapGestureRecognizer *)tapGes {
    if (!_tapGes) {
        _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCell:)];
    }
    return _tapGes;
}

//是否可点击
- (void)setIsCanClick:(BOOL)isCanClick {
    _isCanClick = isCanClick;
    if (isCanClick == YES) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.tapGes];
    } else {
        self.userInteractionEnabled = NO;
        [self removeGestureRecognizer:self.tapGes];
    }
}

- (UIImageView *)imageView_isSelected {
    if (!_imageView_isSelected) {
        _imageView_isSelected = [[UIImageView alloc] init];
        _imageView_isSelected.tag = 15;
        _imageView_isSelected.image = [UIImage imageNamed:@"bzcell_no_selected"];
        _imageView_isSelected.hidden = YES;
        [self addSubview:_imageView_isSelected];
    }
    return _imageView_isSelected;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected == YES) {
        self.imageView_isSelected.image = [UIImage imageNamed:@"bzcell_selected"];
    } else {
        self.imageView_isSelected.image = [UIImage imageNamed:@"bzcell_no_selected"];
    }
}

- (UILabel *)labelTime {
    if (!_labelTime) {
        _labelTime = [[UILabel alloc] init];
        [self addSubview:_labelTime];
    }
    return _labelTime;
}


#pragma mark -
#pragma mark - 事件交互
- (void)clickCell:(UIGestureRecognizer *)tap {
    if (self.clickBlock) {
        self.clickBlock();
    }
}
-(void)customButtonClick:(UIButton *)btn{
    if (_cellCustomButtonClickBlock) {
        _cellCustomButtonClickBlock();
    }
}

#pragma mark -
#pragma mark - <UITextFieldDelegate>

/**
 didEndEditing Block
 
 @param textField textField
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_cellDidEndEditingBlock) {
        _cellDidEndEditingBlock(textField.text);
    }
}


@end
