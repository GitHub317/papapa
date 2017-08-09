//
//  RequestEngine.h
//  wowobao_s
//
//  Created by 王振 DemoKing on 2016/10/24.
//  Copyright © 2016年 DemoKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkEngine.h"
#define KEY_URL @"KEY_URL"

typedef void (^RequestEngineBlock)(ResponseMessage *responseMessage);
typedef void (^RequestEngineCheckIsSuccess)(BOOL success);
typedef void (^RequestEngineAnalyticalBlock)(BOOL success,id result,ResponseMessage *responseMessage);

@interface RequestEngine : NSObject

/**
 检测请求是否请求成功

 @param responseMessage 返回请求参数
 @param success success
 */
+ (void)checkResponseMessage:(ResponseMessage *)responseMessage success:(RequestEngineCheckIsSuccess)success;

/**
 解析数据 回调：是否成功 解析结果 请求结果

 @param responseMessage 请求结果
 @param modelClass 类名
 @param isArray 是否是数组
 @param result 结果
 */
+ (void)analyticalDataWithMessage:(ResponseMessage *)responseMessage
                       modelClass:(Class)modelClass
                          isArray:(BOOL)isArray
                           result:(RequestEngineAnalyticalBlock)result;
/**
 post请求

 @param dictionary 请求参数
 @param url        url
 @param block      回调
 */
+ (void)postRequestWithDitionary:(NSDictionary *)dictionary url:(NSString *)url block:(RequestEngineBlock)block;

/**
 post请求

 @param dictionary 请求参数
 @param url        url
 @param block      回调
 */
+ (void)getRequestWithDitionary:(NSDictionary *)dictionary url:(NSString *)url block:(RequestEngineBlock)block;
@end
