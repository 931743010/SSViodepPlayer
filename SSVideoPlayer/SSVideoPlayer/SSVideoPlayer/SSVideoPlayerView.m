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

@interface SSVideoPlayerView ()
@property(nonatomic,strong)SSVideoControlView * videoControlView;
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
    
    [self smallScreenZoomFromFull];
    
}

-(void)setBaseOrientationLandscape
{
    [self fullScreenZoomFromSmall];
}
-(void)setVideoDisplay:(VideoPlayerDisplay)videoDisplay
{
    [super setVideoDisplay:videoDisplay];
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
           // self.videoControlView.transform =CGAffineTransformMakeRotation(self.MP2);
            
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
    
    //[self videoControlView];
    
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
-(void)resetVideoPlayer
{
    [super resetVideoPlayer];
    [self.videoControlView removeFromSuperview];
    self.videoControlView = nil;
}

-(SSVideoControlView*)videoControlView
{
    if (!_videoControlView) {
        
        _videoControlView = [[SSVideoControlView alloc] initWithFrame:self.playerLayer.frame];
        [self addSubview:_videoControlView];
      
    }
    
    return _videoControlView;
}





@end
