//
//  VideoTableCell.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "VideoTableCell.h"
#import "Masonry.h"
#import "SSVideoPlayerBaseView.h"

@implementation VideoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.descLabel.backgroundColor = [UIColor clearColor];
    self.VideoImageView.userInteractionEnabled = YES;
 
   
    
    UITapGestureRecognizer *  tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
   
    [self.VideoImageView addGestureRecognizer:tapImageView];
    UIButton * playerButton = [UIButton new];
    [playerButton addTarget:self action:@selector(playerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.VideoImageView addSubview:playerButton];
    [playerButton setImage:[UIImage imageNamed:SSVideoImageName(@"SSVideo_player")] forState:UIControlStateNormal];
    [playerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(59, 59));
        
    }];
}
-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.VideoImageView.tag = 1000+indexPath.row;
}
-(void)playerAction
{
    if ([self.delegate respondsToSelector:@selector(didSelectVideoWithIndexPath:)]) {
        
        [self.delegate performSelector:@selector(didSelectVideoWithIndexPath:) withObject:self.indexPath];
    }
}

-(void)tapImage
{
   
    if ([self.delegate respondsToSelector:@selector(didSelectImageViewWitnIndexPath:)]) {
        
        [self.delegate performSelector:@selector(didSelectImageViewWitnIndexPath:) withObject:self.indexPath]
        ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
