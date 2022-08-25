//
//  MainViewController.m
//  CampWorkPro02
//
//  Created by mazhongping on 2022/8/4.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import "WeatherModel.h"
#import "SystemConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry/Masonry.h"
#import "WeatherTimelineCollectionViewCell.h"
#import "WeatherDaylineTableViewCell.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <SDWebImage/SDWebImage.h>


@interface MainViewController () <UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSString * bundlePath;

// 两个view，分别用于显示两个画面，底部栏、背景、顶部栏等置于self.view中
// 天气界面
@property(nonatomic,strong) UIView * weatherView;
// 空气界面
@property(nonatomic,strong) UIView * airView;
/// 天气界面
// 背景视频播放，会随着天气情况改变
@property(nonatomic,strong) AVPlayer * backgroundPlayer;
// 背景图片
@property(nonatomic,strong) UIImageView * backgroundImage;
// 定位按钮
@property(nonatomic,strong) UIButton * positionButton;
// 城市按钮，点击切换城市
@property(nonatomic,strong) UIButton * cityChangeButton;
// 当前日期标签
@property(nonatomic,strong) UILabel * curDateLabel;
// 当前温度Label
@property(nonatomic,strong) UILabel * curTempLabel;
// 当日天气Label
@property(nonatomic,strong) UILabel * curWeatherLabel;
// 最高最低气温
@property(nonatomic,strong) UILabel * todayHLTempLabel;
// 分割线
@property(nonatomic,strong) UILabel * line1;
@property(nonatomic,strong) UILabel * line2;
// 分时展示天气的CollectionView
@property(nonatomic,strong) UICollectionView * weatherTimelineCollectionView;
// 分日期展示天气的TableView
@property(nonatomic,strong) UITableView * weatherDaylineTableView;

// 底部Tab按钮
@property(nonatomic,strong) UIView * bottomItemBar;
@property(nonatomic,strong) UIButton * bottomBarWeatherButton;
@property(nonatomic,strong) UIButton * bottomBarAirQualityButton;

// 页面2的补充控件 ，修改血糖、穿衣、洗车指数为气压、风向、风力
// 空气指数
@property(nonatomic,strong) UILabel * airLabel;
// 空气质量
@property(nonatomic,strong) UILabel * airLevelLabel;
// 活动描述
@property(nonatomic,strong) UILabel * airTipsLabel;
// 空气湿度
@property(nonatomic,strong) UILabel * humidityLabel;
// 紫外线指数
@property(nonatomic,strong) UILabel * ultravioletLabel;
// 血糖指数 --> 气压
@property(nonatomic,strong) UILabel * airPressureLabel;
// 穿衣指数 --> 风向
@property(nonatomic,strong) UILabel * windDirectionLabel;
// 洗车指数 --> 风力
@property(nonatomic,strong) UILabel * windForceLabel;

// 最终tips
@property(nonatomic,strong) UILabel * tipsLabel;

// 异步多线程队列
@property(nonatomic,strong) dispatch_queue_t serialQueue;



@end

@implementation MainViewController

