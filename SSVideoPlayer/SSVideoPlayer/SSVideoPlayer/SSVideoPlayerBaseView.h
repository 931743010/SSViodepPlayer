//
//  SSVideoPlayerBaseView.h
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



#define SSVideoScreenBoundWidth [UIScreen mainScreen].bounds.size.width
#define SSVideoScreenBoundHeight [UIScreen mainScreen].bounds.size.height
#define SSVideoImageName(name) [NSString stringWithFormat:@"SSVideoBundle.bundle/%@",name]
//当前屏幕状态
typedef NS_ENUM(NSInteger,DeviceOrientation)
{
    OrientationPortrait,
    OrientationLandscapeLeft,
    OrientationLandscapeRight
};
//视频显示状态

typedef NS_ENUM(NSInteger,VideoPlayerDisplay) {
    ScreenCellDisplay,//cell
    ScreenFullDisplay,//全屏
    ScreenMinDisplay//最小化
};

//视频播放状态
typedef NS_ENUM(NSInteger,VideoPlayerState) {
    SSVideo_Playing,
    SSVideo_Pause,
    SSVideo_Bufferinng,
    SSVideo_Faild
};

@interface SSVideoPlayerBaseView : UIView

@property(nonatomic,assign)BOOL isScreenBottom;//是否在底部显示
@property(nonatomic,assign)BOOL isStartPlayer;//是否已经播放
@property(nonatomic,assign)BOOL isDetailPlayer;//是否为详情播放

@property(nonatomic,strong)AVPlayerItem     * playerItem;
@property(nonatomic,strong)AVPlayerLayer    * playerLayer;
@property(nonatomic,strong)AVPlayer         * player;

@property(nonatomic,assign)NSInteger        ctmNumber;//从第多少秒开始播放

@property(nonatomic,strong)NSString               * videoUrl;

@property(nonatomic,assign)CGFloat                  MP2;

@property(nonatomic,strong)UITableView            * tableView;
@property(nonatomic,strong)UITableViewCell        * tableViewCell;
@property(nonatomic,strong)NSIndexPath            * indexPath;

@property(nonatomic,strong)UIView                 * detailView;//详情播放的view

@property(nonatomic,assign)DeviceOrientation  deviceOrientation;
@property(nonatomic,assign)VideoPlayerDisplay videoDisplay;
@property(nonatomic,assign)VideoPlayerState   palyerState;


-(void)setBaseOrientationPortrait;
-(void)setBaseOrientationLandscape;
-(void)minVideoPlayer;
-(void)resetVideoPlayer;
-(void)cacheProgress:(CGFloat) progress;
-(void)moviePlayDidEnd:(NSNotification*) notification;
-(void)appDidEnterBackgroundNotification;

-(void)appDidEnterPlayGroundNotification;

-(void)play;
-(void)pause;

- (void)seekTimeWithSecton:(CGFloat)precent completionHandler:(void (^)(BOOL finished))complate;

-(void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

-(void)sliderProgressWithCurrentTime:(CGFloat) currentTime totalTime:(CGFloat)totalTime;

-(void)initViewWithTableView:(UITableView*) tableView cell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath videoUrl:(NSString*) videoUrl;

-(void)initVideoPlayerWithView:(UIView *)view tableView:(UITableView*) tableView cell:(UITableViewCell*)cell  indexPath:(NSIndexPath*) indexPath url:(NSString*) videoUrl;




@end
