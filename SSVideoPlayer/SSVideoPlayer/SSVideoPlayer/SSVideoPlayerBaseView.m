//
//  SSVideoPlayerBaseView.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "SSVideoPlayerBaseView.h"

@interface SSVideoPlayerBaseView ()

@property(nonatomic,assign)CGFloat tableCellHeight;
@property(nonatomic,strong)NSTimer * timer;

@end

@implementation SSVideoPlayerBaseView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self setAutoresizesSubviews:NO];
    }
    
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
    
}
//********* set 方法 *******************
-(void)setVideoUrl:(NSString *)videoUrl
{
    _videoUrl = videoUrl;
    
    [self initPlayerLayer];
    
}
-(void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)setVideoDisplay:(VideoPlayerDisplay)videoDisplay
{
    _videoDisplay = videoDisplay;
    
}
-(void)setPalyerState:(VideoPlayerState)palyerState
{
    _palyerState = palyerState;
}
//********* set 方法 *******************
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem * playerItem = (AVPlayerItem*) object;
    
    if ([keyPath isEqualToString:@"status"])
    {
        if ([playerItem status]==AVPlayerStatusReadyToPlay) {
            
            self.palyerState = SSVideo_Playing;
            [self playerInterval];
            
        }else if ([playerItem status]==AVPlayerItemStatusFailed){
            
            self.palyerState = SSVideo_Faild;
        }
    }else if ([keyPath isEqualToString:@"contentOffset"]){
        
        if (self.deviceOrientation == OrientationPortrait) {
            [self monitorTableViewContenOffset];
            
        }
        
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        //如果缓存为空 设置为缓冲状态
        if (self.playerItem.playbackBufferEmpty) {
            self.palyerState = SSVideo_Bufferinng;
        }
        
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        NSTimeInterval  timeInterval = [self availableDuration];
        CMTime duration             = self.playerItem.duration;
        CGFloat totalDuration       = CMTimeGetSeconds(duration);
        
        CGFloat progress = timeInterval/totalDuration;
        
        [self cacheProgress:progress];

    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        if (self.playerItem.playbackLikelyToKeepUp && self.palyerState == SSVideo_Bufferinng){
             self.palyerState = SSVideo_Playing;
        }
    }
}

-(void)monitorTableViewContenOffset
{
    
    CGRect rect = [self.tableView rectForRowAtIndexPath:self.indexPath];
    CGRect rectFormSuperview = [self.tableView convertRect:rect toView:[self.tableView superview]];
    CGFloat rectY = rectFormSuperview.origin.y-64;
    
    
    if ([[NSValue valueWithCGRect:rect] isEqualToValue:[NSValue valueWithCGRect:CGRectZero]]) {
        
        return;
    }
    //一旦 滑动的位置大于 cell的 2/3 那么最小化
    if (rectY<0 && -rectY>self.tableCellHeight*(2.0/3.0)) {
        [self minVideoPlayer];
       
    }else if (SSVideoScreenBoundHeight-64<rectFormSuperview.origin.y){
        [self minVideoPlayer];
     
    }else{
      
        if (!self.isScreenBottom) {
            return;
        }
        self.deviceOrientation = OrientationPortrait;
        [self setBaseOrientationPortrait];
        self.isScreenBottom = NO;
        
        
    }
    
}

//初始化播放器
-(void)initPlayerLayer
{
    //站位图
    UIImage *image = [self imageWithColor:[UIColor blackColor]];
     self.layer.contents = (id) image.CGImage;
    
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.videoUrl]];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.playerLayer.frame = self.layer.bounds;
    [self.layer addSublayer:_playerLayer];
    
    [self addNotification];

    [self play];
    [self setAutoresizesSubviews:NO];
    
    
    
}

//每秒执行一次
-(void)playerInterval
{
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:NULL usingBlock:^(CMTime time){
        NSArray *loadedRanges = weakSelf.playerItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && weakSelf.playerItem.duration.timescale != 0)
        {

            weakSelf.palyerState = SSVideo_Playing;
            
            //更新 播放时间
            CGFloat currentPlayerTime = [weakSelf currentPlayerTimer];
            CGFloat totalPlayerTime   = [weakSelf totalPlayerTimer];
            
            [weakSelf sliderProgressWithCurrentTime:currentPlayerTime totalTime:totalPlayerTime];
            
        }
        
    }];
}

