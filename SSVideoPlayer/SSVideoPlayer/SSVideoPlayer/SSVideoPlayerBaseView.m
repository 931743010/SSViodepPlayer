//
//  SSVideoPlayerBaseView.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "SSVideoPlayerBaseView.h"

@implementation SSVideoPlayerBaseView

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
    
    self.playerLayer.frame = self.bounds;
    
}
-(void)setVideoUrl:(NSString *)videoUrl
{
    _videoUrl = videoUrl;
    
    [self initPlayerLayer];
    
}
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
    }
}

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
    
    [self.player play];
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
    self.tableView      =  tableView;
    self.tableViewCell  =  cell;
    self.indexPath      =  indexPath;
}
-(void)setBaseOrientationPortrait
{
    
}
-(void)setBaseOrientationLandscape
{
    
}

@end
