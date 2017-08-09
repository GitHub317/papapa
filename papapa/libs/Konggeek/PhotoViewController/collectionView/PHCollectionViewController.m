//
//  PHCollectionViewController.m
//  KJPhotoManager
//
//  Created by 王振 DemoKing on 2017/3/9.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "PHCollectionViewController.h"
#import "PHCollectionViewCell.h"
#import "PHHeader.h"
#import "PHTabbarView.h"
#import "PHScanningViewController.h"
#import "CameraCollectionViewCell.h"
@interface PHCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,PHTabbarViewDelegate,RSKImageCropViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray <KJAsset *>*array;
@property (strong, nonatomic) NSMutableArray <KJAsset *>*selectedArray;
@property (strong, nonatomic) PHTabbarView *tabView;
@property (strong, nonatomic) KJAsset *cameraAsset;
@property (strong, nonatomic) KJAsset *publicAsset;
@end

@implementation PHCollectionViewController
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
    if (self.isVideo) {
        array = [PHData videoAssetsInCollection:self.assetCollection];
    }else {
        array = [PHData assetsInCollection:self.assetCollection];
    }
    self.cameraAsset = [[KJAsset alloc]init];
    self.cameraAsset.isCamera = YES;
    [self.array addObject:self.cameraAsset];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KJAsset *asset = [[KJAsset alloc] initWithPHAsset:obj];
        [self.array addObject:asset];
    }];
    [_collectionView reloadData];
}

#pragma mark -
#pragma mark - PRIVATE

- (void)navigation {
    self.navigationItem.title = self.titleString;
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
    if (asset.isCamera) {
        //照相机
        CameraCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cameracell" forIndexPath:indexPath];
        return cell;
    } else {
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
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KJAsset *asset = self.array [indexPath.row];
    if (asset.isCamera) {
        //呼出照相
        [KJPhotoKitManager showCameraInViewController:self sure:^(UIImage *image) {
            if (_publicAsset) {
                _publicAsset.cameraImage = image;
            } else {
                _publicAsset  = [[KJAsset alloc]init];
                _publicAsset.cameraImage = image;
            }
        } cancel:nil dimiss:^{
            [self backAndGiveValue];
        }];
    } else {
        PHScanningViewController *vc = [[PHScanningViewController alloc] init];
        vc.array = self.array;
        vc.index = indexPath.item;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    if (self.count == 1) {
//        if (self.block) {
            //self.block (self.publicAsset);
            if ([self.publicAsset isKindOfClass:[KJAsset class]]) {
                KJAsset * asset = (KJAsset*)self.publicAsset;
                if (self.block) {
                    self.block (asset);
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    //判断如果是相机页面dismiss  就再dismiss一次
                    if (self.publicAsset.cameraImage) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
//                if (asset.cameraImage) {
//                    [self cutImageWithImage:asset.cameraImage WithStartOrEnd:nil];
//                } else {
//                    [PHData imageHighQualityFormatFromPHAsset:asset.asset complete:^(UIImage *image) {
//                        NSLog(@"%@",image);
//                        [self cutImageWithImage:image WithStartOrEnd:nil];
//                    }];
//                }
        }
    } else {
        if (self.block) {
            self.block (self.selectedArray);
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            //判断如果是相机页面dismiss  就再dismiss一次
            if (self.publicAsset.cameraImage) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}
//将图片裁剪
-(void)cutImageWithImage:(UIImage *)image WithStartOrEnd:(NSString *)location{
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
    //imageCropVC.customType = location;
    imageCropVC.delegate = self;
    imageCropVC.ratio = 5.0f;
    [self presentViewController:imageCropVC animated:YES completion:nil];
}
#pragma mark - Delegate Method: RSKImageCropViewControllerDelegate

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (_block) {
        _block(croppedImage);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //判断如果是相机页面dismiss  就再dismiss一次
        if (self.publicAsset.cameraImage) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"用户放弃裁剪图片");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
