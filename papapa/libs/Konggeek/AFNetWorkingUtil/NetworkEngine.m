//
//  NetworkEngine.m
//  KongGeekSample
//
//  Created by Robin on 16/7/5.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "NetworkEngine.h"
#import <AFHTTPSessionManager.h>
#import "AppDelegate.h"
#import "InterfaceMarco.h"
#import "LoginViewController.h"
#define TIME_OUT 5 //请求超时时间

@implementation NetworkEngine

+(void)sendRequestMessage:(RequestMessage *)message delegate:(id)delegate callbackSelector:(SEL)callbackSelector{
    [self doRequest:message delegate:delegate callbackSelector:callbackSelector callbackBlock:nil];
}

+(void)sendRequestMessage:(RequestMessage *)message callbackBlock:(NetworkResponseCallback)callback{
    [self doRequest:message delegate:nil callbackSelector:nil callbackBlock:callback];
}

+(void)doRequest:(RequestMessage *)message delegate:(id)delegate callbackSelector:(SEL)callbackSelector callbackBlock:(NetworkResponseCallback)callbackBlock {
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:ROOT_URL]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie"];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (message.args) {
        [params setValuesForKeysWithDictionary:message.args];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *security = [AFSecurityPolicy defaultPolicy];
    security.allowInvalidCertificates = YES;
    security.validatesDomainName = NO;
    manager.securityPolicy = security;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/json",nil];
    [self addAdditionalParams:params];
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",ROOT_URL,message.url];
    NSLog(@"请求参数 params : %@",params);
    if (message.method==GET) {
        [manager GET:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功！responseObject : %@",responseObject);
            [self proccessResponse:message operation:task responseObject:responseObject error:nil delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求出错:%@ + responseString : %@",error.userInfo,task.response);
            [self proccessResponse:message operation:task responseObject:nil error:error delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
        }];
    }
    if (message.method==POST) {
        if (message.isMultipart) {
            [manager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                // 这里可以获取到目前的数据请求的进度
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"请求成功！responseObject : %@",responseObject);
                [self proccessResponse:message operation:task responseObject:responseObject error:nil delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"请求出错:%@ + responseString : %@",error.userInfo,task.response);
                [self proccessResponse:message operation:task responseObject:nil error:error delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
            }];
        }else {
            [manager POST:URLString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                // 这里可以获取到目前的数据请求的进度
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"请求成功！responseObject : %@",responseObject);
                [self proccessResponse:message operation:task responseObject:responseObject error:nil delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"请求出错:%@ + responseString : %@",error.userInfo,task.response);
                [self proccessResponse:message operation:task responseObject:nil error:error delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
            }];
        }
    }
}

+(void)proccessResponse:(RequestMessage *)message operation:(NSURLSessionDataTask *)operation responseObject:(id)responseObject error:(NSError *)error delegate:(id)delegate callbackSelector:(SEL)callbackSelector callbackBlock:(NetworkResponseCallback)callbackBlock {
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:ROOT_URL]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie"];
    
    ResponseMessage *responseMessage =[[ResponseMessage alloc] initWithRequestUrl:message.url requestArgs:message.args];
    if ([responseObject[@"retCode"] isEqualToString:@"10002"]) {
        [KJCommonMethods removeValueForkey:@"accessToken"];
        [KJCommonMethods saveValue:[NSNumber numberWithBool:NO] key:IS_LOGIN];
        [UserInfo removeUserInfo];
        UITabBarController * tabbrVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        if (tabbrVC.selectedIndex == 2) {
            UINavigationController *nav = tabbrVC.viewControllers[2];
            [nav popToRootViewControllerAnimated:YES];
        }
        [(AppDelegate *)[UIApplication sharedApplication].delegate presentNewNavigationControllerWithClass:[LoginViewController class] Animation:YES block:^{
            //
        }];
    }
    
    responseMessage.responseString=[NSString stringWithFormat:@"%@",operation.response];
    if (responseObject && [responseObject isKindOfClass:NSDictionary.class]) {
        responseMessage.responseObject = responseObject;
        responseMessage.retCode = responseObject[@"retCode"];
        responseMessage.bussinessData = responseObject[@"dataObject"];
        responseMessage.errorMessage = responseObject[@"errorMsg"];
        
        responseMessage.pageNum = responseObject [@"pageNum"];
        responseMessage.totalPage = responseObject [@"totalPage"];
    }
    if (error) {
        responseMessage.responseState = ResponseFailureFinished;
        if (!responseMessage.errorMessage.length) {
            responseMessage.errorMessage = @"网络错误";
        }
    }else{
        responseMessage.responseState=ResponseSuccessFinished;
    }
    if (delegate && [delegate respondsToSelector:callbackSelector]) {
        //[delegate performSelector:callbackSelector withObject:respMsg];
        IMP imp = [delegate methodForSelector:callbackSelector];
        void (*func)(id, SEL,ResponseMessage *) = (void *)imp;
        func(delegate, callbackSelector,responseMessage);
    }
    if (callbackBlock) {
        callbackBlock(responseMessage);
    }
}

+(void)addAdditionalParams:(NSMutableDictionary *)params{
    NSString *accessToken =[KJCommonMethods valueForkey:ACCESS_TOKEN];
    if (accessToken) {
        [params setObject:accessToken forKey:@"accessToken"];
    }
    NSString *appID = [KJCommonMethods valueForkey:DEVICE_ID];
    if (appID) {
        [params setObject:appID forKey:@"deviceToken"];
    }
    [params setObject:@"iOS" forKey:@"deviceType"];
    [params setObject:@"iOS" forKey:@"source"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [params setObject:appVersion forKey:@"version"];


}

@end
