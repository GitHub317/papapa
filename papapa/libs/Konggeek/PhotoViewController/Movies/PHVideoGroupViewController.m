//
//  PHVideoGroupViewController.m
//  KJProject
//
//  Created by wangyang on 2017/4/25.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "PHVideoGroupViewController.h"
#import "PHHeader.h"
#import "PHGroupTableViewCell.h"
#import "PHMoviesViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface PHVideoGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray <KJAssetCollection *>*grpupsArray;

@end

@implementation PHVideoGroupViewController
{
    UITableView         *_tableView;
    //判断用户是否授权访问相册的定时器
    NSTimer                *_timer;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigation];
    [self tableView];
    [self AllVideo];
    // 获取当前应用对照片的访问授权状态
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange:) userInfo:nil repeats:YES];
    }
}
//调出相册
-(void)AllVideo {
    [PHData allVideo:^(NSMutableArray<KJAssetCollection *> *array) {
        self.grpupsArray = array;
        [_tableView reloadData];
        if (array.count) {
            KJAssetCollection *assetCollection = self.grpupsArray [0];
            PHMoviesViewController *vc = [[PHMoviesViewController alloc] init];
            vc.titleString = @"相机胶卷";
            vc.block = ^(id result){
                if (_block) {
                    _block (result);
                }
            };
            vc.count = self.count;
            vc.assetCollection = assetCollection.assetCollection;
            [self.navigationController pushViewController:vc animated:NO];
        }
    }];
}
//用户授权后调用
- (void)observeAuthrizationStatusChange:(NSTimer *)timer {
    /** 当用户已授权 */
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [timer invalidate];
        //停止定时器
        _timer = nil;
        //调出相册
        [self AllVideo];
    }
}
#pragma mark -
#pragma mark - PRIVATE

- (void)navigation {
    self.navigationItem.title = @"相册";
    [self changeNavAlpha:1 color:[UIColor colorWithHexString:@"2f2e33"]];
    [self barButtonItemImageName:@"" position:@"left"];
    [self titleColor:@"ffffff" font:17];
    [self barButtonItemTitle:@"  取消"];
}

#pragma mark -
#pragma mark - VIEWS

- (void)tableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - 20, SCREEN_WIDTH_PH, SCREEN_HEIGHT_PH + 20 - 64)];
    _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSMutableArray *)grpupsArray {
    if (!_grpupsArray) {
        _grpupsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _grpupsArray;
}

#pragma mark -
#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KJAssetCollection *assetCollection = self.grpupsArray [indexPath.row];
    PHMoviesViewController *vc = [[PHMoviesViewController alloc] init];
    if (indexPath.row == 0) {
        vc.titleString = @"相机胶卷";
    }else {
        vc.titleString = assetCollection.assetCollection.localizedTitle;
    }
    vc.block = ^(id result){
        if (_block) {
            _block (result);
        }
    };
    vc.count = self.count;
    vc.assetCollection = assetCollection.assetCollection;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.grpupsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KJAssetCollection *assetCollection = self.grpupsArray [indexPath.row];
    PHGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[PHGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell showCellWithKJAssetCollection:assetCollection];
    return cell;
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
