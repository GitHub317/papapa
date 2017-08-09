//
//  PHMoviesViewController.m
//  KJProject
//
//  Created by wangyang on 2017/4/25.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "PHMoviesViewController.h"
#import "PHCollectionViewCell.h"
#import "PHHeader.h"
#import "PHTabbarView.h"
#import "PHScanningViewController.h"
#import "CameraCollectionViewCell.h"
@interface PHMoviesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,PHTabbarViewDelegate,RSKImageCropViewControllerDelegate>
@property (strong, nonatomic) NSMutableArray <KJAsset *>*array;
@property (strong, nonatomic) NSMutableArray <KJAsset *>*selectedArray;
@property (strong, nonatomic) PHTabbarView *tabView;
@property (strong, nonatomic) KJAsset *cameraAsset;
@property (strong, nonatomic) KJAsset *publicAsset;
@end

@implementation PHMoviesViewController
{
    UICollectionView            *_collectionView;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
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
    self.array = [NSMutableArray arrayWithCapacity:0];
    self.selectedArray = [NSMutableArray arrayWithCapacity:0];
    [self navigation];
    [self collectionView];
    [self dataSource];
    [self tabBarView];
}
#pragma mark -
#pragma mark - DATA SOURCE

- (void)dataSource {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    array = [PHData videoAssetsInCollection:self.assetCollection];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KJAsset *asset = [[KJAsset alloc] initWithPHAsset:obj];
        [self.array addObject:asset];
    }];
    [_collectionView reloadData];
}

#pragma mark -
#pragma mark - PRIVATE

- (void)navigation {
    self.navigationItem.title = @"视频";
    [self barButtonItemImageName:@"ic_login_back" position:@"left"];
    [self barButtonItemTitle:@"  取消"];
}

- (void)barImageTap:(UITapGestureRecognizer *)tap {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - VIEWS

- (void)collectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH_PH - 25) / 4.0, (SCREEN_WIDTH_PH - 25) / 4.0);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_PH, SCREEN_HEIGHT_PH - 64 - 49) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [_collectionView registerClass:[PHCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[CameraCollectionViewCell class] forCellWithReuseIdentifier:@"cameracell"];
    [self.view addSubview:_collectionView];
}

- (void)tabBarView {
    self.tabView = [[PHTabbarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT_PH - 49 - 64, SCREEN_WIDTH_PH, 49)];
    self.tabView.delegate = self;
    [self.view addSubview:self.tabView];
}

#pragma mark -
#pragma mark - <<UICollectionViewDelegate,UICollectionViewDataSource>>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KJAsset *asset = self.array [indexPath.row];
    PHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    __block PHCollectionViewCell *cellWeak = cell;
    cellWeak.block = ^{
        //选择图片点击事件
        if (self.count == 1) {
            asset.selected = YES;
            if (_publicAsset == asset) {
                //相同  取消
                asset.selected = NO;
                [collectionView reloadData];
            } else {
                //不同  新增
                asset.selected = YES;
                _publicAsset.selected = NO;
                _publicAsset = asset;
                [collectionView reloadData];
            }
        } else {
            if (asset.selected == YES) {
                [self.selectedArray removeObject:asset];
                asset.selected = NO;
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }else {
                if (self.selectedArray.count >= self.count) {
                    [[HUDManager sharedManager] hud:@"超出最大限制"];
                    return ;
                }
                asset.selected = YES;
                [self.selectedArray addObject:asset];
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                [cell imageViewAnimation];
            }
        }
        [self.tabView count:self.selectedArray.count];
    };
    [cell showCellWithKJAsset:asset count:self.count];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    KJAsset *asset = self.array [indexPath.row];
}

#pragma mark -
#pragma mark - <PHTabbarViewDelegate>

- (void)tabbarView:(PHTabbarView *)tabbarView didSelectAtIndex:(NSInteger)index {
    if (index == 1) {
        // 预览
        
    }else if (index == 2) {
        // 完成
        [self backAndGiveValue];
    }
}
//本页面消失且传值
-(void)backAndGiveValue{
    if ([self.publicAsset isKindOfClass:[KJAsset class]]) {
        KJAsset * asset = (KJAsset*)self.publicAsset;
        [PHData imageHighQualityFormatFromPHAsset:asset.asset complete:^(UIImage *image) {
            NSLog(@"%@",image);
            if (_block) {
                _block(asset);
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                //判断如果是相机页面dismiss  就再dismiss一次
            }];
        }];
    }
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
