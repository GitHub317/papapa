//
//  UILabel+Suitable.h

//

#import <UIKit/UIKit.h>


//Label 自适应
@interface UILabel (Suitable)
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;
@end
