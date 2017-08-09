//
//  KJOSSManager.m
//  KJFrameworkProject
//
//  Created by wangyang on 2016/11/16.
//  Copyright © 2016年 baozi. All rights reserved.
//

#import "KJOSSManager.h"

#define KJOSS_ACCESS_KEY_ID @"accessKeyId"
#define KJOSS_ACCESS_KEY_SECRET @"accessKeySecret"
#define KJOSS_SECURITY_TOKEN @"securityToken"
#define KJOSS_EXPIRATION @"expiration"
#define KJOSS_CHECKTIMESTAMP @"checkTimeStamp"

static OSSPutObjectRequest *putRequest;

@implementation KJOSSManager

+ (instancetype)shareManager {
    static KJOSSManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KJOSSManager alloc] init];
    });
    return manager;
}
/**
 初始化KJOSSManager
 
 @param ossServer 阿里云域名
 @param rootUrl 请求鉴权域名
 @param ossToken 请求鉴权接口
 @param ossBucketName 公司bucketName
 @param timeInterval OSSFederationToken失效时间
 */
+ (void)initWithOSSServer:(NSString *)ossServer rootUrl:(NSString *)rootUrl ossToken:(NSString *)ossToken ossBucketName:(NSString *)ossBucketName timeInterval:(CGFloat)timeInterval {
    [KJOSSManager shareManager].ossServer = ossServer;
    [KJOSSManager shareManager].ossToken = ossToken;
    [KJOSSManager shareManager].rootUrl = rootUrl;
    [KJOSSManager shareManager].ossBucketName = ossBucketName;
    [KJOSSManager shareManager].timeInterval = timeInterval;
}

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
                               callbackBlock:(void (^)(NSString *fileUrl))callbackBlock {
    OSSClient *ossClient = [KJOSSManager initOSSClient];
    putRequest = [OSSPutObjectRequest new];
    putRequest.uploadProgress=^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
        if (progressBlock) {
            CGFloat progress = totalBytesSent * 1.0 / totalBytesExpectedToSend * 1.0;
            progressBlock(progress);
        }
    };
    putRequest.bucketName = [KJOSSManager shareManager].ossBucketName;
    putRequest.objectKey = filePath;
    putRequest.uploadingData = fileData;
    OSSTask * putTask = [ossClient putObject:putRequest];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSString *fileUrl =[NSString stringWithFormat:@"/%@",putRequest.objectKey];
            NSLog(@"上传阿里云成功，fileUrl：%@",fileUrl);
            callbackBlock(fileUrl);
        } else {
            NSLog(@"上传阿里云失败, error: %@" , task.error);
            callbackBlock(nil);
        }
        return nil;
    }];
}

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
                    callBack:(void(^)(BOOL isDownloadSuccess, id fileData))finishBlock {
    NSString * subFilePath;
    if ([filePath containsString:domainName]) {
        subFilePath = [filePath substringFromIndex:domainName.length];
    }else {
        NSLog(@"链接不存在");
        return;
    }
    OSSClient *ossClient = [KJOSSManager initOSSClient];
    OSSGetObjectRequest *getRequest = [OSSGetObjectRequest new];
    BOOL isExist = [ossClient doesObjectExistInBucket:[KJOSSManager shareManager].ossBucketName objectKey:subFilePath error:nil];
    if (isExist) {
        NSLog(@"文件存在");
    }else {
        NSLog(@"文件不存在");
        return;
    }
    getRequest.bucketName = [KJOSSManager shareManager].ossBucketName;
    getRequest.objectKey = subFilePath;
    getRequest.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        // 当前下载段长度、当前已经下载总长度、一共需要下载的总长度
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        if (progressBlock) {
            CGFloat progress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite * 1.0;
            progressBlock(progress);
        }
    };
    OSSTask *getTask = [ossClient getObject:getRequest];
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSGetObjectResult *getResult = (OSSGetObjectResult *)task.result;
            NSData *downloadData = getResult.downloadedData;
            NSLog(@"阿里云下载成功");
            finishBlock(YES,downloadData);
        }else {
            NSLog(@"阿里云下载失败");
            finishBlock(NO,task.error);
        }
        return nil;
    }];
}


