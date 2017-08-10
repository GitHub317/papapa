//
//  HomeViewController.m
//  papapa
//
//  Created by 二师兄 on 2017/8/10.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkLogin];
}

/**
 导航栏设置（父VC控制）
 */
- (void)navigation{
    //置空左按钮
    [self barButtonItemImageName:@"" position:@"left"];
}

/**
 检测是否登陆
 */
-(void)checkLogin{
    NSString * token = [KJCommonMethods valueForkey:ACCESS_TOKEN];
    if (token.length == 0) {
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