-(dispatch_queue_t) serialQueue
{
    if(!_serialQueue){
        _serialQueue = dispatch_queue_create("WeatherVCSerialQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _serialQueue;
}


- (AVPlayer *)backgroundPlayer
{
    if(!_backgroundPlayer){
        _backgroundPlayer = [[AVPlayer alloc]init];
        
        
    }
    return _backgroundPlayer;
}

- (NSString *)bundlePath{
    if(!_bundlePath){
        _bundlePath = [[NSBundle mainBundle]pathForResource:@"resources" ofType:@"bundle"];
    }
    return _bundlePath;
}





- (void)viewDidLoad
{
    // 初始化WeatherModel
    [WeatherModel sharedInstance].mvc = self;
    
    // 获取屏幕参数
    windowWidth = [UIScreen mainScreen].bounds.size.width;
    windowHeight = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor = [UIColor blackColor];
    
    /// 搭建UI界面
    self.backgroundImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 背景画面
    [self.view addSubview:self.backgroundImage];
    self.backgroundImage.image = [UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"background1.jpeg"]];
    
    // 两个界面
    self.weatherView = [[UIView alloc] init];
    [self.view addSubview:self.weatherView];
    [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(58+27);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(self.view.frame.size.height-58-27-82);
    }];
    self.weatherView.backgroundColor = [UIColor clearColor];
    self.airView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.airView];
    [self.airView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(58+27);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(self.view.frame.size.height-58-27-82);
    }];
    self.airView.backgroundColor = [UIColor clearColor];
    self.airView.alpha = 0;
    
    
    

    // 城市名
    self.cityChangeButton = [[UIButton alloc] init];
    [self.view addSubview:self.cityChangeButton];
    [self.cityChangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(58);
        make.size.mas_equalTo(CGSizeMake(49, 20));
    }];
    [self.cityChangeButton setFont:[UIFont systemFontOfSize:18]];
    
    // TODO 切换城市按钮
    
    
    // 日期标签
    self.curDateLabel = [[UILabel alloc]init];
    [self.view addSubview:self.curDateLabel];
    [self.curDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cityChangeButton);
        make.height.equalTo(self.cityChangeButton);
        make.top.equalTo(self.cityChangeButton).with.offset(20);
        make.width.mas_equalTo(200);
    }];
    [self.curDateLabel setFont:[UIFont systemFontOfSize:12]];
    [self.curDateLabel setTextAlignment:NSTextAlignmentCenter];
    [self.curDateLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    
    // 定位按钮
    self.positionButton = [[UIButton alloc] init];
    [self.view addSubview:self.positionButton];
    [self.positionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.view).with.offset(58);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    [self.positionButton setImage:[UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"position.png"]] forState:UIControlStateNormal];
    
    
    
    
    // 当前温度
    self.curTempLabel = [[UILabel alloc]init];
    [self.weatherView addSubview:self.curTempLabel];
    [self.curTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(98, 68));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(183);
    }];
    [self.curTempLabel setTextAlignment:NSTextAlignmentLeft];
    [self.curTempLabel setFont:[UIFont systemFontOfSize:50]];
    [self.curTempLabel setTextColor:[UIColor whiteColor]];
    
    
    // 当前天气
    self.curWeatherLabel = [[UILabel alloc] init];
    [self.weatherView addSubview:self.curWeatherLabel];
    [self.curWeatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.curTempLabel).with.offset(68);
        make.right.equalTo(self.curTempLabel);
        make.size.mas_equalTo(CGSizeMake(32,16));
    }];
    [self.curWeatherLabel setTextAlignment:NSTextAlignmentRight];
    [self.curWeatherLabel setFont:[UIFont systemFontOfSize:10]];
    [self.curWeatherLabel setTextColor:[UIColor grayColor]];
    
    // 今日最高、最低气温
    self.todayHLTempLabel = [[UILabel alloc] init];
    [self.weatherView addSubview:self.todayHLTempLabel];
    [self.todayHLTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.curTempLabel);
        make.top.equalTo(self.curTempLabel).with.offset(40+68);
        make.size.mas_equalTo(CGSizeMake(160, 16));
    }];
    [self.todayHLTempLabel setFont:[UIFont systemFontOfSize:11]];
    [self.todayHLTempLabel setTextAlignment:NSTextAlignmentCenter];
    [self.todayHLTempLabel setTextColor:[UIColor grayColor]];
    
    // line1
    self.line1 = [[UILabel alloc]init];
    [self.weatherView addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.todayHLTempLabel);
        make.top.equalTo(self.todayHLTempLabel).with.offset(72+16);
        make.size.mas_equalTo(CGSizeMake(360, 1));
    }];
    self.line1.backgroundColor = [UIColor grayColor];
    
    // line2
    self.line2 = [[UILabel alloc]init];
    [self.weatherView addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.todayHLTempLabel);
        make.top.equalTo(self.line1).with.offset(107);
        make.size.mas_equalTo(CGSizeMake(360, 1));
    }];
    self.line2.backgroundColor = [UIColor grayColor];
    
    // 分时展示天气的collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 横向滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.weatherTimelineCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 396, 300, 106) collectionViewLayout:layout];
    [self.weatherView addSubview:self.weatherTimelineCollectionView];
    [self.weatherTimelineCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1).with.offset(5);
        make.top.equalTo(self.line1).with.offset(1);
        make.height.mas_equalTo(106);
        make.width.mas_equalTo(350);
    }];
    self.weatherTimelineCollectionView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    self.weatherTimelineCollectionView.showsVerticalScrollIndicator = NO;
    self.weatherTimelineCollectionView.delegate = self;
    self.weatherTimelineCollectionView.dataSource = self;
    // 注册cell
    [self.weatherTimelineCollectionView registerClass:[WeatherTimelineCollectionViewCell class] forCellWithReuseIdentifier:@"WeatherTimelineCollectionViewCell"];

    // 分日期展示的TableView
    self.weatherDaylineTableView = [[UITableView alloc] init];
    [self.weatherView addSubview:self.weatherDaylineTableView];
    [self.weatherDaylineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.line2).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(335, 270));
    }];
    
    self.weatherDaylineTableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    self.weatherDaylineTableView.delegate = self;
    self.weatherDaylineTableView.dataSource = self;
    // 注册cell
    [self.weatherDaylineTableView registerClass:[WeatherDaylineTableViewCell class] forCellReuseIdentifier:@"WeatherDaylineTableViewCell"];
    
    // 底部按钮使用self.view
    // 底部按钮
    self.bottomItemBar = [[UIView alloc]init];
    [self.view addSubview:self.bottomItemBar];
    [self.bottomItemBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(82);
        make.width.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    self.bottomItemBar.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.70];
    
    // 底部按钮
    // 天气按钮
    self.bottomBarWeatherButton = [[UIButton alloc] init];
    [self.view addSubview:self.bottomBarWeatherButton];
    [self.bottomBarWeatherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomItemBar).with.offset(10);
        make.left.equalTo(self.bottomItemBar).with.offset(80);
        make.size.mas_equalTo(CGSizeMake(30, 50));
    }];
    self.bottomBarWeatherButton.enabled = false;
    
    UIImageView *bottomBarWeatherButtonImage = [[UIImageView alloc]init];
    [self.bottomBarWeatherButton addSubview:bottomBarWeatherButtonImage];
    [bottomBarWeatherButtonImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomBarWeatherButton);
        make.top.equalTo(self.bottomBarWeatherButton);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    bottomBarWeatherButtonImage.image = [UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"weaIcon_xiaoyu_2.png" ]];
    
    UILabel * bottomBarWeatherButtonLabel = [[UILabel alloc]init];
    [self.bottomBarWeatherButton addSubview:bottomBarWeatherButtonLabel];
    [bottomBarWeatherButtonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomBarWeatherButton);
        make.bottom.equalTo(self.bottomBarWeatherButton);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    bottomBarWeatherButtonLabel.text = @"天气预报";
    bottomBarWeatherButtonLabel.textAlignment = NSTextAlignmentCenter;
    bottomBarWeatherButtonLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:1 alpha:0.8];
    bottomBarWeatherButtonLabel.font = [UIFont systemFontOfSize:10];
    
    // 空气按钮
    self.bottomBarAirQualityButton = [[UIButton alloc] init];
    [self.view addSubview:self.bottomBarAirQualityButton];
    [self.bottomBarAirQualityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomItemBar).with.offset(10);
        make.right.equalTo(self.bottomItemBar).with.offset(-80);
        make.size.mas_equalTo(CGSizeMake(30, 50));
    }];
    
    UIImageView *bottomBarAirQualityButtonImage = [[UIImageView alloc]init];
    [self.bottomBarAirQualityButton addSubview:bottomBarAirQualityButtonImage];
    [bottomBarAirQualityButtonImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomBarAirQualityButton);
        make.top.equalTo(self.bottomBarAirQualityButton);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    bottomBarAirQualityButtonImage.image = [UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"weaIcon_shachen.png" ]];
    
    UILabel * bottomBarAirQualityButtonLabel = [[UILabel alloc]init];
    [self.bottomBarAirQualityButton addSubview:bottomBarAirQualityButtonLabel];
    [bottomBarAirQualityButtonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomBarAirQualityButton);
        make.bottom.equalTo(self.bottomBarAirQualityButton);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    bottomBarAirQualityButtonLabel.text = @"空气质量";
    bottomBarAirQualityButtonLabel.textColor = [UIColor whiteColor];
    bottomBarAirQualityButtonLabel.font = [UIFont systemFontOfSize:10];
    bottomBarAirQualityButtonLabel.textAlignment = NSTextAlignmentCenter;
    
    
    // 添加按钮事件
    @weakify(self)
    [[self.bottomBarWeatherButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.bottomBarWeatherButton.enabled = false;
        self.bottomBarAirQualityButton.enabled = true;
        
        bottomBarWeatherButtonImage.image =[UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"weaIcon_xiaoyu_2.png" ]];
        bottomBarWeatherButtonLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:1 alpha:0.8];
        
        bottomBarAirQualityButtonImage.image =[UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"weaIcon_shachen.png" ]];
        bottomBarAirQualityButtonLabel.textColor = [UIColor whiteColor];
        
        //渐隐效果
        [UIView animateWithDuration:0.5 animations:^{
            self.weatherView.alpha = 1;
            self.airView.alpha = 0;
        }];
    }];
    
    
    [[self.bottomBarAirQualityButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.bottomBarAirQualityButton.enabled = false;
        self.bottomBarWeatherButton.enabled = true;
        
        bottomBarAirQualityButtonImage.image =[UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"weaIcon_shachen_2.png" ]];
        bottomBarAirQualityButtonLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:1 alpha:0.8];
        
        bottomBarWeatherButtonImage.image =[UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"weaIcon_xiaoyu.png" ]];
        bottomBarWeatherButtonLabel.textColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.5 animations:^{
            self.weatherView.alpha = 0;
            self.airView.alpha = 1;
        }];
        
        
    }];
    
    
    // 页面2的UI界面
    
    // 空气指数
    self.airLabel = [[UILabel alloc]init];
    [self.airView addSubview:self.airLabel];
    [self.airLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(98, 68));
        make.centerX.equalTo(self.airView);
        make.top.equalTo(self.view).with.offset(183);
    }];
    [self.airLabel setTextAlignment:NSTextAlignmentLeft];
    [self.airLabel setFont:[UIFont systemFontOfSize:50]];
    [self.airLabel setTextColor:[UIColor whiteColor]];
    
    
    // 空气质量
    self.airLevelLabel = [[UILabel alloc] init];
    [self.airView addSubview:self.airLevelLabel];
    [self.airLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.airLabel).with.offset(68);
        make.right.equalTo(self.airLabel);
        make.size.mas_equalTo(CGSizeMake(32,16));
    }];
    [self.airLevelLabel setTextAlignment:NSTextAlignmentRight];
    [self.airLevelLabel setFont:[UIFont systemFontOfSize:10]];
    [self.airLevelLabel setTextColor:[UIColor grayColor]];
    
    // 活动描述
    self.airTipsLabel = [[UILabel alloc]init];
    [self.airView addSubview:self.airTipsLabel];
    [self.airTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.airLabel);
        make.top.equalTo(self.airLabel).with.offset(40+68);
        make.size.mas_equalTo(CGSizeMake(300, 16));
    }];
    [self.airTipsLabel setFont:[UIFont systemFontOfSize:11]];
    [self.airTipsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.airTipsLabel setTextColor:[UIColor grayColor]];
    
    // line1
    UILabel * line11 = [[UILabel alloc]init];
    [self.airView addSubview:line11];
    [line11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.airTipsLabel);
        make.top.equalTo(self.airTipsLabel).with.offset(72+16);
        make.size.mas_equalTo(CGSizeMake(360, 1));
    }];
    line11.backgroundColor = [UIColor grayColor];
    
    // line2
    UILabel * line12 = [[UILabel alloc]init];
    [self.airView addSubview:line12];
    [line12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.airTipsLabel);
        make.top.equalTo(line11).with.offset(87);
        make.size.mas_equalTo(CGSizeMake(360, 1));
    }];
    line12.backgroundColor = [UIColor grayColor];
    
    // line3
    UILabel * line13 = [[UILabel alloc]init];
    [self.airView addSubview:line13];
    [line13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.airTipsLabel);
        make.top.equalTo(line12).with.offset(90);
        make.size.mas_equalTo(CGSizeMake(360, 1));
    }];
    line13.backgroundColor = [UIColor grayColor];
    
    UILabel * line14 = [[UILabel alloc]init];
    [self.airView addSubview:line14];
    [line14 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.airTipsLabel);
        make.top.equalTo(line13).with.offset(90);
        make.size.mas_equalTo(CGSizeMake(360, 1));
    }];
    line14.backgroundColor = [UIColor grayColor];
    
    // 详细信息
    // 空气湿度
    UILabel * humidityTitleLabel = [[UILabel alloc] init];
    [self.airView addSubview:humidityTitleLabel];
    [humidityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line11).with.offset(15);
        make.left.equalTo(line11).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(145, 20));
    }];