/****************************************** -----   OSS 初始化client  -----   **************************************************/

//OSS 初始化client
+ (OSSClient *)initOSSClient {
    NSString * const endPoint = [KJOSSManager shareManager].ossServer;
    NSString * checkTimeStamp = [[NSUserDefaults standardUserDefaults] valueForKey:KJOSS_CHECKTIMESTAMP];
    NSString * currentTimeStamp = [KJOSSManager obtainCurrentTimeStamp];
    id <OSSCredentialProvider> credential2;
    if (!checkTimeStamp || [currentTimeStamp integerValue] - [checkTimeStamp integerValue] > [KJOSSManager shareManager].timeInterval) {
        credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[KJOSSManager shareManager].rootUrl,[KJOSSManager shareManager].ossToken]];
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
            NSURLSession * session = [NSURLSession sharedSession];
            NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            if (error) {
                                                                [tcs setError:error];
                                                                return;
                                                            }
                                                            [tcs setResult:data];
                                                        }];
            [sessionTask resume];
            [tcs.task waitUntilFinished];
            if (tcs.task.error) {
                NSLog(@"get token error: %@", tcs.task.error);
                return nil;
            } else {
                NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                        options:kNilOptions
                                                                          error:nil];
                NSLog(@"object == %@",object);
                OSSFederationToken * token = [OSSFederationToken new];
                NSDictionary * data = [object objectForKey:@"data"];
                token.tAccessKey = [data objectForKey:@"accessKeyId"];
                token.tSecretKey = [data objectForKey:@"accessKeySecret"];
                token.tToken = [data objectForKey:@"securityToken"];
                token.expirationTimeInGMTFormat = [data objectForKey:@"expiration"];
                NSLog(@"get token: %@", token);
                
                // 存入本地 获取当前的时间戳 做半个小时的校验
                [KJOSSManager saveTokenToLocalWithToken:token];
                
                // 存时间戳
                NSString * checkStamp = [KJOSSManager obtainCurrentTimeStamp];
                [[NSUserDefaults standardUserDefaults] setValue:checkStamp forKey:KJOSS_CHECKTIMESTAMP];
                
                return token;
            }
        }];
    } else {
        credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken *{
            //从本地取出token
            OSSFederationToken *token = [KJOSSManager getToken];
            return token;
        }];
    }
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    return [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential2 clientConfiguration:conf];
}

/**
 *	@brief	获取当前的时间戳
 */
+ (NSString *)obtainCurrentTimeStamp {
    NSDate * date = [NSDate date];
    long currentDate = [date timeIntervalSince1970];
    NSString * currentTimeStamp = [NSString stringWithFormat:@"%ld",currentDate];
    return currentTimeStamp;
}
/**
 将token存入本地
 
 @param token OSSFederationToken
 */
+ (void)saveTokenToLocalWithToken:(OSSFederationToken *)token {
    [[NSUserDefaults standardUserDefaults] setValue:token.tAccessKey forKey:KJOSS_ACCESS_KEY_ID];
    [[NSUserDefaults standardUserDefaults] setValue:token.tSecretKey forKey:KJOSS_ACCESS_KEY_SECRET];
    [[NSUserDefaults standardUserDefaults] setValue:token.tToken forKey:KJOSS_SECURITY_TOKEN];
    [[NSUserDefaults standardUserDefaults] setValue:token.expirationTimeInGMTFormat forKey:KJOSS_EXPIRATION];
}

/**
 从本地取出token
*/
+ (OSSFederationToken *)getToken {
    OSSFederationToken * token = [OSSFederationToken new];
    token.tAccessKey = [[NSUserDefaults standardUserDefaults] valueForKey:KJOSS_ACCESS_KEY_ID];
    token.tSecretKey = [[NSUserDefaults standardUserDefaults] valueForKey:KJOSS_ACCESS_KEY_SECRET];
    token.tToken = [[NSUserDefaults standardUserDefaults] valueForKey:KJOSS_SECURITY_TOKEN];
    token.expirationTimeInGMTFormat = [[NSUserDefaults standardUserDefaults] valueForKey:KJOSS_EXPIRATION];
    return token;
}

+ (void)cancelUpload {
    [putRequest cancel];
}
@end
