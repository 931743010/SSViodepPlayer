//
//  SSVideoControlView.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/16.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "SSVideoControlView.h"
#import "Masonry.h"
@interface SSVideoControlView()

@property(nonatomic,strong)UIView * bottomView;
@property(nonatomic,strong)UIView * backgroundBottomView;
@property(nonatomic,strong)UIView * zoomView;


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
        
    }
    
    return self;
}
-(void)tapControlView
{
    
    
    
}
-(void)initSubView
{
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.currentTimeLabel];
    [self.bottomView addSubview:self.totalTimeLable];
    [self.bottomView addSubview:self.cacheProgressView];
    [self.bottomView addSubview:self.slider];
   
    [self.bottomView addSubview:self.zoomView];
    [self.zoomView addSubview:self.zoomButton];
}
-(void)makeConstraints
{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.left.right.mas_offset(0);
        make.height.mas_offset(40);
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
       /* [_slider addTarget:self action:@selector(updateSliderAction:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(beginSliderAction:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(endSliderAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];*/
        
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












@end
