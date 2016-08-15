//
//  SSVideoPlayerAnimation.h
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSVideoPlayerView.h"


@protocol SSVideoPlayerAnimationDelgate <NSObject>

-(void)fullAnimationStop;
-(void)smallAnimationStop;

@end
@interface SSVideoPlayerAnimation : UIView

@property(nonatomic,assign)id<SSVideoPlayerAnimationDelgate> delegate;

-(CAAnimationGroup*) animationZoomFullWithOrientation:(DeviceOrientation) orientation;
-(CAAnimationGroup*) animationImageSmal;

@end
