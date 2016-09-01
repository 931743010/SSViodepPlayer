//
//  VideoController.m
//  SSVideoPlayer
//
//  Created by shimly on 16/9/1.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "VideoController.h"
#import "Masonry.h"
#import "SSVideoPlayerView.h"

@interface VideoController ()<SSVideoPlayerViewDelegate>
@property(nonatomic,strong)UIView * videoView;
@property(nonatomic,strong)SSVideoPlayerView * videoPlayer;
@end

@implementation VideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initVideoView];
  
}
-(void)initVideoView
{
    self.videoView = [UIView new];
    [self.view addSubview:self.videoView];
    self.videoView.frame = CGRectMake(0, 64, self.view.frame.size.width, 200);
    
     self.videoPlayer = [SSVideoPlayerView shareSSVideoPlayerManager];
    
    self.videoPlayer.delegate = self;
    
    [self.videoPlayer initVideoPlayerWithView:self.videoView];
    
}
-(void)goBackSSVideoPlayerView
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.videoPlayer pushDetailView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end