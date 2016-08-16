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
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;

@end
@implementation SSVideoControlView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        self.alpha = 0.2;
        
        [self addSubview:self.bottomView];
        self.frame =frame;
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

-(void)updateFrame
{
  
}

-(UIView*)bottomView
{
    if (!_bottomView) {
        
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor yellowColor];
    }
    return _bottomView;
}
-(CGFloat)height
{
    
    return self.frame.size.height<self.frame.size.width ? self.frame.size.height : self.frame.size.width;
}
-(CGFloat)width{
    return self.frame.size.width>self.frame.size.height ? self.frame.size.width : self.frame.size.height;
}













@end
