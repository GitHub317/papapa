//
//  HLBaseCell.h
//  JiZhi
//
//  Created by baozi on 2016/11/30.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLBaseCell : UITableViewCell

//asso
@property (nonatomic, strong) UIImageView * indicator;

//是否显示asso
- (void)showIndicator:(BOOL)isShow;
//是否显示上下线 左右顶格
- (void)showTopSeparator:(BOOL)topShow
         bottomSeparator:(BOOL)bottomShow;
//显示上线, 有间隙
- (void)showTopSeparator:(BOOL)topShow
                    Rect:(CGRect)rect;
//显示下线 有间隙
- (void)showBottomSeparator:(BOOL)bottomShow
                       Rect:(CGRect)rect;
//高度
- (void)heightForCell:(CGFloat)height;
@end
