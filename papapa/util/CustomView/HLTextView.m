//
//  HLTextView.m
//  JiZhi
//
//  Created by wangyang on 2016/11/29.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import "HLTextView.h"
@interface HLTextView ()<UITextViewDelegate>
{
    UILabel             *_placehold;
    NSString            *_placeholdString;
    UILabel             *_limitLabel;
}
@end
@implementation HLTextView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addPlacehold];
//        [self addLimitLabel];
        self.limit = -1;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.textColor = [UIColor colorWithHexString:@"959595"];
        self.textContainerInset = UIEdgeInsetsMake(8, 10, 10, 5);
        self.font = FONT(13.5);
    }
    return self;
}

#pragma mark -
#pragma mark - PRIVATE METHOD

- (void)setText:(NSString *)text {
    [super setText:text];
    if (text.length) {
        _placehold.hidden = YES;
    } else {
        _placehold.hidden = NO;
    }
    _limitLabel.text = [NSString stringWithFormat:@"%ld",(long)(_limit - self.text.length)];
}
- (void)addPlacehold {
    _placehold = [[UILabel alloc] init]; //WithFrame:RECT(15, 10, self.frame.size.width-30, 20)];
    _placehold.textColor = [UIColor colorWithHexString:@"adadb2"];
    _placehold.font = FONT(15);
    [self addSubview:_placehold];
    _placehold.numberOfLines = 0;
    [_placehold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.width.offset(self.frame.size.width-30);
    }];
    _placehold.center = POINT(_placehold.center.x, 26 * HEIGHT_MULTIPLE);
}
- (void)addLimitLabel {
    _limitLabel = [[UILabel alloc] initWithFrame:RECT([self getWidth] - 80 - 15, [self getHeight] - 10 - 10, 80, 10)];
    _limitLabel.font = FONT(10);
    _limitLabel.textColor = [UIColor colorWithHexString:@"adadb2"];
    _limitLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_limitLabel];
}
- (void)placeholdString:(NSString *)placeholdString {
    _placehold.text = placeholdString;
    _placeholdString = placeholdString;
}
- (void)placeholdFont:(CGFloat)placeholdFont {
    _placehold.font = FONT(placeholdFont);
    _placehold.frame = RECT(15, 10, self.frame.size.width-30, placeholdFont);
}

- (void)resetPlaceholderLabel {
    self.textColor = [UIColor colorWithHexString:@"999999"];
    self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 5);
    self.font = FONT(14);
    [_placehold mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.width.offset(self.frame.size.width);
    }];
    _placehold.center = POINT(_placehold.center.x, 26 * HEIGHT_MULTIPLE);
    _placehold.textColor = [UIColor colorWithHexString:@"999999"];
    _placehold.font = FONT(14);
}

- (void)setLimit:(NSInteger)limit {
    _limit = limit;
    _limitLabel.text = [NSString stringWithFormat:@"%ld字以内",(long)limit];
    if (_limit <= 0) {
        _limitLabel.hidden = YES;
    } else {
        _limitLabel.hidden = NO;
    }
}

#pragma mark -
#pragma mark - <UITextViewDelegate>

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _placehold.text = nil;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        _placehold.text = nil;
    } else {
//        _placehold.text = _placeholdString;
    }
    if (self.limit == -1) {
        
    } else {
        NSString *lang = [textView textInputMode].primaryLanguage;
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textView markedTextRange];
            // 获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (position) {
                return;
            }
        }
        if (textView.text.length > self.limit) {
            textView.text = [textView.text substringToIndex:self.limit];
        }
        _limitLabel.text = [NSString stringWithFormat:@"还可输入%ld字",(long)(_limit - textView.text.length)];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text.length) {
        _placehold.text = _placeholdString;
    }
}


@end
