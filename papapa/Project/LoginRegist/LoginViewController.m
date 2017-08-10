//
//  LoginViewController.m
//  papapa
//
//  Created by 二师兄 on 2017/8/10.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


/**
 暂时写一个跳过的方法

 */
- (IBAction)skipLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
