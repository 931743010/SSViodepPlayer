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
-(void)pauseAction:(UIButton*) button;
-(void)closeAction;

-(void)tapVideoControlViewAction;

-(void)sliderBeginAction:(UISlider*) slider;

//-(void)sliderUpdateAction:(UISlider*) slider;

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
//控制 底部操作栏 是否显示
@property(nonatomic,assign)BOOL         bottomViewShow;
//控制顶部 导航栏是否显示
@property(nonatomic,assign)BOOL         toNavigationShow;

@property(nonatomic,strong)UIView * toNavigationView;

@property(nonatomic,strong)UIView * bottomView;

@property(nonatomic,strong)UIButton * playerStatusButton;

@property(nonatomic,strong)UIButton * closeButton;
//旋转菊花
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property(nonatomic,assign) id<SSVideoControlViewDelegate> delegate;






@end
