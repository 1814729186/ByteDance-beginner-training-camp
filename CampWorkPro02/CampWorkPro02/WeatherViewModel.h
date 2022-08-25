//
//  WeatherViewModel.h
//  CampWorkPro02
//
//  Created by mazhongping on 2022/8/6.

#import <Foundation/Foundation.h>
#import "WeatherModelProtocol.h"
#import "WeatherViewComtrollerProtocol.h"

// viewModel 观察者模式下的观察者和数据协调者
@interface WeatherViewModel : NSObject

// 绑定的WeatherModel
@property (nonatomic,strong) id<WeatherModelProtocol> weatherModel;
// 绑定的WeatherView，由于是从weatherViewController中加载类，因此为弱引用指针
@property (nonatomic,weak) id<WeatherViewControllerProtocol> weatherViewController;

-(instancetype) initWithWeatherModel:(id<WeatherModelProtocol>) weatehrModel andWeatherViewController:(id<WeatherViewControllerProtocol>) weatherViewController;

@end
