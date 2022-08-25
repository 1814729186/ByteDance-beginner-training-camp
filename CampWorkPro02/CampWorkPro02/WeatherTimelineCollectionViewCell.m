//
//  weatherTimelineTableViewCell.m
//  CampWorkPro02
//
//  Created by ByteDance on 2022/8/7.
//

#import <Foundation/Foundation.h>
#import "WeatherTimelineCollectionViewCell.h"
#import "Masonry/Masonry.h"


@interface WeatherTimelineCollectionViewCell()


@end

@implementation WeatherTimelineCollectionViewCell

// 初始化函数
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        // 上、中、下三个位置，两个Label，一个image
        self.timeLabel = [[UILabel alloc] init];
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.width.equalTo(self);
            make.height.mas_equalTo(self.frame.size.width/2);
        }];
        [self.timeLabel setFont:[UIFont systemFontOfSize:10]];
        [self.timeLabel setTextColor:[UIColor grayColor]];
        
        self.weatherImageView = [[UIImageView alloc]init];
        [self addSubview:self.weatherImageView];
        [self.weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.frame.size.width));
        }];
        
        self.temLabel = [[UILabel alloc]init];
        [self addSubview:self.temLabel];
        [self.temLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.timeLabel);
            make.bottom.equalTo(self);
            make.centerX.equalTo(self);
        }];
        [self.temLabel setFont:[UIFont systemFontOfSize:10]];
        [self.temLabel setTextColor:[UIColor grayColor]];
    
    }
    return self;
}

@end

