//
//  ReadBaseController.m
//  First·简
//
//  Created by qianfeng01 on 15-6-13.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "ReadBaseController.h"
#import "ReadListCell.h"
#import "JHRefresh.h"
#import "ReadDetailView.h"
@interface ReadBaseController ()

@end

@implementation ReadBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    self.isRefreshing  = NO;
    self.isLoadMoring =NO;
    self.currentPage = 0;
    [self creatRefreshView];
   // [self.tableView registerNib:[UINib nibWithNibName:@"ReadListCell" bundle:nil] forCellReuseIdentifier:@"ReadListCell"];
    [self creatPostRequest];
    }

-(void)creatPostRequest{
    NSDictionary * dict = @{@"sort" : self.chinnal,@"start" : @(self.currentPage),@"client" : @(2),@"typeid" : self.type,@"limit" : @(10)};
    NSString * url  =[NSString stringWithFormat:kReadDetail_PostURL,self.specilType];
    __weak typeof(self) weakSelf = self;
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (weakSelf.currentPage ==0) {
            [weakSelf.dataArr removeAllObjects];
            
        }
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * data = dict[@"data"];
            NSArray * list = data[@"list"];
            for (NSDictionary *dict1 in list) {
                ReadDetailModel *model = [[ReadDetailModel alloc]init];
                model.content = dict1[@"content"];
                model.coverimg = dict1[@"coverimg"];
                model.title = dict1[@"title"];
                model.name = dict1[@"name"];
                model.id = dict1[@"id"];
                [weakSelf.dataArr addObject:model];
            }
        }
        [self.tableView reloadData];
           [weakSelf endRefreshing];
        weakSelf.isRefreshing = NO;
        weakSelf.isLoadMoring = NO;
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf endRefreshing];
        weakSelf.isRefreshing = NO;
        weakSelf.isLoadMoring = NO;
       // [weakSelf showErrorAlerat];
    }];
}

-(void)creatRefreshView{
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 0;
        [weakSelf creatPostRequest];
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        if (weakSelf.isLoadMoring) {
            return ;
        }
        weakSelf.isLoadMoring = YES;
        weakSelf.currentPage +=10;
        [weakSelf creatPostRequest];
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



-(void)creatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-99)];
    self.dataArr = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setRowHeight:140];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReadListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ReadListCell" owner:self options:nil]lastObject];
    }
    ReadDetailModel * model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    cell.backgroundColor =[UIColor colorWithRed:220/255.0 green:231/255.0 blue:219/255.0 alpha:1.0];
    
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadDetailModel * model = self.dataArr[indexPath.row];
    ReadDetailView * rdV  =[[ReadDetailView alloc]init];
       rdV.webViewUrl = model.id;
    
        CATransition *anima = [CATransition animation];
        [anima setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        anima.duration = 1;
        anima.type = @"rotate";
    
    anima.subtype = @"90ccw";
        [self.view.layer addAnimation:anima forKey:nil];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController]  presentViewController:rdV animated:YES completion:nil ];

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
