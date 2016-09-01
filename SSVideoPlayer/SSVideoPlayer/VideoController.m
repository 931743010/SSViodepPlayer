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
#import "VideoTableCell.h"
#import "UIKit+AFNetworking.h"

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
    
    UIImageView * imageView = [UIImageView new];
    imageView.userInteractionEnabled = YES;
    [self.videoView addSubview:imageView];
    imageView.frame = self.videoView.bounds;
    [imageView setImageWithURL:[NSURL URLWithString:self.coverUrl]];
    
    UIButton * button = [UIButton new];
    [button addTarget:self action:@selector(playerAction) forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:[UIImage imageNamed:SSVideoImageName(@"SSVideo_player")] forState:UIControlStateNormal];
    [imageView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.mas_equalTo(imageView);
        make.size.mas_offset(CGSizeMake(59, 59));
    }];
    
    
    self.videoPlayer = [SSVideoPlayerView shareSSVideoPlayerManager];
    self.videoPlayer.autoPlayerDeatil = NO;
    self.videoPlayer.delegate = self;
    
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    
    
    [self.videoPlayer initVideoPlayerWithView:imageView tableView:self.tableView cell:cell indexPath:self.indexPath url:self.url];
    
}

-(void)playerAction
{
    
}

-(void)goBackSSVideoPlayerView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
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
