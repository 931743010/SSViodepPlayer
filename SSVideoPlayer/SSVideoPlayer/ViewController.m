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
#import "VideoDataCenter.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,VideoTableCellDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)VideoDataCenter * dataCenter;
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
    
    self.dataCenter = [[VideoDataCenter alloc] init];
    [self.dataCenter requestVideoList:^(NSString *error) {
        
        [self.tableView reloadData];
    }];
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
    
    NSDictionary * dic = [self.dataCenter.videoListArray objectAtIndex:indexPath.row];
    
    NSString * url = [dic valueForKey:@"mp4_url"];
     [videoPlayer initViewWithTableView:self.tableView cell:cell indexPath:indexPath videoUrl:url];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataCenter.videoListArray.count;
}

@end
