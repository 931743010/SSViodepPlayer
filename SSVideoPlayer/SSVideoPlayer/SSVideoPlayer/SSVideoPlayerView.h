//
//  SSVideoPlayerView.h
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

@interface SSVideoPlayerView : UIView


@property(nonatomic,strong)NSString               * videoUrl;
+(SSVideoPlayerView*) shareSSVideoPlayerManager;

@property(nonatomic,strong)UIImageView * tempImageView;
-(void)initViewWithTableView:(UITableView*) tableView cell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath videoUrl:(NSString*) videoUrl;

@end
