//
//  AudioViewController.m
//  Free Shake
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 WuRunTao. All rights reserved.
//

#import "PictureScanController.h"
#import "ReadingViewController.h"
#import "MemoryViewController.h"
#import "AudioViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZZLrcParser.h"
#import "MemoryViewController.h"
#import "ResourceData.h"

@interface AudioViewController ()<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>

@property (nonatomic) NSArray *classArray;

@property (weak, nonatomic) IBOutlet UIScrollView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *singerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *progressView;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (nonatomic) NSMutableArray *progressImageArray;
@property (nonatomic) NSArray *lrcArray;

@property (nonatomic) ZZLrcParser *lrcParser;
@property (nonatomic) AVAudioPlayer *player;
@property (nonatomic) AudioData *audio;

@property (nonatomic) NSTimer *progressTimer;
@property (nonatomic) NSTimer *titleTimer;
@property (nonatomic) NSTimer *lrcTimer;

@property (nonatomic) NSString *foreLrc;
@property (nonatomic) NSString *currentLrc;
@property (nonatomic) BOOL isPlay;
@property (nonatomic) NSInteger flag;

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _flag = 6;
    
    [self initLrc];
    
    [self initPlayer];
    
    [self setOtherUI];
    
    [self startTitleTimer];
}

//初始化歌词
- (void)initLrc{
    self.audio = [ResourceData getAudioByLocal];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:_audio.name ofType:@"lrc"];
    self.lrcParser = [[ZZLrcParser alloc]initWithFilePath:filePath];
    self.lrcArray = _lrcParser.lrcArray;
    self.foreLrc = _lrcArray[0];
}

//初始化播放器
- (void)initPlayer{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:_audio.name ofType:@"mp3"];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    self.player.delegate = self;
    _isPlay = NO;
    [self.player prepareToPlay];
}

//设置XIB 未设置的UI
- (void)setOtherUI{
    self.navigationController.navigationBarHidden = YES;
    _tableView.rowHeight = 30;
    _tableView.userInteractionEnabled = NO;
    
    [_singerBtn setBackgroundImage:[UIImage imageNamed:_audio.name] forState:UIControlStateNormal];
    _singerBtn.layer.cornerRadius = _singerBtn.frame.size.width/2.0;
    _singerBtn.layer.masksToBounds = YES;
    
    CGAffineTransform form = _volumeSlider.transform;
    _volumeSlider.transform = CGAffineTransformRotate(form, -M_PI_2);
    _volumeSlider.hidden = YES;
    
    [self setTitleView];
}

//标题view显示循环滚动
- (void)startTitleTimer {
    _titleTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(titleTimer:) userInfo:nil repeats:YES];
}

- (void)titleTimer:(NSTimer *)timer {
    CGPoint offset = _titleView.contentOffset;
    if (offset.x < _titleView.contentSize.width) {
        offset.x += 1;
    } else {
        offset.x = -_titleView.frame.size.width;
    }
    _titleView.contentOffset = offset;
}

//设置标题View
- (void)setTitleView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textColor = [UIColor purpleColor];
    NSString *name = self.lrcParser.title;
    NSString *singer = self.lrcParser.author;
    NSString *albume = self.lrcParser.albume;
    if (albume.length == 0) {
        albume = @"未知";
    }
    label.text = [NSString stringWithFormat:@"歌曲:《%@》 演唱:%@ 专辑:%@",name,singer,albume];
    [label sizeToFit];
    _titleView.contentSize = CGSizeMake(label.frame.size.width, label.frame.size.height);
    [_titleView addSubview:label];
}

//点击播放按钮  播放和暂停事件
- (IBAction)singerBtnClick:(id)sender {
    if (_isPlay) {
        [self.player pause];
        [self stopAllTimer];
        _isPlay = NO;
    }else{
        [self startPlayer];
        [self startProgressTimer];
        self.player.volume = self.volumeSlider.value;
        _isPlay = YES;
    }
}
//播放
- (void)startPlayer{
    [self.player play];
    if (_lrcTimer == nil) {
        self.lrcTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
    [self.lrcTimer setFireDate:[NSDate date]];
}
//同步歌词
- (void)timerAction:(id)sender{
    [self rotateSingerBtn];
    self.currentLrc = [self.lrcParser lrcByTime:self.player.currentTime];
    if (_currentLrc != _foreLrc) {
        _flag++;
        CGPoint offset = self.tableView.contentOffset;
        offset.y += 30;
        [self.tableView setContentOffset:offset animated:YES];
        [self.tableView reloadData];
        _foreLrc = _currentLrc;
    }
}
//播放按钮旋转动画
- (void)rotateSingerBtn{
    CGAffineTransform form = _singerBtn.transform;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.05];
    _singerBtn.transform = CGAffineTransformRotate(form, M_PI_4/36.0);
    [UIView commitAnimations];
}
//自定义进度条
- (void)startProgressTimer{
    if (_progressTimer == nil) {
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressTimerAction:) userInfo:nil repeats:YES];
    }
    [self.progressTimer setFireDate:[NSDate date]];
    
    self.progressImageArray = [NSMutableArray array];
    for (NSInteger i = 1; i < 9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Ari_%ld",i]];
        [_progressImageArray addObject:image];
    }
}
//进度条动态移动
- (void)progressTimerAction:(id)sender{
    CGPoint center = self.progressView.center;
    CGFloat offset = 330/self.player.duration;
    center.x += offset;
    
    self.progressView.animationDuration = 3;
    self.progressView.animationImages = _progressImageArray;
    self.progressView.animationRepeatCount = 0;
    [_progressView startAnimating];
    
    [UIView beginAnimations:nil context:nil];
    _progressView.center = center;
    [UIView commitAnimations];
}
//停止所有计时器
- (void)stopAllTimer{
    [self.lrcTimer invalidate],self.lrcTimer = nil;
    [self.progressTimer invalidate],self.progressTimer = nil;
}
- (void)stopPlayer{
    [self.player stop];
    self.player.currentTime = 0.0;
    
    _flag = 6;
    [self.tableView setContentOffset:CGPointZero animated:YES];
    self.progressView.frame = CGRectMake(-10, 590, 55, 55);
    [_progressView stopAnimating];
    [self.progressTimer invalidate],_progressTimer = nil;
    [self.lrcTimer invalidate],_lrcTimer = nil;
}
- (IBAction)changeVolume:(UISlider *)sender {
    self.player.volume = sender.value;
}
- (IBAction)showVolume:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.volumeSlider.hidden = NO;
    }else{
        self.volumeSlider.hidden = YES;
    }
}
- (IBAction)stopMusic:(id)sender {
    _isPlay = NO;
    [self stopPlayer];
}
#pragma mark - <AVAudioPlayerDelegate>
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopPlayer];
}
//------------------------------------------------------------------

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row < 6) {
        cell.textLabel.text = @"";
    }else{
        cell.textLabel.text = self.lrcArray[indexPath.row-6];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        if (indexPath.row == _flag) {
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
        }
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return cell;
}


#pragma other
- (BOOL)prefersStatusBarHidden{
    return YES;
}
// 摇一摇跳转界面
// 晃动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self stopPlayer];
    [self removeAllViews];
    
    self.classArray = @[[PictureScanController class],[ReadingViewController class],[MemoryViewController class]];
    NSInteger index = arc4random()%3;
    Class cls = self.classArray[index];
    SuperViewController *controller = [[cls alloc]init];
    controller.user = self.user;
    [self.navigationController pushViewController:controller animated:YES];
}

@end




















