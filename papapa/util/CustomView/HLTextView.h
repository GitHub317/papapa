//
//  HLTextView.h
//  JiZhi
//
//  Created by wangyang on 2016/11/29.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLTextView : UITextView
- (void)placeholdString:(NSString *)placeholdString;
- (void)placeholdFont:(CGFloat)placeholdFont;
- (void)resetPlaceholderLabel;
@property (nonatomic, assign) NSInteger limit;
@end
