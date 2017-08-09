//
//  HLBaseCell.m
//  JiZhi
//
//  Created by baozi on 2016/11/30.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import "HLBaseCell.h"
@interface HLBaseCell()
//上线
@property (nonatomic, strong) CALayer * topSeparator;
//下线
@property (nonatomic, strong) CALayer * bottomSeparator;

@end

@implementation HLBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
#pragma mark -
#pragma mark - getter
/*
 * bref 上线
 */
- (CALayer *)topSeparator {
    if (!_topSeparator) {
        _topSeparator = [[CALayer alloc] init];
        _topSeparator.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
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
        _bottomSeparator.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
        [self.layer addSublayer:_bottomSeparator];
    }
    return _bottomSeparator;
}

- (UIImageView *)indicator {
    if (!_indicator) {
        _indicator = [[UIImageView alloc] init];
//                      WithFrame:CGRectMake(self.frame.size.width - 25 * WIDTH_MULTIPLE, 22 * HEIGHT_MULTIPLE, 8 * WIDTH_MULTIPLE, 12 * HEIGHT_MULTIPLE)];
        _indicator.image = [UIImage imageNamed:@"icon_my_accessory"];
        _indicator.center = POINT(_indicator.center.x, self.frame.size.height / 2.0);
        [self addSubview:_indicator];
        //此处需要集成Masonry
        [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.offset(0);
//            make.width.offset(9.5);
//            make.height.offset(17);
        }];
    }
    return _indicator;
}

//是否显示asso
- (void)showIndicator:(BOOL)isShow {
    if (isShow == YES) {
        self.indicator.hidden = NO;
    } else {
        self.indicator.hidden = YES;
        [self.indicator removeFromSuperview];
        self.indicator = nil;
    }
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
//显示上线, 有间隙
- (void)showTopSeparator:(BOOL)topShow
                    Rect:(CGRect)rect {
    if (topShow == YES) {
        self.topSeparator.hidden = NO;
        self.topSeparator.frame = rect;
    } else {
        self.topSeparator.hidden = YES;
    }
}
//显示下线 有间隙
- (void)showBottomSeparator:(BOOL)bottomShow
                       Rect:(CGRect)rect {
    if (bottomShow == YES) {
        self.bottomSeparator.hidden = NO;
        self.bottomSeparator.frame = rect;
    } else {
        self.bottomSeparator.hidden = YES;
    }
}
//返回cell的高度
- (void)heightForCell:(CGFloat)height {
    CGRect selfRect = self.frame;
    selfRect.size.height = height;
    self.frame = selfRect;
}

@end
