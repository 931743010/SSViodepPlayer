//
//  SSVideoPlayerView.h
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SSVideoPlayerBaseView.h"
#define kScreenBoundWidth [UIScreen mainScreen].bounds.size.width
#define kScreenBoundHeight [UIScreen mainScreen].bounds.size.height

@interface SSVideoPlayerView : SSVideoPlayerBaseView



+(SSVideoPlayerView*) shareSSVideoPlayerManager;

@property(nonatomic,strong)UIImageView * tempImageView;
-(void)initViewWithTableView:(UITableView*) tableView cell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath videoUrl:(NSString*) videoUrl;

@end
