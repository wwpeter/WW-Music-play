//
//  PiceViewController.m
//  First·简
//
//  Created by yearwen on 15-6-11.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "PiceViewController.h"
#import "ChipFellingsModels.h"
#import "ChipFellingsCell.h"
#import "JHRefresh.h"
@interface PiceViewController ()
{
    NSTimeInterval _time;
}
@end

@implementation PiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate * date = [NSDate date] ;
    _time  =(long)[date timeIntervalSince1970] ;
    self.dataArr = [[NSMutableArray alloc]init];
    [self creatHttpRequest];
    self.isRefreshing  = NO;
    self.isLoadMoring =NO;
    self.currentPage = 0;
    [self creatRefreshView];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)creatHttpRequest{
    __weak typeof(self) weakSelf  =self;
    NSString * url  =[NSString stringWithFormat:kChipFellings,self.currentPage,(long)_time];
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (self.currentPage ==0) {
                [self.dataArr removeAllObjects];
            }
            NSDictionary * dict  = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *data = dict[@"data"];
            NSArray * list = data[@"list"];
            for (NSDictionary *content in list) {
                ChipFellingsModels * model = [[ChipFellingsModels alloc]init];
                model.uname = [content[@"userinfo"] valueForKey:@"uname"];
                model.icon =[content[@"userinfo"] valueForKey:@"icon"];
                model.addtime_f = content[@"addtime_f"];
                model.content = content[@"content"];
                model.coverimg = content[@"coverimg"];
                model.coverimg_wh = content[@"coverimg_wh"];
                [weakSelf.dataArr addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf endRefreshing];
        weakSelf.isRefreshing = NO;
        weakSelf.isLoadMoring = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.isLoadMoring ==YES&self.currentPage>10) {
            self.currentPage -=10;
        }
        [weakSelf endRefreshing];
        weakSelf.isRefreshing = NO;
        weakSelf.isLoadMoring = NO;
        [weakSelf showErrorAlerat];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChipFellingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChipFellingsCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChipFellingsCell" owner:self options:nil] lastObject];
    }
    ChipFellingsModels * model = self.dataArr[indexPath.row];
    [cell shwoDataWithModel:model];
    cell.backgroundColor = [UIColor colorWithRed:220/255.0 green:231/255.0 blue:219/255.0 alpha:1.0];
    return cell;
}






-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        ChipFellingsModels * model = self.dataArr[indexPath.row];
    CGFloat Height = 57;
    if (model.coverimg_wh.length>0) {
        NSArray * wh = [model.coverimg_wh componentsSeparatedByString:@"*"];
        CGFloat with = [wh[0] doubleValue];
        CGFloat height = [wh[1] doubleValue];
        CGFloat imageH =(kScreenSize.width-20)*height/with;
        Height +=imageH;
    }
    Height += [LZXHelper textHeightFromTextString:model.content width:kScreenSize.width-20 fontSize:17]+10;
    return Height+30;
}


-(void)creatRefreshView{
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 0;
        NSDate *date = [NSDate date];
        _time = (long)[date timeIntervalSince1970];
        [weakSelf creatHttpRequest];
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        if (weakSelf.isLoadMoring) {
            return ;
        }
        weakSelf.isLoadMoring = YES;
        NSDate * date = [NSDate date] ;
        NSTimeInterval  time  =(long)[date timeIntervalSince1970] ;
        _time -= (time-_time);
        weakSelf.currentPage +=10;
        [weakSelf creatHttpRequest];
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
