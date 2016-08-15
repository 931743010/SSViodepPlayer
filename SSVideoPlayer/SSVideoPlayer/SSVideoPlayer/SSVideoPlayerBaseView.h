//
//  SSVideoPlayerBaseView.h
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger,DeviceOrientation)
{
    OrientationPortrait,
    OrientationLandscapeLeft,
    OrientationLandscapeRight
};
@interface SSVideoPlayerBaseView : UIView

@property(nonatomic,strong)AVPlayerItem     * playerItem;
@property(nonatomic,strong)AVPlayerLayer    * playerLayer;
@property(nonatomic,strong)AVPlayer         * player;

@property(nonatomic,strong)NSString               * videoUrl;

@property(nonatomic,assign)CGFloat                  MP2;

@property(nonatomic,strong)UITableView            * tableView;
@property(nonatomic,strong)UITableViewCell        * tableViewCell;
@property(nonatomic,strong)NSIndexPath            * indexPath;

@property(nonatomic,assign)DeviceOrientation  deviceOrientation;
-(void)setBaseOrientationPortrait;
-(void)setBaseOrientationLandscapeLeft;
-(void)setBaseOrientationLandscapeRight;
-(void)initViewWithTableView:(UITableView*) tableView cell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath videoUrl:(NSString*) videoUrl;
@end
