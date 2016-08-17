//
//  SSVideoControlView.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/16.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "SSVideoControlView.h"
#import "Masonry.h"
#define animtionTime 0.3
@interface SSVideoControlView()


@property(nonatomic,strong)UIView * backgroundBottomView;
@property(nonatomic,strong)UIView * zoomView;

@property(nonatomic,strong)UIButton * ssvideoBackButton;
@property(nonatomic,strong)UIView * ssvideoBackView;



@end
@implementation SSVideoControlView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
       
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapControlView)];
        [self addGestureRecognizer:tapGesture];
        [self initSubView];
        [self makeConstraints];
        self.bottomViewShow = YES;
        
        
    }
    
    return self;
}
-(void)tapControlView
{
    
    if ([self.delegate respondsToSelector:@selector(tapVideoControlViewAction)]) {
        [self.delegate performSelector:@selector(tapVideoControlViewAction)];
    }
    
}
-(void)initSubView
{
    [self addSubview:self.closeButton];
    [self addSubview:self.bottomView];
    [self addSubview:self.toNavigationView];
    [self addSubview:self.playerStatusButton];
    [self.bottomView addSubview:self.currentTimeLabel];
    [self.bottomView addSubview:self.totalTimeLable];
    [self.bottomView addSubview:self.cacheProgressView];
    [self.bottomView addSubview:self.slider];
   
    [self.bottomView addSubview:self.zoomView];
    [self.zoomView addSubview:self.zoomButton];
    
    [self.toNavigationView addSubview:self.ssvideoBackView];
    [self.ssvideoBackView addSubview:self.ssvideoBackButton];
    
}
-(void)makeConstraints
{
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.width.height.mas_offset(30);
        make.left.top.mas_offset(3);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.left.right.mas_offset(0);
        make.height.mas_offset(40);
    }];
    
    [self.toNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(40);
        
    }];
    
    [self.playerStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_offset(59);
        make.center.mas_equalTo(self);
    }];
    
    [self.ssvideoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(5);
        make.bottom.mas_offset(-5);
        make.width.mas_offset(50);
        
    }];
    [self.ssvideoBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.ssvideoBackView);
        make.width.height.mas_offset(20);
        
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(5);
        make.width.mas_offset(60);
        
    }];
    [self.zoomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.bottom.mas_offset(0);
        make.width.mas_offset(40);
    }];
    [self.zoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.height.mas_offset(20);
        make.center.mas_equalTo(self.zoomView);
        
    }];
    
    [self.totalTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_offset(0);
        make.right.mas_equalTo(self.zoomButton.mas_left).mas_offset(0);
        make.width.mas_offset(60);
        
    }];
    [self.cacheProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currentTimeLabel.mas_right).mas_offset(0);
        make.right.mas_equalTo(self.totalTimeLable.mas_left).mas_offset(0);
        make.centerY.mas_equalTo(self.bottomView).mas_offset(1);
        make.height.mas_offset(2);
        
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_equalTo(self.cacheProgressView).mas_offset(0);
        make.centerY.mas_equalTo(self.bottomView);
        make.height.mas_offset(40);
        
    }];
   
}

