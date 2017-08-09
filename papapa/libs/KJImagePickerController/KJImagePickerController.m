//
//  KJImagePickerController.m
//  Grass
//
//  Created by 王振 on 15/12/2.
//  Copyright © 2015年 王振. All rights reserved.
//

#import "KJImagePickerController.h"
#import "RSKImageCropViewController.h"
typedef NS_ENUM(NSUInteger, KJImagePickerMode) {
    KJImagePickerModeNomal = 1,
    KJImagePickerModeCircle,
    KJImagePickerModeSquare,
    KJImagePickerModeCustom,
};
@interface KJImagePickerController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>
@property (strong, nonatomic) UIViewController *upperViewController;
@property (assign, nonatomic) KJImagePickerMode imagePickerMode;
@property (assign, nonatomic) SourceType type;
@property (assign, nonatomic) float ratio;
@property (nonatomic,copy) void (^successBlock)(UIImage *image);
@property (nonatomic,copy) void (^cancelBlock)(void);
@end

@implementation KJImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - Private Method

+ (id)presentViewController:(UIViewController *)upperViewController sourceType:(SourceType)sourceType {
    KJImagePickerController *vc = [[KJImagePickerController alloc] init];
    if (sourceType == SourceTypeCamera) {
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (sourceType == SourceTypePhotoLibrary) {
        vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (sourceType == SourceTypeSavedPhotosAlbum) {
        vc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [upperViewController presentViewController:vc animated:YES completion:nil];
    vc.upperViewController = upperViewController;
    return vc;
}

- (void)pushRSKViewControllerWithImage:(UIImage *)image {
    RSKImageCropViewController *imageCropVC;
    if (self.imagePickerMode == KJImagePickerModeCircle) {
        imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    }else if (self.imagePickerMode == KJImagePickerModeSquare) {
        imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
    }else if (self.imagePickerMode == KJImagePickerModeCustom) {
        imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCustom];
    }
    imageCropVC.delegate = self;
    imageCropVC.ratio = self.ratio;
    [imageCropVC setHidesBottomBarWhenPushed:YES];
    [self presentViewController:imageCropVC animated:YES completion:nil];
}

+ (id)showImagePickControllerIn:(UIViewController *)upperViewController sourceType:(SourceType)sourceType image:(void (^)(UIImage *))finish imagePickerControllerDidCancel:(void (^)(void))cancel {
    KJImagePickerController *vc = [self presentViewController:upperViewController sourceType:sourceType];
    vc.successBlock = finish;
    vc.cancelBlock = cancel;
    vc.imagePickerMode = KJImagePickerModeNomal;
    return vc;
}

+ (id)showRSKCircleImagePickControllerIn:(UIViewController *)upperViewController sourceType:(SourceType)sourceType image:(void (^)(UIImage *))finish imagePickerControllerDidCancel:(void (^)(void))cancel {
    KJImagePickerController *vc = [self presentViewController:upperViewController sourceType:sourceType];
    vc.successBlock = finish;
    vc.cancelBlock = cancel;
    vc.imagePickerMode = KJImagePickerModeCircle;
    return vc;
}

+ (id)showRSKSquareImagePickControllerIn:(UIViewController *)upperViewController sourceType:(SourceType)sourceType image:(void (^)(UIImage *))finish imagePickerControllerDidCancel:(void (^)(void))cancel {
    KJImagePickerController *vc = [self presentViewController:upperViewController sourceType:sourceType];
    vc.successBlock = finish;
    vc.cancelBlock = cancel;
    vc.imagePickerMode = KJImagePickerModeSquare;
    return vc;
}

+ (id)showRSKCustomImagePickControllerIn:(UIViewController *)upperViewController sourceType:(SourceType)sourceType withRatio:(float)ratio image:(void (^)(UIImage *))finish imagePickerControllerDidCancel:(void (^)(void))cancel {
    KJImagePickerController *vc = [self presentViewController:upperViewController sourceType:sourceType];
    vc.successBlock = finish;
    vc.cancelBlock = cancel;
    vc.imagePickerMode = KJImagePickerModeCustom;
    vc.ratio = ratio;
    return vc;
}

#pragma mark - Delegate Method: UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.imagePickerMode == KJImagePickerModeNomal) {
        [picker dismissViewControllerAnimated:YES completion:^{
            if (_successBlock) {
                _successBlock(image);
            }
        }];
    }else {
        [self pushRSKViewControllerWithImage:image];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        if (_cancelBlock) {
            _cancelBlock();
        }
    }];
}

#pragma mark - Delegate Method: RSKImageCropViewControllerDelegate

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        if (_successBlock) {
            _successBlock(croppedImage);
        }
    }];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        if (_cancelBlock) {
            _cancelBlock();
        }
    }];
}

#pragma mark - Delegate Method: RSKImageCropViewControllerDataSource

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
