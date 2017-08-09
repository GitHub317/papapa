//
//  NSArray+SortArray.m
//  JiZhi
//
//  Created by baozi on 2017/3/21.
//  Copyright © 2017年 DemoKing. All rights reserved.
//

#import "NSArray+SortArray.h"

@implementation NSArray (SortArray)
- (NSArray *)sortArrayWithIdentifier:(NSString *)identifier ascending:(BOOL)ascending {
    //数组的排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:identifier ascending:ascending];  //先按照identifier排序,
    NSArray *tempArray = [self sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return tempArray;
}
@end
