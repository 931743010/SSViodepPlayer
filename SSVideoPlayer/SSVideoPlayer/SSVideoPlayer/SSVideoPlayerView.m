//
//  SSVideoPlayerView.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "SSVideoPlayerView.h"
#import "Masonry.h"
#import "SSVideoControlView.h"

#define animationTime 0.4

@interface SSVideoPlayerView ()<SSVideoControlViewDelegate>
@property(nonatomic,strong) SSVideoControlView * videoControlView;
@property(nonatomic,assign)BOOL               sliderUpdate;//为了解决滑动中slider跳动的问题
@end
@implementation SSVideoPlayerView

+(SSVideoPlayerView*) shareSSVideoPlayerManager
{
    static id ssvideoPlayerManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ssvideoPlayerManager = [[self alloc] init];
        
    });
    return ssvideoPlayerManager;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
-(void)setBaseOrientationPortrait
{
    self.videoControlView.zoomButton.selected = NO;
    [self smallScreenZoomFromFull];
    
}

-(void)setBaseOrientationLandscape
{
     self.videoControlView.zoomButton.selected = YES;
    [self fullScreenZoomFromSmall];
}
-(void)setVideoDisplay:(VideoPlayerDisplay)videoDisplay
{
    [super setVideoDisplay:videoDisplay];
    if (videoDisplay==ScreenFullDisplay) {
        self.videoControlView.bottomView.hidden = NO;
        self.videoControlView.playerStatusButton.hidden = NO;
        self.videoControlView.toNavigationView.hidden = NO;
        
       [UIApplication  sharedApplication].statusBarHidden = YES;
        
    }else if(videoDisplay==ScreenMinDisplay) {
        self.videoControlView.bottomView.hidden = YES;
         self.videoControlView.playerStatusButton.hidden = YES;
        self.videoControlView.toNavigationView.hidden = YES;
        
        [UIApplication sharedApplication].statusBarHidden = NO;
    }else{
        self.videoControlView.bottomView.hidden = NO;
         self.videoControlView.playerStatusButton.hidden = NO;
        self.videoControlView.toNavigationView.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = NO;
        
    }
    self.videoControlView.frame = self.bounds;

}

//最小化 右下角
-(void)minVideoPlayer
{
    if (self.isScreenBottom) {
        return;
    }

   
    [self removeFromSuperview];
    
    self.transform = CGAffineTransformIdentity;
    
    CGFloat width = SSVideoScreenBoundWidth/2;
    
    CGFloat height = width*(9.0/16.0);
    
    self.frame = CGRectMake(width, SSVideoScreenBoundHeight-height, width, height);
    
    self.playerLayer.frame = self.bounds;
    
    self.videoDisplay = ScreenMinDisplay;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
   
    
    self.isScreenBottom = YES;
}

//cell屏幕 -> 全屏
-(void)fullScreenZoomFromSmall
{
    
   
     [UIView animateWithDuration:animationTime animations:^{
            [self removeFromSuperview];
         
            self.transform = CGAffineTransformMakeRotation(self.MP2);
            
        } completion:^(BOOL finished) {
      
        }];
    
     self.frame = CGRectMake(0, 0, SSVideoScreenBoundWidth, SSVideoScreenBoundHeight);
     self.playerLayer.frame =  CGRectMake(0,0, SSVideoScreenBoundHeight,SSVideoScreenBoundWidth);
    
   
     [[UIApplication sharedApplication].keyWindow addSubview:self];
  
     self.videoDisplay = ScreenFullDisplay;
}


//全屏->小屏 cell上播放
-(void)smallScreenZoomFromFull
{
  
    [UIView animateWithDuration:animationTime animations:^{
        [self removeFromSuperview];
         self.transform = CGAffineTransformIdentity;
        self.videoControlView.transform =CGAffineTransformIdentity;
   
    } completion:^(BOOL finished) {
        
    }];
    UIImageView * imageView = [self currentPlayerImageView];
    [self addSSVideoPlayerView:imageView];
    
 
    
    self.videoDisplay = ScreenCellDisplay;
}

