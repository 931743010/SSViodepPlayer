//
//  VideoDataCenter.h
//  SSVideoPlayer
//
//  Created by shimly on 16/8/16.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoDataCenter : NSObject

@property(nonatomic,strong)NSArray * videoListArray;
-(void)requestVideoList:(void(^)(NSString * error)) complate;
@end
