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
//********* set 方法 *******************
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem * playerItem = (AVPlayerItem*) object;
    
    if ([keyPath isEqualToString:@"status"])
    {
        if ([playerItem status]==AVPlayerStatusReadyToPlay) {
            
            NSLog(@"播放成功");
            
        }else if ([playerItem status]==AVPlayerItemStatusFailed){
            
            NSLog(@"播放失败 = %@",playerItem.error);
        }
    }else if ([keyPath isEqualToString:@"contentOffset"]){
        
        if (self.deviceOrientation == OrientationPortrait) {
            [self monitorTableViewContenOffset];
            
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
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.videoUrl]];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.playerLayer.frame = self.layer.bounds;
    [self.layer addSublayer:_playerLayer];
    
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [self addNotification];
    
    [self play];
    [self setAutoresizesSubviews:NO];
    
    
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
    
    // 监听 status 属性变化
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
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
}

-(void)resetVideoPlayer
{
    [self pause];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.player = nil;
    
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.playerItem = nil;
    
    self.tableViewCell = nil;
    self.tableView = nil;
    
}
-(void)play{
      [self.player play];
}

-(void)pause{
    [self.player pause];
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

@end