//在tableView上初始化 播放器
-(void)initViewWithTableView:(UITableView*) tableView cell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath videoUrl:(NSString*) videoUrl
{
    [super initViewWithTableView:tableView cell:cell indexPath:indexPath videoUrl:videoUrl];
    
    UIImageView * imageView = [self currentPlayerImageView];
    
    [self addSSVideoPlayerView:imageView];
    
    self.videoUrl = videoUrl;
    
    self.videoControlView.hidden = NO;
}
//获取当前的播放器的subView
-(UIImageView*)currentPlayerImageView
{
      UIImageView * imageView = (UIImageView*)[self.tableViewCell.contentView viewWithTag:1000+self.indexPath.row];
    
    return imageView;
}
//添加播放器到 imageView上
-(void)addSSVideoPlayerView:(UIImageView*) imageView
{
    [imageView addSubview:self];
  
    [imageView bringSubviewToFront:self];
    
    self.frame = imageView.bounds;
    self.playerLayer.frame = self.frame;
    
}
//重置播放器
-(void)resetVideoPlayer
{
    [super resetVideoPlayer];
    [self.videoControlView removeFromSuperview];
    self.videoControlView = nil;
}

//设置缓存进度
-(void)cacheProgress:(CGFloat)progress
{
    [self.videoControlView.cacheProgressView setProgress:progress animated:NO];
}
//设置slider 的进度
-(void)sliderProgressWithCurrentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime
{
    
    if (!self.sliderUpdate) {
         self.videoControlView.slider.value = currentTime/totalTime;
    }
   
    
    self.videoControlView.currentTimeLabel.text = [self timePlayerString:currentTime];
    self.videoControlView.totalTimeLable.text  = [self timePlayerString:totalTime];
}
-(void)moviePlayDidEnd:(NSNotification *)notification
{
    NSLog(@"播放完成");
}

//当前时间
-(NSString*) timePlayerString:(CGFloat) time
{
    
    NSInteger minute  = (NSInteger)time/ 60;//当前秒
    NSInteger second  = (NSInteger)time % 60;//当前分
    
    return [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

#pragma mark 缩放按钮
-(void)zoomAction:(UIButton *)button
{
    
    if (button.selected) {
        [super setInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        
    }else{
        
        [super setInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

#pragma mark 返回按钮事件
-(void)goBackAction
{
    if (self.videoDisplay) {
        [super setInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
    
}

#pragma mark slider开始滑动
-(void)sliderBeginAction:(UISlider *)slider
{
    self.sliderUpdate = YES;
}
#pragma mark slider结束滑动
-(void)sliderEndAction:(UISlider *)slider
{

    [super seekTimeWithSecton:slider.value completionHandler:^(BOOL finished) {
        self.sliderUpdate = NO;
        
    }];
}
#pragma mark 点击屏幕事件
-(void)tapVideoControlViewAction
{
    
    if (self.videoDisplay==ScreenMinDisplay) {
        return;
    }
    BOOL flag = self.videoControlView.bottomViewShow;
    
    self.videoControlView.bottomViewShow = !flag;
    
    if (self.videoDisplay==ScreenCellDisplay) {
        
        self.videoControlView.toNavigationShow = NO;
    }else if(self.videoDisplay==ScreenFullDisplay){
        
        self.videoControlView.toNavigationShow = !flag;
        
    }
}
-(void)pauseAction:(UIButton *)button
{
    if (!button.selected) {
        [self pause];
    }else{
        [self play];
    }
}

-(void)play{
    [super play];
}

-(void)pause{
    [super pause];
}

-(SSVideoControlView*)videoControlView
{
    if (!_videoControlView) {
        
        _videoControlView = [[SSVideoControlView alloc] initWithFrame:self.playerLayer.frame];
        _videoControlView.delegate = self;
        [self addSubview:_videoControlView];
      
    }
    
    return _videoControlView;
}





@end
