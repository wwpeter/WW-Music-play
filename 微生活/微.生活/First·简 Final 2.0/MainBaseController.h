//
//  MainBaseController.h
//  First·简
//
//  Created by yearwen on 15-6-11.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

@interface MainBaseController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableArray * _dataArr;
    
    NSInteger _currentPage;
    BOOL _isRefreshing;
    BOOL _isLoadMoring;
    
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic)NSInteger currentPage;
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isLoadMoring;

#pragma mark - 如果不满足子类 那么子类要重写
-(void)creatTableView;
//第一次下载
- (void)firstDownload;
//增加下载任务
- (void)addTaskUrl:(NSString *)url isRefresh:(BOOL)isRefresh;

//刷新
- (void)creatRefreshView;
//结束刷新
- (void)endRefreshing;
-(void)showErrorAlerat;
-(void)lockScreenEvent;
-(void)animationView;
@end
