//
//  MusicPlayerView.m
//  First·简
//
//  Created by yearwen on 15/6/21.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "MusicPlayerView.h"
#import "MusicModel.h"
#import "AudioPlayer.h"
#import "UMSocial.h"
extern AudioPlayer * _audioPlayer;
NSTimer * _timer;
@interface MusicPlayerview ()<UMSocialUIDelegate>
{
    MusicModel * _model;
    UIImageView *_backimg;
    UITextView * _TView;
    UILabel * _label;
    UILabel * _time1;
    UILabel * _time2;
    NSTimer * _timer;
    UISlider * _slider;
    BOOL _isPlaying;
}
@end

@implementation MusicPlayerview

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self creatHttpRequest];
    [self creatTimer];
    [self destroyStreamer];
  //  self.navigationController.navigationBarHidden =YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self creatSharedButton];
}

-(void)creatSharedButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenSize.width-60, 20, 40, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"iphone_nav_share@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sharedDataBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)sharedDataBtn{
    NSString * body  =[NSString stringWithFormat:@"分享音乐,分享快乐:%@",_model.source];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:kUMengKey shareText:body shareImage:nil shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatTimeline,UMShareToSms,UMShareToEmail] delegate:self];
}


-(void)creatTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerClick:) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
}

-(void)timerClick:(NSTimer *)timer{
    NSInteger a = (NSInteger)_audioPlayer.progress/60;
    NSInteger b =(NSInteger)_audioPlayer.progress%60;
    _time1.text = [NSString stringWithFormat:@"%.2ld:%.2ld",a,b];
    
    NSInteger c =(NSInteger)_audioPlayer.duration/60;
    NSInteger d = (NSInteger)_audioPlayer.duration%60;
    _time2.text = [NSString stringWithFormat:@"%.2ld:%.2ld",c,d];
    _slider.value = _audioPlayer.progress/_audioPlayer.duration;
}


-(void)creatTableView{
}

-(void)creatHttpRequest{
  //  [self destroyStreamer];
    NSString * url = [NSString stringWithFormat:kEchoDetail,self.dataArr1[self.index]];
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result =dict[@"result"];
             _model = [[MusicModel alloc]init];
            _model.name = result[@"name"];
            _model.pic_500 =result[@"pic_500"];
            _model.info = result[@"info"];
            _model.source = result[@"source"];
        }
     [self creatUIView];
           [self creatStreamer];
        _isPlaying = YES;
           [_audioPlayer play];
            [_timer setFireDate:[NSDate distantPast]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
}

