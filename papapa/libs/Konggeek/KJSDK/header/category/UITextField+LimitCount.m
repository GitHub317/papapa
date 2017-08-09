//
//  UITextField+LimitCount.m
//  Huiben_iOS
//
//  Created by BomBom on 16/8/26.
//  Copyright © 2016年 baozi. All rights reserved.
//

#import "UITextField+LimitCount.h"
#import <objc/runtime.h>
static char limit;
@implementation UITextField (LimitCount)
- (void)setLimitCount:(NSInteger)limitCount {
    objc_setAssociatedObject(self, &limit, [NSString stringWithFormat:@"%ld", (long)limitCount], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setTextLimit];
}
- (NSInteger)limitCount {
    return [objc_getAssociatedObject(self, &limit) integerValue];
}
- (void)setTextLimit {
    [self addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
}
- (void)changeText:(UITextField *)textField {
    NSString *toBeString = textField.text;
    NSString *lang = [textField textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        int chNum =0;
        for (int i=0; i<toBeString.length; ++i)
        {
            NSRange range = NSMakeRange(i, 1);
            NSString *subString = [toBeString substringWithRange:range];
            const char *cString = [subString UTF8String];
            if (cString == nil) {
                chNum ++;
            } else if (strlen(cString) == 3) {
                chNum ++;
            }
        }
        if (!position) {
            if (toBeString.length > self.limitCount) {
                textField.text = [toBeString substringToIndex:self.limitCount];
            }
        } else {
            
        }
    } else {
        if (toBeString.length > self.limitCount) {
            textField.text = [toBeString substringToIndex:self.limitCount];
        }
    }
}

/**
 设置手机类型的输入框
 */
- (void)phoneType {
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
}
/**
 设置密码类型的输入框
 */
- (void)passwordType {
    self.keyboardType = UIKeyboardTypeAlphabet;
    self.secureTextEntry = YES;
}
@end
