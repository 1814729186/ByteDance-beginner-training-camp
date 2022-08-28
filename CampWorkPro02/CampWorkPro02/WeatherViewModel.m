//
//  WeatherViewModel.m
//  CampWorkPro02
//
//  Created by mazhongping on 2022/8/6.
//

#import "WeatherViewModel.h"

@interface WeatherViewModel()


@end

@implementation WeatherViewModel

- (instancetype)initWithWeatherModel:(id<WeatherModelProtocol>)weatehrModel andWeatherViewController:(id<WeatherViewControllerProtocol>)weatherViewController{
    self = [super init];
    _weatherModel = weatehrModel;
    _weatherViewController = weatherViewController;
    
    // 构建观察者
    return self;
}


@end
