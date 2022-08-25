//
//  SystemConfig.h
//  CampWorkPro02
//
//  Created by mazhongping on 2022/8/6.
//
#import <Foundation/Foundation.h>


@interface SystemConfig : NSObject

@property(nonatomic,strong) NSMutableDictionary *requestInfo;

+ (instancetype) sharedInstance;

@end

extern float windowWidth;
extern float windowHeight;

extern NSString * const bundlePath;

extern NSString * const WEATHER_URL;
