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
#import "MJRefresh.h"
#import "UIKit+AFNetworking.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,VideoTableCellDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSourceMutableArray;
@property(nonatomic,strong)VideoDataCenter * dataCenter;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,assign)BOOL isRefreshing;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [UITableView new];
    _tableView.rowHeight = 240;
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    self.dataSourceMutableArray = [NSMutableArray array];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UINib * nib = [UINib nibWithNibName:@"VideoTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"indetifier"];
    
    self.dataCenter = [[VideoDataCenter alloc] init];
   
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isRefreshing) {
          
            return ;
        }
        [weakSelf.dataCenter requestVideoList:^(NSString *error) {
           
            [weakSelf.dataSourceMutableArray removeAllObjects];
            [weakSelf.dataSourceMutableArray addObjectsFromArray:weakSelf.dataCenter.videoListArray];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            
        }];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        if (weakSelf.isRefreshing) {
            return ;
        }
        
        [weakSelf.dataCenter requestVideoList:^(NSString *error) {
            
            [weakSelf.dataSourceMutableArray addObjectsFromArray:weakSelf.dataCenter.videoListArray];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        }];
        
    }];
     [self.tableView.mj_header beginRefreshing];
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
    NSDictionary * dic = [self.dataSourceMutableArray objectAtIndex:indexPath.row];
    NSString * url = [dic valueForKey:@"cover"];
    cell.descLabel.text = [dic valueForKey:@"title"];
    cell.descLabel.textColor = [UIColor blackColor];
    [cell.VideoImageView setImageWithURL:[NSURL URLWithString:url]];
    
    
    return cell;
}

-(void)didSelectVideoWithIndexPath:(NSIndexPath *)indexPath
{
    

    
     SSVideoPlayerView * videoPlayer = [SSVideoPlayerView shareSSVideoPlayerManager];
     
     UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary * dic = [self.dataSourceMutableArray objectAtIndex:indexPath.row];
    
    NSString * url = [dic valueForKey:@"mp4_url"];
     [videoPlayer initViewWithTableView:self.tableView cell:cell indexPath:indexPath videoUrl:url];

    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSourceMutableArray.count;
}

@end
