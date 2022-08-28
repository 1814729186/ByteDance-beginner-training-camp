//
//  WeatherModel.h
//  CampWorkPro02
//
//  Created by mazhongping on 2022/8/6.
//

#import "WeatherModelProtocol.h"
#import <Foundation/Foundation.h>
#import "MainViewController.h"

@interface WeatherModel : NSObject<WeatherModelProtocol>

@property(nonatomic,weak) MainViewController * mvc;

// 城市
@property(nonatomic, strong) NSString * city;

- (BOOL)locate;
@end
