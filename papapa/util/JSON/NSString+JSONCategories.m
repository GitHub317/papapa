//
//  NSString+JSONCategories.m
//  KJProject
//
//  Created by 二师兄 on 2017/3/22.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "NSString+JSONCategories.h"

@implementation NSString (JSONCategories)
-(id)JSONValue;
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end
