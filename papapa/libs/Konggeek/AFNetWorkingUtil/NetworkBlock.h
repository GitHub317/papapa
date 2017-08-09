//
//  NetworkBlock.h
//  KongGeekSample
//
//  Created by Robin on 16/7/6.
//  Copyright © 2016年 KongGeek. All rights reserved.
//


#ifndef NetworkBlock_h
#define NetworkBlock_h

#import "ResponseMessage.h"
#import <UIKit/UIKit.h>

typedef void (^NetworkResponseCallback)(ResponseMessage *responseMessage);

typedef void (^NetworkProgressCallback)(long long bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite);

typedef void (^NetworkSingleProgressCallback)(CGFloat progress);
#endif /* NetworkBlock_h */
