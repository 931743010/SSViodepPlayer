//
//  SSVideoPlayerView.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "SSVideoPlayerView.h"
#import "Masonry.h"
#import "SSVideoPlayerAnimation.h"
#define kScreenBoundWidth [UIScreen mainScreen].bounds.size.width
#define kScreenBoundHeight [UIScreen mainScreen].bounds.size.height

#define animationTime 0.3

@interface SSVideoPlayerView ()<SSVideoPlayerAnimationDelgate>

@property(nonatomic,strong)SSVideoPlayerAnimation * animation;

@property(nonatomic,assign)CGFloat                  screenTop;
@property(nonatomic,strong)AVPlayerItem     * playerItem;
@property(nonatomic,strong)AVPlayerLayer    * playerLayer;
@property(nonatomic,strong)AVPlayer         * player;

@property(nonatomic,strong)UITableView            * tableView;
@property(nonatomic,strong)UITableViewCell        * tableViewCell;
@property(nonatomic,strong)NSIndexPath            * indexPath;
@property(nonatomic,assign)CGFloat                  MP2;

@property(nonatomic,assign)DeviceOrientation  deviceOrientation;

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
           self.animation = [[SSVideoPlayerAnimation alloc] init];
           self.animation.delegate = self;
    }
    
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
    
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


-(void)setVideoUrl:(NSString *)videoUrl
{
    _videoUrl = videoUrl;
    
    [self initPlayerLayer];
    
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
        [self setBaseOrientationLandscapeLeft];
        
    }else if ( interfaceOrientation==UIInterfaceOrientationLandscapeRight && self.deviceOrientation !=OrientationLandscapeRight)
    {
        self.deviceOrientation = OrientationLandscapeRight;
        [self setBaseOrientationLandscapeRight];
    }
}

-(void)setBaseOrientationPortrait
{
    [self smallScreenZoomFromFull];
    
}

-(void)setBaseOrientationLandscapeRight
{
    [self fullScreenZoomFromSmall];
    
}
-(void)setBaseOrientationLandscapeLeft
{
    [self fullScreenZoomFromSmall];
 
}

-(void)fullScreenZoomFromSmall
{
        [self removeFromSuperview];
        [UIView animateWithDuration:animationTime animations:^{
              self.transform = CGAffineTransformMakeRotation(self.MP2);
        } completion:^(BOOL finished) {
            
        }];
        self.frame = CGRectMake(0, 0, kScreenBoundWidth, kScreenBoundHeight);
        self.playerLayer.frame =  CGRectMake(0,0, kScreenBoundHeight,kScreenBoundWidth);
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}



-(void)smallScreenZoomFromFull
{
    [self removeFromSuperview];
    [UIView animateWithDuration:animationTime animations:^{
         self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    self.frame = CGRectMake(0, 0, kScreenBoundWidth, kScreenBoundHeight);
    self.playerLayer.frame =  CGRectMake(0,0, kScreenBoundWidth,kScreenBoundHeight);
    
    UIImageView * imageView = [self currentPlayerImageView];
    [self addSSVideoPlayerView:imageView];
    
 
}


-(void)initViewWithTableView:(UITableView*) tableView cell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath videoUrl:(NSString*) videoUrl
{
  
    self.tableView      =  tableView;
    self.tableViewCell  =  cell;
    self.indexPath      =  indexPath;
    
    
    UIImageView * imageView = [self currentPlayerImageView];
    
    [self addSSVideoPlayerView:imageView];
    
    self.videoUrl = videoUrl;
    

    
}

-(UIImageView*)currentPlayerImageView
{
      UIImageView * imageView = (UIImageView*)[self.tableViewCell.contentView viewWithTag:1000+self.indexPath.row];
    
    return imageView;
}

-(void)addSSVideoPlayerView:(UIImageView*) imageView
{
    [imageView addSubview:self];
  
    [imageView bringSubviewToFront:self];
    
    self.frame = imageView.bounds;
}
-(void) fullAnimationStop
{
    
    
}
-(void)smallAnimationStop
{
    
    
}





@end
