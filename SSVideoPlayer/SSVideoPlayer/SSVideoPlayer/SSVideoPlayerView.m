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

@interface SSVideoPlayerView ()
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
  
    [super initViewWithTableView:tableView cell:cell indexPath:indexPath videoUrl:videoUrl];
    
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







@end
