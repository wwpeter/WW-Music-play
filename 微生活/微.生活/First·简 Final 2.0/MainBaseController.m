//
//  MainBaseController.m
//  First·简
//
//  Created by yearwen on 15-6-11.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "MainBaseController.h"
#import "AudioPlayer.h"
extern AudioPlayer * _audioPlayer;

@interface MainBaseController ()

@end

@implementation MainBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.view.backgroundColor = [UIColor blueColor];
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:231/255.0 blue:219/255.0 alpha:1.0];
    //创建af
    _manager = [AFHTTPRequestOperationManager manager];
    //响应格式 二进制 不解析
    _manager.responseSerializer  = [AFHTTPResponseSerializer serializer];

    [self creatTableView];
    [self lockScreenEvent];
}

-(void)lockScreenEvent{
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    (void*)self, // observer (can be NULL)
                                    lockStateChanged, // callback
                                    CFSTR("com.apple.springboard.lockstate"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
}

static void lockStateChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if (_audioPlayer) {
        [_audioPlayer play];
    }
    return;
}


-(void)creatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
    self.dataArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self.view addSubview:self.tableView];
}
#pragma mark  - 实现tableView协议的方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
}

-(void)showErrorAlerat{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"下载错误,请检查网络设置." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)animationView{
    //return;
    CATransition *anima = [CATransition animation];
    [anima setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    anima.duration = 0.5;
    anima.type = @"rotate";
    
    anima.subtype = @"45ccw";
    [self.navigationController.view.layer addAnimation:anima forKey:nil];
}


#pragma mark - 如果不满足子类 那么子类要重写
//第一次下载
- (void)firstDownload{

}
//增加下载任务
- (void)addTaskUrl:(NSString *)url isRefresh:(BOOL)isRefresh{

}

//刷新
- (void)creatRefreshView{
}
//结束刷新
- (void)endRefreshing{
}
    

@end
