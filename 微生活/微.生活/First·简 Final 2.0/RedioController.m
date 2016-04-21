//
//  RedioController.m
//  First·简
//
//  Created by yearwen on 15-6-11.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "RedioController.h"
#import "ReBaseModel.h"
#import "UIImageView+YearwenEventBlock.h"
#import "ReadViewController.h"
#import "RedioModel.h"
#import "RadioListCell.h"
#import "JHRefresh.h"
#import "PersonView.h"
@interface RedioController () {
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@end

@implementation RedioController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manage = [AFHTTPRequestOperationManager manager];
    //响应格式 二进制 不解析
    _manage.responseSerializer  = [AFHTTPResponseSerializer serializer];
    [self creatTableView];
    [self.tableView setRowHeight:100];
    self.dataArr  = [[NSMutableArray alloc]init];
    [self creatHttpRequest];
    [self creatRefreshView];
    self.currentPage = 0;
    [self creatHttp];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)creatHttpRequest{
    NSString * url = @"";
    if (self.currentPage==0) {
        url =kRedioRefresh_URL;
    }
    __weak typeof(self) weakSelf = self;
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (self.currentPage==0) {
                [self.dataArr removeAllObjects];
            }
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *data = dict[@"data"];
            NSArray *alllist = [[NSArray alloc]init];
            if (self.currentPage==0) {
                 alllist = data[@"alllist"];
            }else{
                 alllist = data[@"list"];
            }
            for (NSDictionary * sounds in alllist) {

                RedioModel * model = [[RedioModel alloc]init];
                model.title = sounds[@"title"];
                model.coverimg = sounds[@"coverimg"];
                model.count = sounds[@"count"];
                model.desc = sounds[@"desc"];
                model.radioid = sounds[@"radioid"];
                model.uname = [sounds[@"userinfo"] valueForKey:@"uname"];
                [weakSelf.dataArr addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf endRefreshing];
        weakSelf.isRefreshing = NO;
        weakSelf.isLoadMoring =NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
  
        [weakSelf endRefreshing];
        weakSelf.isRefreshing = NO;
        weakSelf.isLoadMoring =NO;
          [weakSelf showErrorAlerat];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)creatPostRequest{
    NSDictionary * postBody = @{@"start":@(self.currentPage),@"client":@"2",@"limit":@"9"};
    __weak typeof(self) weakSelf = self;
    [_manage POST:kRedioMorePost_URL parameters:postBody success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (self.currentPage==0) {
                [self.dataArr removeAllObjects];
            }
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *data = dict[@"data"];
            NSArray *alllist = [[NSArray alloc]init];
            if (self.currentPage==0) {
                alllist = data[@"alllist"];
            }else{
                alllist = data[@"list"];
            }
            for (NSDictionary * sounds in alllist) {
                
                RedioModel * model = [[RedioModel alloc]init];
                model.title = sounds[@"title"];
                model.coverimg = sounds[@"coverimg"];
                model.count = sounds[@"count"];
                model.desc = sounds[@"desc"];
                model.radioid = sounds[@"radioid"];
                model.uname = [sounds[@"userinfo"] valueForKey:@"uname"];
                [weakSelf.dataArr addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf endRefreshing];
        weakSelf.isRefreshing = NO;
        weakSelf.isLoadMoring =NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.currentPage>=9) {
            self.currentPage-=9;
        }
        
  
        [weakSelf endRefreshing];
        weakSelf.isRefreshing = NO;
        weakSelf.isLoadMoring =NO;
        [weakSelf showErrorAlerat];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RadioListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadioListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RadioListCell" owner:self options:nil]lastObject];
    }
    RedioModel * model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    cell.backgroundColor =[UIColor colorWithRed:220/255.0 green:231/255.0 blue:219/255.0 alpha:1.0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonView * view = [[PersonView alloc]init];
    RedioModel * model = self.dataArr[indexPath.row];
    view.redioid =model.radioid;
      [self animationView];
    [self.navigationController pushViewController:view animated:YES];
}


-(void)creatRefreshView{
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 0;
        [weakSelf creatHttpRequest];
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        if (weakSelf.isLoadMoring) {
            return ;
        }
        weakSelf.isLoadMoring = YES;
        weakSelf.currentPage +=9;
        NSLog(@"%ld",weakSelf.currentPage);
        NSLog(@"count:%ld",weakSelf.dataArr.count);
        [weakSelf creatPostRequest];
    }];
}


#pragma mark  - 创建顶部滚动视图
-(void)creatHttp{
    self.ScrDataArr = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    [_manage GET:kRedioRefresh_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * data = dict[@"data"];
            NSArray * arr = data[@"carousel"];
            for (NSDictionary * img in arr) {
                ReBaseModel *model = [[ReBaseModel alloc]init];
                model.img = img[@"img"];
                model.url = img[@"url"];
                [weakSelf.ScrDataArr addObject:model];
            }
        }
        [weakSelf creatView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)creatView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, 120)];
    for (int i = 0; i < self.ScrDataArr.count; i++) {
        ReBaseModel * model = self.ScrDataArr[i];
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width*i, 0, kScreenSize.width, 120)];
        __weak typeof(self) weakSelf = self;
        [imageView1 addClickEventWithBlock:^(UIImageView *imageView) {
            NSString * newUrl = [model.url substringToIndex:11];
            if ([newUrl isEqualToString:@"pianke://fm"]) {
                NSString * url = [model.url substringFromIndex:12];
                PersonView * view = [[PersonView alloc]init];
             
                view.redioid = url;
                [weakSelf.navigationController pushViewController:view animated:YES];
            }else if([newUrl isEqualToString:@"pianke://ar"]) {
            ReadViewController *rvc = [[ReadViewController alloc]init];
            rvc.webViewUrl = model.url;
            [weakSelf.navigationController pushViewController:rvc animated:YES];
            }else{
            
            }
        }];
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed: @"DETweetAttachmentFrame"]];
        _scrollView.bounces = NO;
    
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView addSubview:imageView1];
        
    }
    //下面设置滚动视图
    _scrollView.contentSize = CGSizeMake(self.ScrDataArr.count*kScreenSize.width, 121);
    _scrollView.showsVerticalScrollIndicator = NO;
    //按页
    
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.alwaysBounceVertical = NO;
    [self.tableView  setTableHeaderView:_scrollView];
    //页码器
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 101, kScreenSize.width, 20)];
    _pageControl.numberOfPages = self.ScrDataArr.count;
    
    [_pageControl addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_pageControl];
}
- (void)pageClick:(UIPageControl *)page {
    //修改滚动视图的偏移量
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*page.currentPage, 0) animated:YES];
}
//减速停止的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //修改页码
    CGPoint offset = _scrollView.contentOffset;
    _pageControl.currentPage = offset.x/_scrollView.bounds.size.width;
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
