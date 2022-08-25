//
//  SystemConfig.m
//  CampWorkPro02
//
//  Created by mazhongping on 2022/8/6.
//

#import "SystemConfig.h"

float windowWidth;
float windowHeight;
NSString * const bundlePath = @"./";
NSString * const WEATHER_URL = @"https://yiketianqi.com/api";

@interface SystemConfig ()

@end


@implementation SystemConfig


- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestInfo= [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"77663576",@"appid", // 开发id
                       @"",@"cityid",   // （1）城市id
                       @"",@"city",     // （2）城市
                       @"",@"ip",       // （3）ip所在地
                       nil];
    }
    return self;
}

+ (instancetype) sharedInstance{
    static SystemConfig * singleInstance = nil;
    static dispatch_once_t once_patch;
    
    dispatch_once(&once_patch, ^{
        singleInstance = [[SystemConfig alloc] init];
    });
    return singleInstance;
    
}


@end


