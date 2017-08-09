//
//  KJOSSManager.h
//  KJFrameworkProject
//
//  Created by wangyang on 2016/11/16.
//  Copyright © 2016年 baozi. All rights reserved.
//  使用时须导入AliyunOSSiOS        pod 'AliyunOSSiOS', '~> 2.1.1'

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OSSService.h>
#import <OSSCompat.h>

typedef void (^NetworkSingleProgressCallback)(CGFloat progress);

@interface KJOSSManager : NSObject

@property (copy, nonatomic) NSString *ossServer;             //阿里云域名
@property (copy, nonatomic) NSString *rootUrl;               //请求鉴权域名
@property (copy, nonatomic) NSString *ossToken;              //请求鉴权接口
@property (copy, nonatomic) NSString *ossBucketName;         //公司bucketName
@property (assign, nonatomic) CGFloat timeInterval;          //OSSFederationToken失效时间

+ (instancetype)shareManager;

/**
 初始化KJOSSManager

 @param ossServer 阿里云域名
 @param rootUrl 请求鉴权域名
 @param ossToken 请求鉴权接口
 @param ossBucketName 公司bucketName
 @param timeInterval OSSFederationToken失效时间
 */
+ (void)initWithOSSServer:(NSString *)ossServer
                          rootUrl:(NSString *)rootUrl
                         ossToken:(NSString *)ossToken
                    ossBucketName:(NSString *)ossBucketName
                     timeInterval:(CGFloat)timeInterval;

/**
 阿里云简单上传

 @param filePath 文件路径
 @param fileData NSData的文件
 @param progressBlock 上传进度的block
 @param callbackBlock 上传完成的回调
 */
+ (void)uploadWithFilePath:(NSString *)filePath
                  fileData:(NSData *)fileData
             progressBlock:(NetworkSingleProgressCallback)progressBlock
             callbackBlock:(void (^)(NSString *fileUrl))callbackBlock;

/**
 阿里云简单下载

 @param filePath 文件地址
 @param domainName 文件域名
 @param progressBlock 下载进度的block
 @param finishBlock 下载完成的回调
 */
+ (void)downloadWithFilePath:(NSString *)filePath
                  domainName:(NSString *)domainName
               progressBlock:(NetworkSingleProgressCallback)progressBlock
                    callBack:(void(^)(BOOL isDownloadSuccess, id fileData))finishBlock;

//OSS 初始化client
+ (OSSClient *)initOSSClient;

+ (void)cancelUpload;

@end
