//
//  PHScanningNavigationView.m
//  KJPhotoManager
//
//  Created by 王振 DemoKing on 2017/3/16.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "PHScanningNavigationView.h"
#import "PHHeader.h"

@interface PHScanningNavigationView ()

{
    UIView          *_shadowView;
}

@end

@implementation PHScanningNavigationView

- (id)init {
    self = [super init];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH_PH, 64);
    if (self) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.7;
        _shadowView.frame = CGRectMake(0, 0, SCREEN_WIDTH_PH, 64);
        [self addSubview:_shadowView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        [button setImage:[UIImage imageNamed:@"ic_login_back"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

#pragma mark -
#pragma mark - INTERFACE

- (void)back:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(scanningNavigationView:clickAtIndex:)]) {
        [self.delegate scanningNavigationView:self clickAtIndex:1];
    }
}
@end