//    humidityTitleLabel.textColor = [UIColor whiteColor];
    humidityTitleLabel.text = @"空气湿度";
    humidityTitleLabel.font = [UIFont systemFontOfSize:13];
    humidityTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.humidityLabel = [[UILabel alloc]init];
    [self.airView addSubview:self.humidityLabel];
    [self.humidityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(humidityTitleLabel);
        make.top.equalTo(humidityTitleLabel).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(145, 49));
    }];
//    self.humidityLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    self.humidityLabel.font = [UIFont systemFontOfSize:18];
    self.humidityLabel.textAlignment = NSTextAlignmentCenter;
    
    // 血糖指数
    UILabel * bloodSugarTitleLabel = [[UILabel alloc] init];
    [self.airView addSubview:bloodSugarTitleLabel];
    [bloodSugarTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line12).with.offset(15);
        make.left.equalTo(line12).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(145, 20));
    }];
//    bloodSugarTitleLabel.textColor = [UIColor whiteColor];
    bloodSugarTitleLabel.text = @"气压";
    bloodSugarTitleLabel.font = [UIFont systemFontOfSize:13];
    bloodSugarTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.airPressureLabel = [[UILabel alloc]init];
    [self.airView addSubview:self.airPressureLabel];
    [self.airPressureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bloodSugarTitleLabel);
        make.top.equalTo(bloodSugarTitleLabel).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(145, 49));
    }];
