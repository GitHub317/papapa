//
//  BaseView.h
//  Yidexuepin
//
//  Created by wangyang on 2017/6/14.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

@property (assign, nonatomic) id delegate;

- (id)initWithDelegate:(id)delegate;

@end
