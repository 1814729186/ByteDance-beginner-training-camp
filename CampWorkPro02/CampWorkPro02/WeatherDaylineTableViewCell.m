//
//  weatherDaylineTableViewCell.m
//  CampWorkPro02
//
//  Created by ByteDance on 2022/8/8.
//

#import <Foundation/Foundation.h>
#import "WeatherDaylineTableViewCell.h"
#import "Masonry/Masonry.h"

@interface WeatherDaylineTableViewCell()

@end

@implementation WeatherDaylineTableViewCell

- (instancetype)init
{
    self = [super init];
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        // 左、中、右，最右四块
        _dateLabel = [[UILabel alloc]init];
        [self addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(90, 20));
        }];
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        [_dateLabel setTextColor:[UIColor grayColor]];
        
        
        _weaIcon = [[UIImageView alloc] init];
        [self addSubview:_weaIcon];
        [_weaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        _lTem = [[UILabel alloc]init];
        [self addSubview:_lTem];
        [_lTem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        [_lTem setFont:[UIFont systemFontOfSize:12]];
        [_lTem setTextColor:[UIColor grayColor]];
        
        _hTem = [[UILabel alloc] init];
        [self addSubview:_hTem];
        [_hTem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-40);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        [_hTem setFont:[UIFont systemFontOfSize:12]];
        [_hTem setTextColor:[UIColor grayColor]];
        
    }
    return self;
}

@end
