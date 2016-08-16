//
//  VideoDataCenter.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/16.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "VideoDataCenter.h"
#import "UIKit+AFNetworking.h"
@interface VideoDataCenter ()

@property(nonatomic,strong)AFHTTPSessionManager * manager;
@end
@implementation VideoDataCenter
-(instancetype)init
{
    self = [super init];
    if (self) {
        
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html",@"text/plain", nil];
    }
    
    return self;
}
-(void)requestVideoList:(void(^)(NSString * error)) complate
{
    
        [_manager GET:@"http://c.m.163.com/nc/video/home/1-10.html" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:NULL];
            
            NSArray * array = [dic valueForKey:@"videoList"];
            self.videoListArray = array;
            complate(nil);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
}









@end
