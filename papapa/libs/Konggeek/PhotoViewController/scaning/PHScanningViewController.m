//
//  PHScanningViewController.m
//  KJPhotoManager
//
//  Created by 王振 DemoKing on 2017/3/16.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "PHScanningViewController.h"
#import "UIViewController+PHCate.h"
#import "PHHeader.h"
#import "PHScanningCollectionViewCell.h"
#import "PHScanningNavigationView.h"

@interface PHScanningViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,PHScanningNavigationViewDelegate>

@end

@implementation PHScanningViewController
{
    UICollectionView            *_collectionView;
    PHScanningNavigationView    *_navigationView;
    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigation];
    [self collectionView];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self addNavView];
}

#pragma mark -
#pragma mark - PRIVATE

- (void)navigation {
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
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_PH, SCREEN_HEIGHT_PH) collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_collectionView registerClass:[PHScanningCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

- (void)addNavView {
    _navigationView = [[PHScanningNavigationView alloc] init];
    _navigationView.delegate = self;
    [self.view addSubview:_navigationView];
}

#pragma mark -
#pragma mark - <<UICollectionViewDelegate,UICollectionViewDataSource>>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KJAsset *asset = self.array [indexPath.row];
    PHScanningCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    __block PHScanningCollectionViewCell *cellWeak = cell;
    cellWeak.block = ^{
        _navigationView.hidden = !_navigationView.hidden;
    };
    [cell showWithKJAsset:asset];
    return cell;
}

#pragma mark -
#pragma mark - <PHScanningNavigationView>

- (void)scanningNavigationView:(PHScanningNavigationView *)scanningNavigationView clickAtIndex:(NSInteger)index {
    if (index == 1) {
        // 返回
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