-(void)addNotification
{
    //设备旋转通知
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationNotification)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    

    
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackgroundNotification) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGroundNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监听 status 属性变化
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听缓存
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    
     [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
     [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
}
-(void)onDeviceOrientationNotification
{
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    [self setInterfaceOrientation:interfaceOrientation];
}

-(void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if (self.isScreenBottom) {
        return;
    }
    
    if (interfaceOrientation==UIInterfaceOrientationPortrait && self.deviceOrientation!=OrientationPortrait) {
        
        self.deviceOrientation = OrientationPortrait;
        [self setBaseOrientationPortrait];
        
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft && self.deviceOrientation!=OrientationLandscapeLeft){
        
        self.deviceOrientation = OrientationLandscapeLeft;
        [self setBaseOrientationLandscape];
        
    }else if ( interfaceOrientation==UIInterfaceOrientationLandscapeRight && self.deviceOrientation !=OrientationLandscapeRight)
    {
        self.deviceOrientation = OrientationLandscapeRight;
        [self setBaseOrientationLandscape];
    }
}

-(void)setDeviceOrientation:(DeviceOrientation)deviceOrientation
{
    _deviceOrientation = deviceOrientation;
    
    if (deviceOrientation==OrientationLandscapeLeft) {
    
        self.MP2 = -M_PI_2;
    }
    if (deviceOrientation==OrientationLandscapeRight) {

        self.MP2 = M_PI_2;
    }
  
    
    
}
-(void)initViewWithTableView:(UITableView*) tableView cell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath videoUrl:(NSString*) videoUrl
{
    if (self.playerLayer) {
        [self resetVideoPlayer];
    }
    
    self.tableView      =  tableView;
    self.tableViewCell  =  cell;
    self.indexPath      =  indexPath;
    self.tableCellHeight = cell.frame.size.height;
    

    self.deviceOrientation = OrientationPortrait;
 
}

-(void)resetVideoPlayer
{
    [self pause];
    
   
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.player = nil;
    self.isScreenBottom = NO;
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    
 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.playerItem = nil;
    
    self.tableViewCell = nil;
    self.tableView = nil;
    self.indexPath = nil;
    
}
-(void)play{
      [self.player play];
}

-(void)pause{
    [self.player pause];
    self.palyerState = SSVideo_Pause;
}

#pragma mark 计算视频缓冲进度
-(NSTimeInterval)availableDuration
{
    NSArray * loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    
    
    CMTimeRange timeRanges     = [loadedTimeRanges.firstObject CMTimeRangeValue];
    
    float startSeconds         = CMTimeGetSeconds(timeRanges.start);
    
    float duiationSeconds      = CMTimeGetSeconds(timeRanges.duration);
    
    NSTimeInterval result      = startSeconds+duiationSeconds;
    
    return result;
    
}

//视频播放总时长
-(CGFloat)totalPlayerTimer
{
    CGFloat totalPalyerTime = (self.playerItem.duration.value / self.playerItem.duration.timescale)-self.ctmNumber;
    
    return totalPalyerTime;
}
//视频播放当前时长
-(CGFloat)currentPlayerTimer
{
    CGFloat currentPlayTime = CMTimeGetSeconds([self.playerItem currentTime])-self.ctmNumber;
    
    return currentPlayTime;
}
//设置视频 跳转的 秒数
- (void)seekTimeWithSecton:(CGFloat)precent completionHandler:(void (^)(BOOL finished))complate
{
    CGFloat seekTime =   [self totalPlayerTimer]*precent;
    
   [self.player seekToTime:CMTimeMakeWithSeconds(seekTime,NSEC_PER_SEC) completionHandler:^(BOOL finished) {
      
       
       if (complate) {
           complate(finished);
       }
   }];
    
    
}
//颜色成成图片
-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)appDidEnterBackgroundNotification
{
    
}

-(void)appDidEnterPlayGroundNotification
{
    
}

-(void)moviePlayDidEnd:(NSNotification*) notification
{
    
}

-(void)minVideoPlayer
{
    
}

-(void)setBaseOrientationPortrait
{
    
}
-(void)setBaseOrientationLandscape
{
    
}
-(void)cacheProgress:(CGFloat) progress
{
    
}

-(void)sliderProgressWithCurrentTime:(CGFloat) currentTime totalTime:(CGFloat)totalTime
{
    
}







@end
