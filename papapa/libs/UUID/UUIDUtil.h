//
//  UUIDUtil.h
//  H3CMagic
//
//  Created by Robin on 15/12/22.
//  Copyright © 2015年 KongGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUIDUtil : NSObject

+(NSString *)generateUUID;

/**
 获取设备UUID

 @return 设备标示UUID
 */
+(NSString *)obtainUUID;
@end
