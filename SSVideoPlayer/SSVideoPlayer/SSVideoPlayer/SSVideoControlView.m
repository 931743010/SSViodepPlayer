//
//  SSVideoControlView.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/16.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "SSVideoControlView.h"
#import "Masonry.h"
@interface SSVideoControlView()

@property(nonatomic,strong)UIView * bottomView;


@end
@implementation SSVideoControlView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bottomView];
       
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapControlView)];
        [self addGestureRecognizer:tapGesture];
        [self makeConstraints];
        
    }
    
    return self;
}
-(void)tapControlView
{
    
    
    
}
-(void)makeConstraints
{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.left.right.mas_offset(0);
        make.height.mas_offset(40);
    }];
   
}


-(UIView*)bottomView
{
    if (!_bottomView) {
        
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor yellowColor];
    }
    return _bottomView;
}














@end