-(UIProgressView*)cacheProgressView
{
    if (!_cacheProgressView) {
        _cacheProgressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        
        _cacheProgressView.progressTintColor = [UIColor colorWithRed:117/255.0f green:117/255.0f blue:117/255.0f alpha:1];
     
        _cacheProgressView.trackTintColor    = [UIColor clearColor];
        
    }
    
    return _cacheProgressView;
}
-(UISlider*) slider
{
    if (!_slider) {
        
        _slider = [[UISlider alloc] init];
        [_slider setThumbImage:[UIImage imageNamed:SSVideoImageName(@"SSPlayer_slider")] forState:UIControlStateNormal];
        _slider.maximumValue    = 1;
        [_slider addTarget:self action:@selector(updateSliderAction:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(beginSliderAction:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(endSliderAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        _slider.minimumTrackTintColor = [UIColor redColor];
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    
    return _slider;
}


-(UILabel*) totalTimeLable
{
    if (!_totalTimeLable) {
        _totalTimeLable = [UILabel new];
        _totalTimeLable.text = @"00:00";
        _totalTimeLable.textAlignment = NSTextAlignmentCenter;
        _totalTimeLable.textColor = [UIColor whiteColor];
        _totalTimeLable.font = [UIFont systemFontOfSize:13];
        
    }
    
    return _totalTimeLable;
}
-(UILabel*) currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [UILabel new];
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:13];
        
    }
    
    return _currentTimeLabel;
}

-(UIView*)zoomView
{
    if (!_zoomView) {
        _zoomView = [UIView new];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapZoomViewAction)];
        [_zoomView addGestureRecognizer:tap];
    }
    
    return _zoomView;
}
-(UIButton*)zoomButton
{
    if (!_zoomButton) {
    
        _zoomButton = [UIButton new];
        _zoomButton.selected = NO;
        [_zoomButton setBackgroundImage:[UIImage imageNamed:SSVideoImageName(@"SSVideo_zoom_full")] forState:UIControlStateNormal];
        [_zoomButton setBackgroundImage:[UIImage imageNamed:SSVideoImageName(@"SSVideo_zoom_smal")] forState:UIControlStateSelected];
        [_zoomButton addTarget:self action:@selector(zoonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _zoomButton;
}

-(UIView*)bottomView
{
    if (!_bottomView) {
        
        _bottomView = [UIView new];
        _backgroundBottomView = [UIView new];
        [_bottomView addSubview:_backgroundBottomView];
        [_backgroundBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _backgroundBottomView.backgroundColor = [UIColor blackColor];
        _backgroundBottomView.alpha = 0.7;
   
    }
    return _bottomView;
}

-(UIView*)toNavigationView
{
    if (!_toNavigationView) {
        
        _toNavigationView = [UIView new];
        _toNavigationView.alpha = 0;
    }
    
    return _toNavigationView;
}

-(UIButton*)ssvideoBackButton
{
    if (!_ssvideoBackButton) {
        _ssvideoBackButton = [UIButton new];
        [_ssvideoBackButton setBackgroundImage:[UIImage imageNamed:SSVideoImageName(@"SSVideoBack")] forState:UIControlStateNormal];
        [_ssvideoBackButton addTarget:self action:@selector(goBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _ssvideoBackButton;
}
-(UIView*)ssvideoBackView
{
    if (!_ssvideoBackView) {
        _ssvideoBackView = [UIView new];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackViewAction)];
        [_ssvideoBackView addGestureRecognizer:tap];
        
    }
    
    return _ssvideoBackView;
}

-(UIButton*)playerStatusButton
{
    if (!_playerStatusButton) {
        
        _playerStatusButton = [UIButton new];
        _playerStatusButton.selected = NO;
        [_playerStatusButton setBackgroundImage:[UIImage imageNamed:SSVideoImageName(@"SSVideo_pause")] forState:UIControlStateNormal];
        [_playerStatusButton setBackgroundImage:[UIImage imageNamed:SSVideoImageName(@"SSVideo_player")] forState:UIControlStateSelected];
        [_playerStatusButton addTarget:self action:@selector(pauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _playerStatusButton;
}

-(UIButton*) closeButton
{
    if (!_closeButton) {
        
        _closeButton = [UIButton new];
        _closeButton.hidden = YES;
        [_closeButton setBackgroundImage:[UIImage imageNamed:SSVideoImageName(@"SSVideo_close")] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}


#pragma mark 进度条开始滑动
-(void)beginSliderAction:(UISlider*) slider
{
    if ([self.delegate respondsToSelector:@selector(sliderBeginAction:)]) {
        
        [self.delegate performSelector:@selector(sliderBeginAction:) withObject:slider];
    }
    
}
#pragma mark 进度条滑动中
-(void)updateSliderAction:(UISlider*) slider
{   /*
    if ([self.delegate respondsToSelector:@selector(sliderUpdateAction:)]) {
        [self.delegate performSelector:@selector(sliderUpdateAction:) withObject:slider];
    }*/
}

#pragma mark 结束滑动
-(void)endSliderAction:(UISlider*) slider
{
    if ([self.delegate respondsToSelector:@selector(sliderEndAction:)]) {
        [self.delegate performSelector:@selector(sliderEndAction:) withObject:slider];
    }
}


#pragma mark 返回按钮
-(void)goBackViewAction
{
    if ([self.delegate respondsToSelector:@selector(goBackAction)]) {
        [self.delegate performSelector:@selector(goBackAction)];
    }
    
}
-(void)goBackButtonAction
{
    [self goBackViewAction];
}

#pragma mark 缩放按钮
-(void)tapZoomViewAction
{
    
    self.zoomButton.selected = !self.zoomButton.selected ;
    if ([self.delegate respondsToSelector:@selector(zoomAction:)]) {
        [self.delegate performSelector:@selector(zoomAction:) withObject:self.zoomButton];
    }
    
}
-(void)zoonButtonAction:(UIButton*) button
{
    [self tapZoomViewAction];
}

#pragma mark 开始、暂停
-(void)pauseButtonAction:(UIButton*) button
{
   
    if ([self.delegate respondsToSelector:@selector(pauseAction:)]) {
        [self.delegate performSelector:@selector(pauseAction:) withObject:button];
    }
     button.selected = !button.selected;
}
#pragma mark 小屏幕下 close事件
-(void)closeButtonAction
{
    if ([self.delegate respondsToSelector:@selector(closeAction)]) {
        
        [self.delegate performSelector:@selector(closeAction)];
    }
}

-(void)setBottomViewShow:(BOOL)bottomViewShow
{
    _bottomViewShow = bottomViewShow;
    
    [UIView animateWithDuration:animtionTime animations:^{
        self.bottomView.alpha = bottomViewShow ? 1 : 0;
        self.playerStatusButton.alpha = bottomViewShow ? 1 : 0;
        
    } completion:^(BOOL finished) {
        
       
    }];
    
}
-(void)setToNavigationShow:(BOOL)toNavigationShow
{
    _toNavigationShow = toNavigationShow;
    
    [UIView animateWithDuration:animtionTime animations:^{
        self.toNavigationView.alpha = toNavigationShow ? 1 : 0;
        
    } completion:^(BOOL finished) {
       
    }];
    
}













@end
