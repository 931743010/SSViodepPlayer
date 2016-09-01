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
@property(nonatomic,strong)NSTimer              *timer;
@property(nonatomic,strong) SSVideoControlView  * videoControlView;
@property(nonatomic,assign)BOOL                sliderUpdate;//为了解决滑动中slider跳动的问题
@property(nonatomic,assign)BOOL                 isUserPauseAction;//是否为用户手动暂停
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
    [self smallScreenZoomFromFull:nil];
    
}

-(void)setBaseOrientationLandscape
{
     self.videoControlView.zoomButton.selected = YES;
    [self fullScreenZoomFromSmall];
}

-(void)setPalyerState:(VideoPlayerState)palyerState
{
    [super setPalyerState:palyerState];
    palyerState==SSVideo_Bufferinng ? [self.videoControlView.activity startAnimating] : [self.videoControlView.activity stopAnimating];
    
    
    
}
-(void)setVideoDisplay:(VideoPlayerDisplay)videoDisplay
{
    [super setVideoDisplay:videoDisplay];
    BOOL flag = self.videoControlView.bottomViewShow;
    if (videoDisplay==ScreenFullDisplay) {

        self.videoControlView.bottomView.hidden = NO;
        self.videoControlView.playerStatusButton.hidden = NO;
        self.videoControlView.toNavigationView.hidden = NO;
        self.videoControlView.toNavigationShow = flag;
        self.videoControlView.closeButton.hidden = YES;
       [UIApplication  sharedApplication].statusBarHidden = YES;
        
    }else if(videoDisplay==ScreenMinDisplay) {

        self.videoControlView.bottomView.hidden = YES;
         self.videoControlView.playerStatusButton.hidden = YES;
        self.videoControlView.toNavigationView.hidden = YES;
        self.videoControlView.closeButton.hidden = NO;
        
        [UIApplication sharedApplication].statusBarHidden = NO;
    }else{
        self.videoControlView.bottomView.hidden = NO;
         self.videoControlView.playerStatusButton.hidden = NO;
        self.videoControlView.toNavigationView.hidden = YES;
        self.videoControlView.toNavigationShow = NO;
        self.videoControlView.closeButton.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = NO;
        
    }
    self.videoControlView.frame = self.bounds;

}
//程序进入后台
-(void)appDidEnterBackgroundNotification
{
    
    
    self.videoControlView.playerStatusButton.selected = YES;
    [self pause];
    
    if (self.palyerState == SSVideo_Playing) {
        self.isUserPauseAction = NO;
    }
}
//程序回到前台
-(void)appDidEnterPlayGroundNotification
{
    if (self.isUserPauseAction) return;
    
    self.videoControlView.playerStatusButton.selected = NO;
    [self play];
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
    

    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
   
    self.videoDisplay = ScreenMinDisplay;
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
-(void)smallScreenZoomFromFull:(void(^)()) complate
{
  
    [UIView animateWithDuration:animationTime animations:^{
        [self removeFromSuperview];
         self.transform = CGAffineTransformIdentity;
        self.videoControlView.transform =CGAffineTransformIdentity;
   
    } completion:^(BOOL finished) {
       
        if (complate) {
            complate();
        }
    }];
    
    if (self.isDetailPlayer) {
        
        [self addSSVideoPlayerDetailView:self.detailView];
        
        self.videoDisplay = ScreenCellDisplay;
        
        return;
    }
 
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
    [self startVideoPlayer:videoUrl];
    
    
}

//视频从cell上进入详情播放页面
-(void)initVideoPlayerWithView:(UIImageView *)imageView tableView:(UITableView*) tableView cell:(UITableViewCell*)cell  indexPath:(NSIndexPath*) indexPath url:(NSString*) videoUrl
{
    
    
    if (![self.indexPath isEqual:indexPath]) {
        
            //判断当前的播放器是否初始化
        if (self.playerLayer) {
            
            [self resetVideoPlayer];
        }
            [self startVideoPlayer:videoUrl];
  
    }
    
    [super initVideoPlayerWithView:imageView tableView:tableView cell:cell indexPath:indexPath url:videoUrl];
 
    [self addSubViewPlayerView:imageView];
   
    
}
//开始播放
-(void)startVideoPlayer:(NSString*) videoUrl
{
    self.videoUrl = videoUrl;
    [self createAutoHideTimer];
    
    self.palyerState = SSVideo_Bufferinng;
    
}
//添加视频播放器到 view上
-(void)addSubViewPlayerView:(UIImageView*) imageView
{
    self.isDetailPlayer = YES;
    self.detailView = imageView;
    [self removeFromSuperview];
    
    [self addSSVideoPlayerDetailView:imageView];
}


//创建计时器 用于 videoControView 的显示与隐藏
-(void)createAutoHideTimer
{
    if (self.timer) {
        return;
    }
    self.timer  = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(autoHideTimerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    

}
//取消延迟隐藏
-(void)cancleAutoTimer
{
    [self.timer invalidate];
     self.timer = nil;
}
//每6秒执行一次
-(void)autoHideTimerAction:(NSTimer*) timer
{
    //如果是暂停状态 不会自动隐藏
    self.videoControlView.bottomViewShow = NO;
    self.videoControlView.toNavigationShow = NO;
    
    [self cancleAutoTimer];
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
//添加播放器到详情view上进行播放
-(void)addSSVideoPlayerDetailView:(UIImageView*) view
{
    [view addSubview:self];
    [view bringSubviewToFront:self];
    self.frame = view.bounds;
    self.playerLayer.frame = self.frame;
    
    //重新加载 vieoControlView  矫正位置
    [self correctVieoControlView];
}

//从详情页面推出 回到cell上继续播放
-(void)pushDetailView
{
    self.isDetailPlayer = NO;
    UIImageView * imageView = [self currentPlayerImageView];
    [self addSSVideoPlayerView:imageView];
    [self correctVieoControlView];
}


//重置播放器
-(void)resetVideoPlayer
{
    if (self.videoDisplay ==ScreenFullDisplay ) {
        [self smallScreenZoomFromFull:^{
            
            [self resetAction];
        }];
        return;
    }
    
    [self resetAction];
    
   
    
    
   
}
-(void)resetAction
{
    [super resetVideoPlayer];
    [_videoControlView removeFromSuperview];
    _videoControlView = nil;
    [self cancleAutoTimer];
    [self removeFromSuperview];
    
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
//播放结束
-(void)moviePlayDidEnd:(NSNotification *)notification
{
   
    [self resetVideoPlayer];
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
    //如果需要的话
    if (self.isDetailPlayer && self.deviceOrientation ==OrientationPortrait ) {
        
        
        if ([self.delegate respondsToSelector:@selector(goBackSSVideoPlayerView)]) {
            [self.delegate performSelector:@selector(goBackSSVideoPlayerView)];
        }
        return;
    }
    
    
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

    
    if (!self.isStartPlayer) {
        return;
    }
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
    
    if (self.videoControlView.bottomViewShow) {
        [self createAutoHideTimer];
    }else{
        [self cancleAutoTimer];
    }
}
#pragma mark close事件
-(void)closeAction
{
    
    [self resetVideoPlayer];
}
#pragma mark 暂停播放
-(void)pauseAction:(UIButton *)button
{
    if (!button.selected) {
        self.isUserPauseAction = YES;
        [self pause];
    }else{
        [self play];
    }
}

-(void)play{
    [super play];
    [self createAutoHideTimer];
   
}

-(void)pause{
    [super pause];
    //暂停的时候  不隐藏
    [self cancleAutoTimer];
   
}

//矫正 vieoControlView
-(void)correctVieoControlView
{
    _videoControlView.frame = self.playerLayer.frame;
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