//    self.airPressureLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    self.airPressureLabel.font = [UIFont systemFontOfSize:18];
    self.airPressureLabel.textAlignment = NSTextAlignmentCenter;
    
    // 洗车指数
    UILabel * washCarTitleLabel = [[UILabel alloc] init];
    [self.airView addSubview:washCarTitleLabel];
    [washCarTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line13).with.offset(15);
        make.left.equalTo(line13).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(145, 20));
    }];
//    washCarTitleLabel.textColor = [UIColor whiteColor];
    washCarTitleLabel.text = @"风力";
    washCarTitleLabel.font = [UIFont systemFontOfSize:13];
    washCarTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.windForceLabel = [[UILabel alloc]init];
    [self.airView addSubview:self.windForceLabel];
    [self.windForceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(washCarTitleLabel);
        make.top.equalTo(washCarTitleLabel).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(145, 49));
    }];
//    self.windForceLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    self.windForceLabel.font = [UIFont systemFontOfSize:18];
    self.windForceLabel.textAlignment = NSTextAlignmentCenter;
    
    // 紫外线指数
    UILabel * ultravioletTitleLabel = [[UILabel alloc] init];
    [self.airView addSubview:ultravioletTitleLabel];
    [ultravioletTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line11).with.offset(15);
        make.right.equalTo(line11).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(145, 20));
    }];
