//
//  LeftController.m
//  First·简
//
//  Created by yearwen on 15-6-11.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "LeftController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MainBaseController.h"
#import "DDMenuController.h"
#import "PersonModel.h"
#import "AudioPlayer.h"
extern AudioPlayer * _audioPlayer;

@interface LeftController ()<UITableViewDelegate,UITableViewDataSource>
{
AFHTTPRequestOperationManager *_manager;
    NSMutableArray * _title ;
    UIView * _view;
    BOOL  _isPlaying;
    UIImageView * _image;
    UILabel * _label;
    NSString * url;
    UIButton * _button;
}
@end

@implementation LeftController
@synthesize controlView  = _controlView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //创建af
    _manager = [AFHTTPRequestOperationManager manager];
    //响应格式 二进制 不解析
    _manager.responseSerializer  = [AFHTTPResponseSerializer serializer];
    _title =[NSMutableArray arrayWithArray:@[@"微·阅读",@"微·电台",@"微·碎片",@"微·音乐",@"设置"]];
    [self creatItems];
    [self changeUIValue];
}

-(void)changeUIValue{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerControl:) name:kChangeUIValue object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerControl:) name:@"change" object:nil];
}

-(void)playerControl:(NSNotification* )nf{
    if (_label) {
        [_label removeFromSuperview];
        [_image removeFromSuperview];
        [_button removeFromSuperview];
    }
    NSDictionary *user = nf.userInfo;
    NSLog(@"%@",user);/*{
                       coverimg = "http://echo-image.qiniucdn.com/FmX4ZNg6VhmjmTzT6iE5c0updAPj?imageView2/4/w/500";
                       musicUrl = "http://7fvgtj.com2.z0.glb.qiniucdn.com/9388bb18d48ccae3ad0236fff19075f30248d781";
                       playing = 0;
                       title = "\U6e05\U65b0\U6c11\U8c23\U98ce Skin & Bones";
                       }*/
    
    NSString *title  = [user valueForKey:@"title"];
    NSString *coverimg = [user valueForKey:@"coverimg"];
    _isPlaying = [user valueForKey:@"playing"];
    url = user[@"musicUrl"];
    if (title) {
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenSize.height-60, kScreenSize.width, 60)];
        _view.backgroundColor = [UIColor clearColor];
    // view.backgroundColor  =  [UIColor colorWithRed:105/255.0 green:127/255.0 blue:156/255.0 alpha:1];
   _image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    _image.layer.masksToBounds = YES;
    _image.layer.cornerRadius = 5;
    [_image sd_setImageWithURL:[NSURL URLWithString:coverimg] placeholderImage:[UIImage imageNamed:@"3"]];
        _label  = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, kScreenSize.width/2-60, 40)];
        _label.text = title;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont fontWithName:@"Yuppy SC" size:14];
        [_view addSubview:_label];
        [_view addSubview:_image];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(kScreenSize.width/2+30, 15, 30, 30);
        if (_isPlaying ==YES) {
             [_button setImage:[UIImage imageNamed:@"radarStop"] forState:UIControlStateNormal];
        }else{
        [_button setImage:[UIImage imageNamed:@"img"] forState:UIControlStateNormal];
        }
        [_button addTarget:self action:@selector(playerClick:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:_button];
        
        [self.view addSubview:_view];

    }else{
        return;
    }
}
-(void)playerClick:(UIButton *)btn{
    if (_audioPlayer) {
    if (_isPlaying ==YES) {
        [_audioPlayer pause];
           [btn setImage:[UIImage imageNamed:@"radarPlay"] forState:UIControlStateNormal];
        _isPlaying = NO;
    }else{
   [self justPlay];
      [btn setImage:[UIImage imageNamed:@"radarStop"] forState:UIControlStateNormal];
        _isPlaying = YES;
    }
    }else {
        [self creatStreamer];
        [self justPlay];
        //_isPlaying = NO;
    }
}
-(void)justPlay{
    UIBackgroundTaskIdentifier bgTask = 0;
    if([UIApplication sharedApplication].applicationState== UIApplicationStateBackground) {
        
        [_audioPlayer play];
        
        UIApplication *app = [UIApplication sharedApplication];
        
        UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
        
        if(bgTask!= UIBackgroundTaskInvalid) {
            
            [app endBackgroundTask: bgTask];
        }
        bgTask = newTask;
    }
    
    else {
          [_audioPlayer play];
    }

}
-(void)creatStreamer{
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    _audioPlayer.url = [NSURL URLWithString:url];
}

- (void)destroyStreamer
{
    if (_audioPlayer)
    {
        [_audioPlayer  stop];
        _audioPlayer = nil;
    }
}

-(void)creatItems{

    UIImageView * backGround= [[UIImageView alloc]initWithFrame:CGRectMake(0,0,kScreenSize.width,kScreenSize.height)];
 /*
    [_manager GET:kDefaultScreen_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * data = dict[@"data"];
            [backGround sd_setImageWithURL:[NSURL URLWithString:data[@"picurl"]] placeholderImage:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
   */
    backGround.image = [UIImage imageNamed: @"life1"];
    backGround.alpha = 1;
    [self.view addSubview:backGround];
    UIImageView * logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 70, 200, 90)];
    logoImage.backgroundColor = [UIColor clearColor];
    //logoImage.image = [UIImage imageNamed: @"2"];
    [self.view addSubview:logoImage];
    
    if (!self.controlView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenSize.height*1/3, kScreenSize.width, kScreenSize.height-kScreenSize.height*2/3+10) style:UITableViewStylePlain];
        //tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = self;
        
        
        
        tableView.dataSource =self;
        [self.view addSubview:tableView];
        tableView.bounces = NO;
        [tableView setRowHeight:40];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        [tableView setTintColor:[UIColor whiteColor]];
        self.controlView = tableView;

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _title.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * image = @[@"feed2",@"channel2",@"mine2",@"echo2",@"setting"];
    static NSString *Cell = @"Cell";
    UITableViewCell  *cell  = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
    }
    UIImageView * image1 =[[UIImageView alloc]initWithFrame:CGRectMake(40, 15, 20, 20)];
    image1.image = [UIImage imageNamed:image[indexPath.row]];
   
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 100, 20)];
    label1.text = _title[indexPath.row];
    label1.font = [UIFont fontWithName:@"Yuppy SC" size:17];
    label1.textColor = [UIColor blackColor];
    [cell addSubview:image1];
    [cell addSubview:label1];   
    //cell.textLabel.text = _title[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * type = @[@"ReadController",@"RedioController",@"PiceViewController",@"MusicViewController",@"SettingViewController"];
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    Class cls = NSClassFromString(type[indexPath.row]);
    MainBaseController *mainController = [[cls alloc]init];
    mainController.title = _title[indexPath.row];
   // mainController.navigat
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:mainController];
    [menuController setRootController:nav animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


@end
