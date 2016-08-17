//
//  SSVideoControlView.h
//  SSVideoPlayer
//
//  Created by shimly on 16/8/16.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSVideoPlayerBaseView.h"

@protocol SSVideoControlViewDelegate <NSObject>

-(void)zoomAction:(UIButton*) button;
-(void)goBackAction;


-(void)sliderBeginAction:(UISlider*) slider;

-(void)sliderUpdateAction:(UISlider*) slider;

-(void)sliderEndAction:(UISlider*) slider;

@end

@interface SSVideoControlView : UIView
@property(nonatomic,strong)UILabel * currentTimeLabel;
@property(nonatomic,strong)UILabel * totalTimeLable;
//缓存进度条
@property(nonatomic,strong)UIProgressView * cacheProgressView;
//slider
@property(nonatomic,strong)UISlider   * slider;

@property(nonatomic,strong)UIButton   * zoomButton;

@property(nonatomic,assign) id<SSVideoControlViewDelegate> delegate;






@end
