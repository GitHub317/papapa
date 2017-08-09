//
//  BaseView.m
//  Yidexuepin
//
//  Created by wangyang on 2017/6/14.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

@end
