//
//  WeatherModel.m
//  CampWorkPro02
//
//  Created by mazhongping on 2022/8/6.
//

#import <Foundation/Foundation.h>
#import "WeatherModel.h"
#import <AFNetworking/AFNetworking.h>
#import "SystemConfig.h"
#import "SystemDefines.h"



@interface WeatherModel ()


@property(nonatomic,strong) NSString * bundlePath;

@end


@implementation WeatherModel

- (NSString *)bundlePath{
    if(!_bundlePath){
        _bundlePath = [[NSBundle mainBundle]pathForResource:@"resources" ofType:@"bundle"];
    }
    return _bundlePath;
}

+(instancetype) sharedInstance{
    static WeatherModel * singleInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance = [[WeatherModel alloc]init];
    });
    return singleInstance;
}

-(void)saveDataToBundle{
    // 将数据存入到bundle中
    //NSDocumentDirectory表示查找Documents文件夹，NSUserDomainMask参数代表仅搜索应用程序沙盒。
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //沙盒下只有一个Documets文件夹，所以获取第一个元素。
    NSString *documentsPath = pathAry[0];
    BOOL success = [self.weatherData writeToFile:[NSString stringWithFormat:@"%@/weatherData.txt",documentsPath] atomically:YES];
    //BOOL success = [self.weatherData writeToFile:[self.bundlePath stringByAppendingPathComponent:@"weatherData.txt"] atomically:YES];
    success?NSLog(@"写入成功 %@",documentsPath):NSLog(@"写入失败");
}


-(void) loadDataFromBundle{
    // 读取数据
    //NSDocumentDirectory表示查找Documents文件夹，NSUserDomainMask参数代表仅搜索应用程序沙盒。
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //沙盒下只有一个Documets文件夹，所以获取第一个元素。
    NSString *documentsPath = pathAry[0];
    self.weatherData = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/weatherData.txt",documentsPath]];
    //self.weatherData = [NSDictionary dictionaryWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"weatherData.txt"]];
    //NSLog(@"读取的数据：%@/%@",documentsPath,self.weatherData);
}

-(void) loadDataFromNet{
    // 请求天气数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 参数信息
    /* version=v1&appid=77663576&appsecret=8smzn4wO */
    NSDictionary *parameters = @{@"appid":@"77663576",@"version":@"v1",@"appsecret":@"8smzn4wO",@"unescape":@"1"};
    // 设置请求参数的拼接
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置接受的响应数据类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // get请求获取数据
    @weakify(self);
    [manager GET:WEATHER_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        //NSLog(@"responseObject = %@",responseObject);
        self.weatherData = [(NSDictionary *) responseObject copy];
        //NSLog(@"---------------\n%@",self.weatherData);
        self.ifDataIsReady = ISREADY;
        //NSLog(@"----------------\ndata = %@",self.weatherData[@"data"]);
        // 完成数据请求后写入到document目录下
        [self saveDataToBundle];
        [self loadDataFromBundle];
        // 通知controller更新信息
        [self.mvc loadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"error = %@",error);
        }
        // 获取网络数据失败，显示提示信息 TODO
        
        
        
        
        
    }];
}
@synthesize ifDataIsReady;

@synthesize weatherData;

@end
