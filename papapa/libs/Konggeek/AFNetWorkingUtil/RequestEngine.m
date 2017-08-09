//
//  RequestEngine.m
//  wowobao_s
//
//  Created by 王振 DemoKing on 2016/10/24.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import "RequestEngine.h"
#import "MJExtension.h"

@implementation RequestEngine
/**
 检测请求是否请求成功
 
 @param responseMessage 返回请求参数
 @param success success
 */
+ (void)checkResponseMessage:(ResponseMessage *)responseMessage success:(RequestEngineCheckIsSuccess)success {
    if (responseMessage.responseState == ResponseSuccessFinished) {
        ///  请求成功
        if ([responseMessage.retCode integerValue] == 0) {
            success(YES);
        }else {
            /// 请求成功并且返回错误的参数
            success(NO);
            NSLog(@"出错接口 == %@ 出错码 == %@",responseMessage.requestUrl, responseMessage.retCode);
        }
    }else if (responseMessage.responseState == ResponseFailureFinished) {
        ///  请求失败
        success(NO);
        NSLog(@"出错接口 == %@",responseMessage.requestUrl);
    }
}

+ (void)analyticalDataWithMessage:(ResponseMessage *)responseMessage
                       modelClass:(Class)modelClass
                          isArray:(BOOL)isArray
                           result:(RequestEngineAnalyticalBlock)result {
    if (responseMessage.responseState == ResponseSuccessFinished) {
        if ([responseMessage.retCode integerValue] == 0) {
            if (isArray) {
                NSMutableArray *array = [[modelClass class] mj_objectArrayWithKeyValuesArray:responseMessage.responseObject [@"data"]];
                result(YES,array,responseMessage);
            }else {
                result(YES,[[modelClass class] mj_objectWithKeyValues:responseMessage.responseObject [@"data"]],responseMessage);
            }
        }else {
            result(NO,nil,responseMessage);
            NSLog(@"出错接口 == %@ 出错码 == %@",responseMessage.requestUrl, responseMessage.retCode);
        }
    }else if (responseMessage.responseState == ResponseFailureFinished) {
        ///  请求失败
        result(NO,nil,responseMessage);
        NSLog(@"出错接口 == %@",responseMessage.requestUrl);
    }
}

/**
 post请求
 
 @param dictionary 请求参数
 @param url        url
 @param block      回调
 */
+ (void)postRequestWithDitionary:(NSDictionary *)dictionary url:(NSString *)url block:(RequestEngineBlock)block {
    //PROGRESS_SHOW
    RequestMessage *message = [RequestMessage messageWithMethod:POST url:url args:dictionary];
    [NetworkEngine sendRequestMessage:message callbackBlock:^(ResponseMessage *responseMessage) {
        //PROGRESS_HIDDEN
        if (block) {
            block(responseMessage);
        }
    }];
}

/**
 post请求
 
 @param dictionary 请求参数
 @param url        url
 @param block      回调
 */
+ (void)getRequestWithDitionary:(NSDictionary *)dictionary url:(NSString *)url block:(RequestEngineBlock)block {
    RequestMessage *message = [RequestMessage messageWithMethod:GET url:url args:dictionary];
    message.isMultipart = YES;
    [NetworkEngine sendRequestMessage:message callbackBlock:^(ResponseMessage *responseMessage) {
        if (block) {
            block(responseMessage);
        }
    }];
}
@end