-(void)creatUIView{
    if(_time1) {
        [_backimg removeFromSuperview];
        [_time1 removeFromSuperview];
        [_time2 removeFromSuperview];
        [_label removeFromSuperview];
        [_TView  removeFromSuperview];
        [_slider removeFromSuperview];
        
    }
    _backimg = [[UIImageView alloc]initWithFrame:self.view.bounds];

    [_backimg sd_setImageWithURL:[NSURL URLWithString:_model.pic_500] placeholderImage:[UIImage imageNamed:@"3"]];
    _backimg.alpha = 0.3;
    
    _label =[[UILabel alloc]initWithFrame:CGRectMake(30, 70, kScreenSize.width-60, 30)];
    _label.text = _model.name;
    _label.font = [UIFont fontWithName:@"Yuppy SC" size:16];
    _label.textAlignment = NSTextAlignmentCenter;
     _TView =[[UITextView alloc]initWithFrame:CGRectMake(10, 120, kScreenSize.width-20, kScreenSize.height-280)];
    _TView.text = _model.info;
    _TView.backgroundColor = [UIColor clearColor];
    _TView.font = [UIFont fontWithName:@"Yuppy SC" size:14];
    _TView.textAlignment = NSTextAlignmentCenter;
    [_TView setEditable:NO];
    
    _time1 = [[UILabel alloc]initWithFrame:CGRectMake(5,  kScreenSize.height-160, 55, 30)];
    _time2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-60, kScreenSize.height-160, 55, 30)];
    _time1.text = @"00:00";
    _time2.text = @"00:00";
    _time1.font = [UIFont fontWithName:@"Yuppy SC" size:14];
    _time2.font = [UIFont fontWithName:@"Yuppy SC" size:14];
    _time1.textAlignment = NSTextAlignmentCenter;
    _time2.textAlignment = NSTextAlignmentCenter;
    
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(60, kScreenSize.height-160, kScreenSize.width-120, 30)];
    _slider.minimumValue = 0;
    _slider.maximumValue = 1.0;
    _slider.value = 0.0;
    UIImage * ima =  [UIImage imageNamed:@"playBar_play@2x"];
    [_slider setThumbImage:ima forState:UIControlStateNormal];
    [_slider setThumbImage:ima forState:UIControlStateHighlighted];
    
     [_slider addTarget:self action:@selector(SliderClick) forControlEvents:UIControlEventValueChanged];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(kScreenSize.width/2-100, kScreenSize.height-130, 40, 40);
    [button1 setImage:[UIImage imageNamed:@"back22.png"] forState:UIControlStateNormal];
    button1.tag = 101;
    [button1 addTarget:self action:@selector(benClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(kScreenSize.width/2-15, kScreenSize.height-130, 40, 40);
    [button2 setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    button2.tag = 102;
    [button2 addTarget:self action:@selector(benClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(kScreenSize.width/2+90, kScreenSize.height-130, 40, 40);
    [button3 setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    button3.tag = 103;
    [button3 addTarget:self action:@selector(benClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton * button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(kScreenSize.width/2-15, kScreenSize.height-70, 40, 40);
    [button4 setImage:[UIImage imageNamed:@"stop1.png"] forState:UIControlStateNormal];
    button4.tag = 104;
    [button4 addTarget:self action:@selector(benClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame  = CGRectMake(20, 20, 50, 50);
    [btn2 setImage:[UIImage imageNamed: @"misc_stop_iphone"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_backimg];
    [self.view addSubview:_label];
    [self.view addSubview:_TView];
    [self.view addSubview:_time1];
    [self.view addSubview:_time2];
    [self.view addSubview:_slider];
    [self.view addSubview:btn2];
}


-(void)backClick{
    
    [_timer invalidate];
    _timer = nil;
    // [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)benClick:(UIButton *)btn{
    switch (btn.tag) {
        case 101:
        {
                [self destroyStreamer];
            if (self.index==0) {
                self.index = self.dataArr1.count-1;
                [self creatHttpRequest];
        //        [self creatStreamer];
              //  [_streamer start];
            }else{
            self.index -=1;
            [self creatHttpRequest];
        //        [self creatStreamer];
             
            }
            
            [_timer setFireDate:[NSDate distantPast]];
        }
            break;
        case 102:
        {
            if (_audioPlayer) {
            if (_isPlaying ==NO) {
                [_audioPlayer   play];
                 [_timer setFireDate:[NSDate distantPast]];
                _isPlaying = YES;
            }
            }else{
                   [self creatHttpRequest];
                [_audioPlayer play];
                [_timer setFireDate:[NSDate distantPast]];
                _isPlaying = YES;
            }
        }
            break;
        case 103:
        {
     
                [self destroyStreamer];
            if (self.index ==self.dataArr1.count-1) {
                self.index =0;
                [self creatHttpRequest];
        //        [self creatStreamer];
        //        [_streamer start];
            }else{
                self.index +=1;
                [self creatHttpRequest];
       //         [self creatStreamer];
           //     [_streamer start];
            }
               [_audioPlayer   play];
            [_timer setFireDate:[NSDate distantPast]];
        }
            break;
        case 104:
        {
            if (_isPlaying ==YES) {
                [_audioPlayer pause];
                _isPlaying =NO;
                [_timer setFireDate:[NSDate distantFuture]];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)SliderClick{
    double newSeekTime =  _slider.value* _audioPlayer.duration;
 //   [_audioPlayer seekToTime:newSeekTime];
    
}

-(void)creatStreamer{
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    _audioPlayer.url = [NSURL URLWithString:_model.source];
    
          NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    if (_model.pic_500.length>0) {
    
    NSDictionary *dict = @{@"title":_model.name,@"coverimg":_model.pic_500,@"playing":@(_isPlaying),@"musicUrl":_model.source};
     [center postNotificationName:kChangeUIValue object:self userInfo:dict];
    }else{
        _model.pic_500  = kDefaultScreen_URL;
        NSDictionary *dict = @{@"title":_model.name,@"coverimg":_model.pic_500,@"playing":@(_isPlaying),@"musicUrl":_model.source};
        [center postNotificationName:kChangeUIValue object:self userInfo:dict];
    }
}

-(void)destroyStreamer{
    if (_audioPlayer)
    {
        [_audioPlayer  stop];
        _audioPlayer = nil;
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
