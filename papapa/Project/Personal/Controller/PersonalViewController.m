//
//  PersonalViewController.m
//  papapa
//
//  Created by 二师兄 on 2017/8/10.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@end
@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)navigation{
    //置空左按钮
    [self barButtonItemImageName:@"" position:@"left"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
