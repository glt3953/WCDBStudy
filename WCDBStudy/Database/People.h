//
//  People.h
//  WCDBStudy
//
//  Created by guoliting on 2017/11/8.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject

@property int localID;
@property (retain) NSString *name;
@property int sex; //1:male,0:female
@property int age;
@property (retain) NSDate *createTime;
@property (retain) NSDate *modifiedTime;

@end