//    ultravioletTitleLabel.textColor = [UIColor whiteColor];
    ultravioletTitleLabel.text = @"紫外线强度";
    ultravioletTitleLabel.font = [UIFont systemFontOfSize:13];
    ultravioletTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.ultravioletLabel = [[UILabel alloc]init];
    [self.airView addSubview:self.ultravioletLabel];
    [self.ultravioletLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ultravioletTitleLabel);
        make.top.equalTo(ultravioletTitleLabel).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(145, 49));
    }];
//    self.ultravioletLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    self.ultravioletLabel.font = [UIFont systemFontOfSize:18];
    self.ultravioletLabel.textAlignment = NSTextAlignmentCenter;
    
    // 穿衣指数
    UILabel * wearClothesTitleLabel = [[UILabel alloc] init];
    [self.airView addSubview:wearClothesTitleLabel];
    [wearClothesTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line12).with.offset(15);
        make.right.equalTo(line12).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(145, 20));
    }];
//    wearClothesTitleLabel.textColor = [UIColor whiteColor];
    wearClothesTitleLabel.text = @"风向";
    wearClothesTitleLabel.font = [UIFont systemFontOfSize:13];
    wearClothesTitleLabel.textAlignment = NSTextAlignmentCenter;

    self.windDirectionLabel = [[UILabel alloc]init];
    [self.airView addSubview:self.windDirectionLabel];
    [self.windDirectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wearClothesTitleLabel);
        make.top.equalTo(wearClothesTitleLabel).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 49));
    }];
