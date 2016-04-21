//
//  MusicViewController.m
//  First·简
//
//  Created by yearwen on 15-6-11.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "MusicViewController.h"
#import "EchoModel.h"
#import "MusicDetailModel.h"
#import "MusicListCell.h"
#import "JHRefresh.h"
#import "MusicPlayerview.h"
@interface MusicViewController ()
{
    EchoModel * _model;

}
@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self creatHttpResuest];
    [self creatRefreshView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
-(void)creatTableView{
    self.currentPage = 1;
    self.isRefreshing = NO;
    self.isLoadMoring =NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
    self.dataArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.rowHeight =140;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}
-(void)creatHttpResuest{
      __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:kEchoHotChinnal,self.currentPage];
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (_currentPage==1) {
                [self.dataArr removeAllObjects];
                
            }
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * result = dict[@"result"];
            NSDictionary * data= result[@"data"];
            NSDictionary * channel = data[@"channel"];
             _model = [[EchoModel alloc]init];
            _model.name = channel[@"name"];
            _model.id = channel[@"id"];
            _model.pic_500 = channel[@"pic_500"];
            _model.sound_count = channel[@"sound_count"];
            _model.follow_count = channel[@"follow_count"];
            _model.info =channel[@"info"];
            
            [weakSelf creatHeadView];
            NSArray * sounds = data[@"sounds"];
            for (NSDictionary * music in sounds) {
                MusicDetailModel * model2 = [[MusicDetailModel alloc]init];
                model2.name = music[@"name"];
                model2.id = music[@"id"];
                model2.pic_500 = music[@"pic_500"];
                model2.userName = [music[@"user"] valueForKey:@"name"];
                [weakSelf.dataArr addObject:model2];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf endRefreshing];
        weakSelf.isLoadMoring = NO;
        weakSelf.isRefreshing = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [weakSelf showErrorAlerat];
    }];
    
}

-(void)creatHeadView{
    UIImageView * headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 180)];
    [headView sd_setImageWithURL:[NSURL URLWithString:_model.pic_500] placeholderImage:[UIImage imageNamed: @"3"]];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = _model.name;
    label.font = [UIFont fontWithName:@"Yuppy SC" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:label.frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    [headView addSubview:view];
    [headView addSubview:label];
    [self.tableView setTableHeaderView:headView];
}

#pragma mark - 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MusicListCell" owner:self options:nil] lastObject];
    }
    MusicDetailModel * model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicPlayerview * Mplay = [[MusicPlayerview alloc]init];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    MusicDetailModel *model = self.dataArr[indexPath.row];
    Mplay.musicId = model.id;
    for (MusicDetailModel *model1 in self.dataArr) {
        [arr addObject:model1.id];
    }
    Mplay.dataArr1 = [arr copy];
    Mplay.index = indexPath.row;
 //   [self.navigationController pushViewController:Mplay animated:YES];
    [self presentViewController:Mplay animated:YES completion:nil];

}




//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 40)];
//    UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
//    label.text =_model.info;
//    view.backgroundColor = [UIColor whiteColor];
//    label.textColor =[UIColor colorWithRed:112/255.0 green:104/255.0 blue:25/255.0 alpha:1];
//    [view addSubview:label];
//    
//    return view;
//}

-(void)creatRefreshView{
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 1;
        [weakSelf creatHttpResuest];
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        if (weakSelf.isLoadMoring) {
            return ;
        }
        weakSelf.isLoadMoring = YES;
        weakSelf.currentPage +=1;
        [weakSelf creatHttpResuest];
    }];
}

-(void)endRefreshing{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMoring) {
        self.isLoadMoring =NO;
        [self.tableView footerEndRefreshing];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
