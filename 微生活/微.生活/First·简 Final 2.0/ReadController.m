//
//  ReadController.m
//  First·简
//
//  Created by yearwen on 15-6-11.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "ReadController.h"
#import "RedioListModel.h"
#import "ReBaseModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIImageView+YearwenEventBlock.h"
#import "ReadViewController.h"
#import "ReadBaseController.h"
#import "ContainerViewController.h"


@interface ReadController ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@property(nonatomic,copy)NSMutableArray * dataArr;
@property(nonatomic,copy)NSMutableArray * dataArr1;

@end

@implementation ReadController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    _manage = [AFHTTPRequestOperationManager manager];
    //响应格式 二进制 不解析
    _manage.responseSerializer  = [AFHTTPResponseSerializer serializer];
    [self creatHttpDownLoadData];
    [self creatHttp];

   }

#pragma mark  - 九宫格视图
-(void)creatTableImage{
    CGFloat space = 5.0;
    CGFloat h = (kScreenSize.width-4*space)/3;
    for (NSInteger i = 0; i<9; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 101+i;
        btn.adjustsImageWhenHighlighted = NO;
        RedioListModel * model = self.dataArr[i];
        [btn sd_setImageWithURL:[NSURL URLWithString:model.coverimg] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(space+(i%3)*(space+h),184+space+(i/3)*(space+h) , h, h)];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, h-18, h, 18)];
        label.backgroundColor = [UIColor clearColor];
        NSString * str =[NSString stringWithFormat:@" %@ * %@",model.name,model.enname];
        label.text = str;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
       // label.font = [UIFont fontWithName:@"Yuppy SC" size:11];
        label.font = [UIFont boldSystemFontOfSize:12];
        UIView * view = [[UIView alloc]initWithFrame:label.frame];
        view.backgroundColor = [UIColor grayColor];
        view.alpha = 0.9;
        [btn addSubview:view];
        [btn addSubview:label];
        [self.view addSubview:btn];
    }
    CGFloat  m = 184+4*space+3*h;
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 110;
    [btn1 setFrame:CGRectMake(0, 0,kScreenSize.width-2*space, kScreenSize.height-2*space-m)];
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * botimg = [[UIImageView alloc]initWithFrame:CGRectMake(space, m, kScreenSize.width-2*space, kScreenSize.height-space-m)];
    botimg.backgroundColor = [UIColor whiteColor];
    [botimg addClickEventWithBlock:^(UIImageView *imageView) {
        [self creatNewView];
    }];
    botimg.image = [UIImage imageNamed: @"bomimg"];
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0,  kScreenSize.height-space-m-18, kScreenSize.width-2*space,18)];
    label1.text = @"  24 小时写作·New Writing.";
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont fontWithName:@"Yuppy SC" size:12];
    UIView * view = [[UIView alloc]initWithFrame:label1.frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha =0.7;
    [btn1 addSubview:view];
    [btn1 addSubview:label1];
    [botimg addSubview:btn1];
    [self.view addSubview:botimg];
}


-(void)creatPageViewWithTag:(NSInteger)tag{
    NSArray * arr1 = @[@"LastViewController",@"HotViewController"];
    NSArray * title = @[@"最新",@"最热"];
    NSArray * chinnal = @[kLastTime,kHotList];
    NSMutableArray * vcArr = [[NSMutableArray alloc]init];
     RedioListModel *model =self.dataArr[tag-101];
    for (NSInteger i = 0; i < arr1.count; i++) {
        Class cls = NSClassFromString(arr1[i]);
        ReadBaseController * rbc = [[cls alloc]init];
        rbc.type = model.type;
        rbc.chinnal = chinnal[i];
        rbc.title = title[i];
          //  rbc.specilType = kReadLastTimeList;
            rbc.specilType = kReadList_PostType;
        [vcArr addObject:rbc];
    }
    ContainerViewController * cvc = [[ContainerViewController alloc]init];
    cvc.title =model.name;
    cvc.viewControllers = vcArr;
    [self animationView];
    [self.navigationController pushViewController:cvc animated:YES];
   // [self presentViewController:cvc animated:YES completion:nil];
}


-(void)creatNewView{
    NSArray * arr1 = @[@"LastViewController",@"HotViewController"];
    NSArray * title = @[@"最新",@"最热"];
    NSArray * chinnal = @[kLastTime,kHotList];
    NSMutableArray * vcArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<arr1.count; i++) {
        Class cls = NSClassFromString(arr1[i]);
        ReadBaseController * rbc = [[cls alloc]init];
        rbc.chinnal = chinnal[i];
        rbc.title = title[i];
        rbc.type = @"1";
        //  rbc.specilType = kReadLastTimeList;
        rbc.specilType = kReadList_PostType;
        [vcArr addObject:rbc];
    }
    ContainerViewController * cvc = [[ContainerViewController alloc]init];
    cvc.viewControllers = vcArr;
    [self.navigationController pushViewController:cvc animated:YES];
}


-(void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 101:
        {
            
            [self creatPageViewWithTag:btn.tag];
        }
            break;
        case 102:
        {
             [self creatPageViewWithTag:btn.tag];
        }
            break;
        case 103:
        {
              [self creatPageViewWithTag:btn.tag];
        }
            break;
        case 104:
        {
              [self creatPageViewWithTag:btn.tag];
        }
            break;
        case 105:
        {
              [self creatPageViewWithTag:btn.tag];
        }
            break;
        case 106:
        {
              [self creatPageViewWithTag:btn.tag];
        }
            break;
        case 107:
        {
              [self creatPageViewWithTag:btn.tag];
        }
            break;
        case 108:
        {
             [self creatPageViewWithTag:btn.tag];
        }
            break;
        case 109:
        {
              [self creatPageViewWithTag:btn.tag];
        }
            break;
        case 110:
        {
            [self creatNewView];
        }
            break;
        default:
            break;
    }
}

-(void)creatTableView{
}
#pragma mark  - 下载填充九宫格视图
-(void)creatHttpDownLoadData{
    self.dataArr = [[NSMutableArray alloc]init];
        __weak typeof(self) weakSelf = self;
        [_manage GET:kReadList_URL parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary * data = dict[@"data"];
                    for (NSDictionary * type in data[@"list"]) {
                        RedioListModel *model  = [[RedioListModel alloc]init];
                        model.type = type[@"type"];
                        model.name = type[@"name"];
                        model.coverimg = type[@"coverimg"];
                        model.enname = type[@"enname"];
                        [weakSelf.dataArr addObject:model];
                    }
                }
                  [weakSelf creatTableImage];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf showErrorAlerat];
            }];
}

#pragma mark  - 创建顶部滚动视图
-(void)creatHttp{
    self.ScrDataArr = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    [_manage GET:kReadList_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        ReadViewController *rvc = [[ReadViewController alloc]init];
        rvc.webViewUrl = model.url;
        
        [weakSelf.navigationController pushViewController:rvc animated:YES];
        //[self presentViewController:rvc animated:YES completion:nil];
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
    [self.view addSubview:_scrollView];
    //页码器
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 194-30, kScreenSize.width, 20)];
    _pageControl.numberOfPages = self.ScrDataArr.count;
    
    [_pageControl addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
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

@end