//    self.windDirectionLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    self.windDirectionLabel.font = [UIFont systemFontOfSize:18];
    self.windDirectionLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tipsLabel = [[UILabel alloc] init];
    [self.airView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(line14);
        make.top.equalTo(line14).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(335, 20));
    }];
    self.tipsLabel.font = [UIFont systemFontOfSize:13];
    self.tipsLabel.textColor = [UIColor grayColor];
    
    // 先获取本地数据
    [[WeatherModel sharedInstance] loadDataFromBundle];
    [self loadData];
    [self.weatherTimelineCollectionView reloadData];
    // 从网络尝试获取数据并更新显示，异步更新
    dispatch_async(self.serialQueue, ^{
        [[WeatherModel sharedInstance] loadDataFromNet];
    });
}

// 加载数据
-(void)loadData
{
    // 加载本地数据
    WeatherModel *weatherModel = [WeatherModel sharedInstance];
    [weatherModel loadDataFromBundle];
    
    [self.cityChangeButton setTitle:weatherModel.weatherData[@"city"] forState:UIControlStateNormal];
    self.curDateLabel.text = [(NSString*)weatherModel.weatherData[@"data"][0][@"date"] stringByAppendingPathComponent:(NSString*)weatherModel.weatherData[@"data"][0][@"day"]];
    // 获取当前时间
    NSDate * date = [NSDate date];
    //NSLog(@"%@",date);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * comps1 = [calendar components:NSHourCalendarUnit fromDate:date];
    long hour =[comps1 hour];
    NSLog(@"curTime:%ld",hour);
    hour = (hour - 8) % 24;
    self.curTempLabel.text = [NSString stringWithFormat:@"%@°", weatherModel.weatherData[@"data"][0][@"hours"][hour][@"tem"] ];
    self.curWeatherLabel.text = weatherModel.weatherData[@"data"][0][@"hours"][hour][@"wea"];
    
    
    // 检索今日最高、最低温度
    NSArray *todayData = weatherModel.weatherData[@"data"][0][@"hours"];
    //NSLog(@"%@",todayData);
    float HTem = -100;
    float LTem = 100;
    for(NSDictionary *curDic in todayData){
        if(HTem < [curDic[@"tem"] floatValue]){
            HTem =[curDic[@"tem"] floatValue];
        }
        if(LTem > [curDic[@"tem"] floatValue]){
            LTem = [curDic[@"tem"] floatValue];
        }
    }
    self.todayHLTempLabel.text = [NSString stringWithFormat:@"最高气温：%.0f° 最低气温：%.0f°",HTem,LTem];
    
    
    // view2
    self.airLabel.text = weatherModel.weatherData[@"data"][0][@"air"];
    self.airLevelLabel.text = weatherModel.weatherData[@"data"][0][@"air_level"];
    self.airTipsLabel.text = weatherModel.weatherData[@"data"][0][@"air_tips"];
    self.humidityLabel.text = weatherModel.weatherData[@"data"][0][@"humidity"];
    self.airPressureLabel.text = [((NSString*)weatherModel.weatherData[@"data"][0][@"pressure"]) stringByAppendingString:@" HPa"];
    self.windForceLabel.text = weatherModel.weatherData[@"data"][0][@"win_speed"];
    self.ultravioletLabel.text = weatherModel.weatherData[@"data"][0][@"index"][0][@"level"];
    
    // 可能有多个风向，添加
    self.windDirectionLabel.text = @"";
    for(NSString * windDirection in ((NSArray*)(weatherModel.weatherData[@"data"][0][@"win"]))){
        self.windDirectionLabel.text = [self.windDirectionLabel.text stringByAppendingString:[NSString stringWithFormat:@" %@",windDirection]];
    }
    
    int random = arc4random()%5; //显示随机的一条tips
    self.tipsLabel.text = weatherModel.weatherData[@"data"][0][@"index"][random][@"desc"];
    
    // 视图加载数据
    [self.weatherDaylineTableView reloadData];
    [self.weatherTimelineCollectionView reloadData];
}



