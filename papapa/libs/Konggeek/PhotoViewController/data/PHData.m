//
//  PHData.m
//  KJPhotoManager
//
//  Created by 王振 DemoKing on 2017/3/9.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "PHData.h"
#import <MediaPlayer/MediaPlayer.h>
@implementation PHData

/**
 获取所有图片分组
 
 @param callback 回调
 */
+ (void)allImageGroup:(void (^) (NSMutableArray <KJAssetCollection *>* array))callback {

    NSMutableArray *arrayResult = [NSMutableArray arrayWithCapacity:0];
    
    // 系统相册 只遍历Main
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        PHCollection *collection = smartAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            KJAssetCollection *collection = [[KJAssetCollection alloc] initWithPHAssetCollection:assetCollection];
            [arrayResult addObject:collection];
        }
    }
    for (int i = 0; i < userAlbums.count; i++) {
        PHCollection *collection = userAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            KJAssetCollection *collection = [[KJAssetCollection alloc] initWithPHAssetCollection:assetCollection];
            [arrayResult addObject:collection];
        }
    }
    callback(arrayResult);
}
+ (void)imageHighQualityFormatFromPHAsset:(PHAsset *)asset complete:(void (^) (UIImage *image))complete {
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (complete) {
                complete (result);
            }
        }];
    }else if (asset.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            NSURL *url = urlAsset.URL;
            MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
            moviePlayer.shouldAutoplay = NO;
            UIImage *thumbnail = [moviePlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            if (complete) {
                complete(thumbnail);
            }
        }];
    }else {
        if (complete) {
            complete (nil);
        }
    }
}
/**
 获取集合内asset对象数组
 
 @param assetCollection assetCollection
 @return NSMutableArray
 */
+ (NSMutableArray *)assetsInCollection:(PHAssetCollection *)assetCollection {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    [assetsFetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj];
    }];
    return array;
}

/**
 根据Asset 获取图片
 
 @param asset asset
 @param complete 回调
 */
+ (void)imageMaxSizeWithPHAsset:(PHAsset *)asset complete:(void (^) (UIImage *image))complete {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (complete) {
            complete (result);
        }
    }];
}

/**
 获取所有视频
 
 @param callback 回调
 */
+ (void)allVideo:(void (^) (NSMutableArray <KJAssetCollection *>*array))callback {
    NSMutableArray *arrayResult = [NSMutableArray arrayWithCapacity:0];
    
    // 系统相册 只遍历Main
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    
//    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        PHCollection *collection = smartAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            KJAssetCollection *collection = [[KJAssetCollection alloc] initWithVideoPHAssetCollection:assetCollection];
            [arrayResult addObject:collection];
        }
    }
//    for (int i = 0; i < userAlbums.count; i++) {
//        PHCollection *collection = userAlbums[i];
//        if ([collection isKindOfClass:[PHAssetCollection class]]) {
//            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
//            KJAssetCollection *collection = [[KJAssetCollection alloc] initWithVideoPHAssetCollection:assetCollection];
//            [arrayResult addObject:collection];
//        }
//    }
    callback(arrayResult);
}

/**
 获取集合内视频asset对象数组
 
 @param assetCollection assetCollection
 @return NSMutableArray
 */
+ (NSMutableArray *)videoAssetsInCollection:(PHAssetCollection *)assetCollection {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    [assetsFetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj];
    }];
    return array;
}
@end
