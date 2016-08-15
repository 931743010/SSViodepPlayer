//
//  SSVideoPlayerAnimation.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "SSVideoPlayerAnimation.h"

#define kScreenBoundWidth [UIScreen mainScreen].bounds.size.width
#define kScreenBoundHeight [UIScreen mainScreen].bounds.size.height

@implementation SSVideoPlayerAnimation


-(CAAnimationGroup*) animationImageSmal
{
    CAAnimationGroup * animationGround = [CAAnimationGroup animation];
    CABasicAnimation * scaleAnimation = [self animationScale:(kScreenBoundWidth*kScreenBoundHeight)/(200*kScreenBoundWidth) toValue:1.0];
    CABasicAnimation * roatAnimation  = [self rotationWithdirection:0];
    animationGround.animations = @[roatAnimation,scaleAnimation];
    animationGround.duration = 0.3;
    animationGround.removedOnCompletion = NO;
    animationGround.fillMode = kCAFillModeForwards;
    [animationGround setValue:@"small" forKey:@"animationSmall"];
    
    
    return animationGround;
}

-(CAAnimationGroup*) animationZoomFullWithOrientation:(DeviceOrientation) orientation
{
 
    int direction = 0;
    
    if (orientation== OrientationLandscapeLeft) {
        
        direction = -90;
    }else{
        direction = 90;
    }
    CAAnimationGroup * animationGround = [CAAnimationGroup animation];
    CABasicAnimation * scaleAnimation = [self animationScale:1.0 toValue:(kScreenBoundWidth*kScreenBoundHeight)/(200*kScreenBoundWidth)];
    CABasicAnimation * roatAnimation  = [self rotationWithdirection:direction];
    animationGround.animations = @[roatAnimation,scaleAnimation];
    animationGround.duration = 5;
    animationGround.removedOnCompletion = NO;
    animationGround.fillMode = kCAFillModeForwards;
    animationGround.delegate = self;
    [animationGround setValue:@"full" forKey:@"animation"];
    
    return animationGround;
}

-(CABasicAnimation*) animationScale:(CGFloat) fromValue toValue:(CGFloat) toValue
{
    CABasicAnimation * baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    baseAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    baseAnimation.toValue = [NSNumber numberWithFloat:toValue];
    baseAnimation.removedOnCompletion = NO;
    baseAnimation.fillMode = kCAFillModeForwards;
    return baseAnimation;
}

-(CABasicAnimation *)rotationWithdirection:(int)direction
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation([self radians:direction], 0, 0,1.0);
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    return animation;
}
-(double)radians:(float) degrees
{
    
    return ( degrees * 3.14159265 ) / 180.0;
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"animation"]isEqualToString:@"full"]) {
        
        if ([self.delegate respondsToSelector:@selector(fullAnimationStop)]) {
            
            [self.delegate performSelector:@selector(fullAnimationStop)];
        }
    }
    if ([[anim valueForKey:@"animationSmall"] isEqualToString:@"small"]) {
        
        if ([self.delegate respondsToSelector:@selector(smallAnimationStop)]) {
            [self.delegate performSelector:@selector(smallAnimationStop)];
        }
    }
}

@end
