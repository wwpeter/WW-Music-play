//
//  RadioPlayerView.m
//  First·简
//
//  Created by yearwen on 15/6/19.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "RadioPlayerView.h"

#import "UMSocial.h"
#import "AudioPlayer.h"


AudioPlayer * _audioPlayer;
@interface RadioPlayerView ()<UMSocialUIDelegate>
{
    UILabel * _time1;
    UILabel * _time2;
    BOOL _isPlaying;
    NSTimer * _timer;
    UISlider * _slider;
    UIImageView * _roundImg;
    NSInteger _in;
}
@end

@implementation RadioPlayerView

- (void)viewDidLoad {
    [super viewDidLoad];
       [self isFire];
    [self creatView];
    [self creatTableView];
    [self creatTimer];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isPlaying = YES;
    [self creatSharedButton];
    
   // self.navigationController.navigationBarHidden =YES;
 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

-(void)creatSharedButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenSize.width-60, 20, 40, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"iphone_nav_share@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sharedDataBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)sharedDataBtn{
    NSString * body  =[NSString stringWithFormat:@"分享声音,分享生活:%@,%@",self.model.title,self.model.musicUrl];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:kUMengKey shareText:body shareImage:nil shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatTimeline,UMShareToSms,UMShareToEmail] delegate:self];
}




-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    [self durtion];
    [self startRotation];
}





-(void)isFire{
    if (_timer) {
        [_timer setFireDate:[NSDate distantPast]];
        
    }
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
-(void)creatView{
    UIImageView * backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    backImg.alpha = 0.5;
    [backImg sd_setImageWithURL:[NSURL URLWithString:self.model.coverimg] placeholderImage:[UIImage imageNamed:@"3"]];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, kScreenSize.width-40, 40)];
    label.text = self.model.title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Yuppy SC" size:16];
    label.numberOfLines = 0;
    UIView *view = [[UIView alloc]initWithFrame:label.frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.7;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
     _roundImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width/2-150, kScreenSize.height/2-150, 300, 300)];
    [_roundImg sd_setImageWithURL:[NSURL URLWithString:self.model.coverimg] placeholderImage:[UIImage imageNamed:@"3"]];
    _roundImg.layer.masksToBounds = YES;
    _roundImg.layer.cornerRadius = 150;

   _slider = [[UISlider alloc]initWithFrame:CGRectMake(60, kScreenSize.height/2+170, kScreenSize.width-120, 30)];
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 1.0;
    _slider.value = 0.0;
    [_slider addTarget:self action:@selector(SliderClick) forControlEvents:UIControlEventValueChanged];
    UIImage * ima =  [UIImage imageNamed:@"playBar_play@2x"];
    [_slider setThumbImage:ima forState:UIControlStateNormal];
    [_slider setThumbImage:ima forState:UIControlStateHighlighted];
    _time1 = [[UILabel alloc]initWithFrame:CGRectMake(5,  kScreenSize.height/2+170, 55, 30)];
    _time2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-60, kScreenSize.height/2+170, 55, 30)];
    _time1.text = @"00:00";
    _time2.text = @"00:00";
    _time1.font = [UIFont fontWithName:@"Yuppy SC" size:14];
    _time2.font = [UIFont fontWithName:@"Yuppy SC" size:14];
    _time1.textAlignment = NSTextAlignmentCenter;
    _time2.textAlignment = NSTextAlignmentCenter;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenSize.width/2-20, kScreenSize.height/2+230, 40, 40) ;
    btn.tag = 101;
    [btn setImage:[UIImage imageNamed:@"radarPlay"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(kScreenSize.width/2+60, kScreenSize.height/2+160, 40, 40);
    btn.tag = 102;
    [btn1 setImage:[UIImage imageNamed:@"radarStop"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame  = CGRectMake(20, 20, 30, 30);
    [btn2 setImage:[UIImage imageNamed: @"misc_stop_iphone"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backImg];
    [self.view addSubview:view];
    [self.view addSubview:label];
    [self.view addSubview:_roundImg];
    [self.view addSubview:_slider];
    [self.view addSubview:_time1];
    [self.view addSubview:_time2];
    [self.view addSubview:btn];
  //  [self.view addSubview:btn1];
    [self.view addSubview:btn2];
}

-(void)backClick{
    [_timer invalidate];
    _timer = nil;
   // [self.navigationController popViewControllerAnimated:YES];
   // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}



-(void)SliderClick{
  //  double newSeekTime =  _slider.value* _audioPlayer.duration;
  //  [_audioPlayer seekToTime:newSeekTime];

}
-(void)btnClick:(UIButton *)btn{
    
    if (_isPlaying ==YES ) {
     
        [self destroyStreamer];
        [btn setImage:[UIImage imageNamed:@"radarP"] forState:UIControlStateNormal];
        if (!_audioPlayer) {
            [self creatStreamer];
        }
        [_audioPlayer play];
        [self durtion];
        [self startRotation];
        [_timer setFireDate:[NSDate distantPast]];
        _isPlaying =NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }else{
        [btn setImage:[UIImage imageNamed:@"radarPlay"] forState:UIControlStateNormal];
        [_audioPlayer stop];
        _isPlaying =YES;
    }

}
-(void)creatStreamer{
    [self destroyStreamer];
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    _audioPlayer.url = [NSURL URLWithString:_model.musicUrl];
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"title":_model.title,@"coverimg":_model.coverimg,@"playing":@(_isPlaying),@"musicUrl":_model.musicUrl};
    [center postNotificationName:kChangeUIValue object:self userInfo:dict];
}

- (void)destroyStreamer
{
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}
-(void)durtion{
    //Rotation
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI *2 ];
    
    //default RotationDuration value
    if (self.rotationDuration == 0) {
        self.rotationDuration = kRotationDuration;
    }
    
    rotationAnimation.duration = self.rotationDuration;
    rotationAnimation.repeatCount = FLT_MAX;
    rotationAnimation.cumulative = NO;
    [_roundImg.layer addAnimation:rotationAnimation forKey:nil];
}
-(void) startRotation
{
    //start Animation
    CFTimeInterval pausedTime = [_roundImg.layer timeOffset];
    _roundImg.layer.speed = 0.2;
    _roundImg.layer.timeOffset = 0.0;
    _roundImg.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [_roundImg.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    _roundImg.layer.beginTime = timeSincePause;
}

@end