#pragma mark - UICollectionView的代理方法

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray*)[WeatherModel sharedInstance].weatherData[@"data"][0][@"hours"]).count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 从缓存池获取cell
    WeatherTimelineCollectionViewCell * cell = [self.weatherTimelineCollectionView dequeueReusableCellWithReuseIdentifier:@"WeatherTimelineCollectionViewCell" forIndexPath:indexPath];
    
    // 设置数据
    cell.timeLabel.text = [WeatherModel sharedInstance].weatherData[@"data"][0][@"hours"][indexPath.row][@"hours"];
    cell.temLabel.text = [NSString stringWithFormat:@"%@°",[WeatherModel sharedInstance].weatherData[@"data"][0][@"hours"][indexPath.row][@"tem"]];
    // TODO 设置天气图标
    cell.weatherImageView.image = [UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"weaIcon_%@.png",[WeatherModel sharedInstance].weatherData[@"data"][0][@"hours"][indexPath.row][@"wea_img"]]]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(28, 78);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 35.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 35.0;
}


#pragma mark - UITableView的代理方法
// 多少个session
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
// 对应session的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)[WeatherModel sharedInstance].weatherData[@"data"]).count;
}
// tableView的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 从缓存池获取
    //WeatherDaylineTableViewCell * cell = [self.weatherDaylineTableView dequeueReusableCellWithIdentifier:@"WeatherDaylineTableViewCell" forIndexPath:indexPath];
    // 新建cell
    WeatherDaylineTableViewCell * cell = [[WeatherDaylineTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 335, 20)];
    
    cell.dateLabel.text = [WeatherModel sharedInstance].weatherData[@"data"][indexPath.row][@"day"];

    // 设置天气图标,选择首个天气即可（TODO 更新选择策略）

    cell.weaIcon.image = [UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"weaIcon_%@",[WeatherModel sharedInstance].weatherData[@"data"][indexPath.row][@"wea_day_img"]]]];
    // 最高、最低温度
    NSArray * temps =[WeatherModel sharedInstance].weatherData[@"data"][indexPath.row][@"hours"];
    float hTemp = -100,lTemp = 100;

    for(NSDictionary * dic in temps){
        if(hTemp < [dic[@"tem"] floatValue]){
            hTemp =[dic[@"tem"] floatValue];
        }
        if(lTemp > [dic[@"tem"] floatValue]){
            lTemp = [dic[@"tem"] floatValue];
        }
    }
    cell.hTem.text = [NSString stringWithFormat:@"%.0f",hTemp];
    cell.lTem.text = [NSString stringWithFormat:@"%.0f",lTemp];
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

@end
