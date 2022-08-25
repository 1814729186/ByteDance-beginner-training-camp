//
//  weatherDaylineTableViewCell.h
//  CampWorkPro02
//
//  Created by ByteDance on 2022/8/8.
//
#import <UIKit/UIKit.h>


@interface WeatherDaylineTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * dateLabel;
@property(nonatomic,strong) UIImageView * weaIcon;
@property(nonatomic,strong) UILabel * hTem;
@property(nonatomic,strong) UILabel * lTem;

@end
