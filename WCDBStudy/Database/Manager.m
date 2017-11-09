//
//  Manager.m
//  WCDBStudy
//
//  Created by guoliting on 2017/11/9.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import "Manager.h"

@implementation Manager

+ (instancetype)shareInstance {
    static Manager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Manager alloc] init];
    });
    
    return instance;
}

@end
