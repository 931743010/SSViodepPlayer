//
//  ViewController.m
//  SSVideoPlayer
//
//  Created by shimly on 16/8/15.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "ViewController.h"
#import "VideoTableCell.h"
#import "SSVideoPlayerView.h"
#import "Masonry.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,VideoTableCellDelegate>
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [UITableView new];
    _tableView.rowHeight = 240;
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UINib * nib = [UINib nibWithNibName:@"VideoTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"indetifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"indetifier" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)didSelectVideoWithIndexPath:(NSIndexPath *)indexPath
{
    

    
     SSVideoPlayerView * videoPlayer = [SSVideoPlayerView shareSSVideoPlayerManager];
     
     UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
     
     
     [videoPlayer initViewWithTableView:self.tableView cell:cell indexPath:indexPath videoUrl:@"http://59.108.200.43/mp4files/B133000003BCF2E6/baobab.wdjcdn.com/14557771465491(9).mp4"];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 20;
}

@end
