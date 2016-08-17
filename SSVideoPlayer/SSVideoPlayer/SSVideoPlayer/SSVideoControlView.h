//
//  SSVideoControlView.h
//  SSVideoPlayer
//
//  Created by shimly on 16/8/16.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSVideoPlayerBaseView.h"

@interface SSVideoControlView : UIView
@property(nonatomic,strong)UILabel * currentTimeLabel;
@property(nonatomic,strong)UILabel * totalTimeLable;
//缓存进度条
@property(nonatomic,strong)UIProgressView * cacheProgressView;
//slider
@property(nonatomic,strong)UISlider   * slider;
@end
