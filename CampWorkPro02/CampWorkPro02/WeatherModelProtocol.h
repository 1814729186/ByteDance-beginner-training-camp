//
//  WeatherModelProtocol.h
//  CampWorkPro02
//
//  Created by mazhongping on 2022/8/6.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// 前期数据的数据状态
typedef NS_ENUM(NSInteger,DataStatus){
    ISNOTREADY, // 未完成准备
    ISREADY,    // 完成准备
    ERROR       // 出现错误，无法读取
};

/// 提供WeatherModel的相关功能
@protocol WeatherModelProtocol <NSObject>

// 数据完完成准备的标识
@property (nonatomic,assign) enum DataStatus ifDataIsReady;

// 天气数据信息
@property (nonatomic,strong) NSDictionary * weatherData;

- (CLLocationManager *) locationManager;

// 单例模式下获取实例对象
+(instancetype) sharedInstance;

/// 将天气数据储存到bundle
-(void) saveDataToBundle;

/// 从bundle读取天气数据
-(void) loadDataFromBundle;

/// 从网络端加载数据信息
-(void) loadDataFromNet;

@end
