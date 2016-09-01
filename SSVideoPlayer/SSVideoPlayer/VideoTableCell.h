//
//  VideoTableCell.h
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoTableCellDelegate <NSObject>

-(void)didSelectVideoWithIndexPath:(NSIndexPath*) indexPath;
-(void)didSelectImageViewWitnIndexPath:(NSIndexPath*) indexPath;

@end

@interface VideoTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *VideoImageView;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property(nonatomic,assign) id<VideoTableCellDelegate> delegate;
@end
