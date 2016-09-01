//
//  VideoController.h
//  SSVideoPlayer
//
//  Created by shimly on 16/9/1.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoController : UIViewController
@property(nonatomic,strong)NSIndexPath * indexPath;
@property(nonatomic,strong)NSString    * url;
@property(nonatomic,strong)UITableView * tableView;
@end
