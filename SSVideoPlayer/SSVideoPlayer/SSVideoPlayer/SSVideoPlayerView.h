//
//  SSVideoPlayerView.h
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SSVideoPlayerBaseView.h"

@protocol SSVideoPlayerViewDelegate <NSObject>

-(void)goBackSSVideoPlayerView;

@end

@interface SSVideoPlayerView : SSVideoPlayerBaseView



+(SSVideoPlayerView*) shareSSVideoPlayerManager;

@property(nonatomic,strong)UIImageView * tempImageView;
@property(nonatomic,assign) id<SSVideoPlayerViewDelegate> delegate;


-(void)initViewWithTableView:(UITableView*) tableView cell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath videoUrl:(NSString*) videoUrl;
-(void)pushDetailView;

@end
