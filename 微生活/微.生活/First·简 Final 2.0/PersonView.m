//
//  PersonView.m
//  First·简
//
//  Created by yearwen on 15/6/17.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "PersonView.h"
#import "PersonDetailModel.h"
#import "PersonModel.h"
#import "PersonListCell.h"
#import "RadioPlayerView.h"
@interface PersonView ()
{
    PersonDetailModel * _model;
}
@end

@implementation PersonView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [[NSMutableArray alloc]init];
    [self creatTableView];
    self.currentPage = 0;
    [self.tableView setRowHeight:80];
    [self creatHttpRequest];
    
}

-(void)creatHttpRequest{
        NSDictionary * dict = @{@"radioid":self.redioid,@"start":@(self.currentPage),@"client":@(2),@"limit":@(10)};
    [_manager POST:kRedioDetail_POSTURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *data = dict[@"data"];
            NSDictionary * radioinfo = data[@"radioInfo"];
            _model = [[PersonDetailModel alloc]init];
            _model.coveimg = radioinfo[@"coverimg"];
            _model.desc = radioinfo[@"desc"];
            _model.musicvisitnum = [radioinfo[@"musicvisitnum"] stringValue];
            _model.title = radioinfo[@"title"];
            _model.uname = [radioinfo[@"userinfo"] valueForKey:@"uname"];
            _model.icon =[radioinfo[@"userinfo"] valueForKey:@"icon"];
            NSArray * list = data[@"list"];
            
            for (NSDictionary * soundinfo in list) {
                PersonModel * model = [[PersonModel alloc]init];
                model.coverimg = soundinfo[@"coverimg"];
                model.musicVisit = soundinfo[@"musicVisit"];
                model.musicUrl = soundinfo[@"musicUrl"];
                model.title = [soundinfo[@"playInfo"] valueForKey:@"title"];
                model.uname = _model.uname;
                model.icon =_model.icon;
                model.webview_url = [soundinfo[@"playInfo"] valueForKey:@"webview_url"];
                [self.dataArr addObject:model];
            }
            
        }
        [self.tableView reloadData];
        [self creatHeadView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonListCell*cell = [tableView dequeueReusableCellWithIdentifier:@"PersonListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonListCell" owner:self options:nil]lastObject];
    }
    PersonModel * model = self.dataArr[indexPath.row];

    [cell showDataWithModel:model];
    cell.backgroundColor =[UIColor colorWithRed:220/255.0 green:231/255.0 blue:219/255.0 alpha:1.0];
    
    return  cell;
}


-(void)creatHeadView{
    UIImageView *heard = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 200)];
    [heard sd_setImageWithURL:[NSURL URLWithString:_model.coveimg] placeholderImage:[UIImage imageNamed: @"3"]];
    UIView * view  = [[UIView alloc]initWithFrame:CGRectMake(0, 140, kScreenSize.width, 60)];
    view.backgroundColor =[ UIColor blackColor];
    view.alpha = 0.8;
    UIImageView * icon  = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
    [icon sd_setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:[UIImage imageNamed: @"about"]];
    icon.layer.masksToBounds =YES;
    icon.layer.cornerRadius = 9;
    [view addSubview:icon];
    UILabel * label  =[[UILabel alloc]initWithFrame:CGRectMake(30, 10, 200, 20)];
    label.text = _model.uname;
    label.textColor = [UIColor  whiteColor];
    label.font =[UIFont fontWithName:@"Yuppy SC" size:14];
    [view addSubview:label];
    UILabel * label1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 30, kScreenSize.width-20, 30)];
    label1.text =_model.desc;
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 setNumberOfLines:0];
    label1.font = [UIFont fontWithName:@"Yuppy SC" size:12];
    [view addSubview:label1];
    [heard addSubview:view];
    
    [self.tableView setTableHeaderView:heard];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonModel * model = self.dataArr[indexPath.row];
    RadioPlayerView * rpView = [[RadioPlayerView alloc]init];
    rpView.model = model;

    //[self.navigationController pushViewController:rpView animated:YES];
    [self presentViewController:rpView animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
