//
//  LocalAudioViewController.m
//  AudioDemo
//
//  Created by 刘威振 on 16/1/5.
//  Copyright © 2016年 LiuWeiZhen. All rights reserved.
//  参考：http://www.iliunian.com/2831.html
//

#import "LocalAudioViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZZAudioItem.h"
#import "ZZLRCParser.h"
#import "ZZArtworkHelper.h"

// 播放模式
typedef NS_ENUM(NSInteger, ZZLocalAudioPlayType) {
    ZZLocalAudioPlayTypeOrder = 0,  // 顺序播放
    ZZLocalAudioPlayTypeCycle,      // 循环播放
    ZZLocalAudioPlayTypeSingleCycle // 单曲循环
};

@interface LocalAudioViewController () <AVAudioPlayerDelegate>

/* 控件 */
@property (weak, nonatomic  ) IBOutlet UILabel        *lrcLabel;     // 显示歌词
@property (weak, nonatomic  ) IBOutlet UISlider       *volumeSlider; // 音量控制
@property (strong, nonatomic) IBOutlet UISlider *progress; // 播放进度条

/* 数据 */
@property (nonatomic) NSMutableArray *audioList;        // 音频列表
@property (nonatomic) ZZAudioItem    *currentAudioItem; // 当前正在播放的音频对象

/* 控制器 */
@property (nonatomic) AVAudioPlayer *player;  // 播放器
@property (nonatomic) ZZLRCParser *lrcParser; // 歌词解析器
@property (nonatomic) NSTimer *timer;         // 定时器，每隔一段时间刷新进度

@property (nonatomic) ZZLocalAudioPlayType playType; // 播放模式
@end

@implementation LocalAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self prepare];
}

- (void)initData {
    self.audioList = [NSMutableArray arrayWithArray:[ZZAudioItem allAudioItem]];
    self.currentAudioItem = self.audioList[0];
}

- (void)prepare {
    // [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
    [_timer invalidate], _timer = nil;
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_currentAudioItem.audioPath] error:&error];
    _player.delegate = self;
    [_player prepareToPlay]; // 准备播放
    if (error) return;
    self.lrcParser = [[ZZLRCParser alloc] initWithFilePath:_currentAudioItem.lrcPath]; // 歌词解析
    // NSLog(@"--%ld", [self.audioList indexOfObject:_currentAudioItem]);
    [self configNowPlayingInfoCenter];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

// 播放
- (IBAction)play:(id)sender {
    if ([self.player play]) {
        // NSLog(@"开始播放");
    }
    
    if (_timer == nil) {
        NSLog(@"走你!");
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES]; // 每隔一小段时间，通过timerAction:方法更新显示的歌词，更新进度条 NSTimer对象有点特殊，它们retain target，所以在当前视图消失的时候应当把定时器invalide，销毁
    }
    [self.timer setFireDate:[NSDate date]]; // 触发定时器方法，写成[NSDate distantPast]也行
}

// 暂停
- (IBAction)pause:(id)sender {
    [self.player pause];
    [self.timer setFireDate:[NSDate distantFuture]];  // 暂停定时器
}

// 停止
- (IBAction)stop:(id)sender {
    [self.player stop];
    
    self.player.currentTime = 0.0;  // 播放进度归零
    self.progress.value     = 0.0;  // 进度条归零
    [_timer invalidate], _timer = nil; // 定时器置空
}

// 静音 switch
- (IBAction)silenceSwitch:(UISwitch *)aSwitch {
    self.player.volume = aSwitch.isOn ? 0.0 : self.volumeSlider.value;
}

// 声音滑块
- (IBAction)volumeSliderAction:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.player.volume = slider.value; // player.volume范围范和默认的slider范围都是[0.0~1.0]
}

// 更改播放进度
- (IBAction)progressAction:(UISlider *)slider {
    self.player.currentTime = self.player.duration*_progress.value; // 正在播放（秒）
}

// 定时器刷新进度条
- (void)timerAction:(NSTimer *)timer {
    // NSLog(@"主线程：%d", [NSThread isMainThread]);
    
    // 更新进度条 player.currentTime当前播放时间 player.duration整个歌曲共占用的时候
    self.progress.value = self.player.currentTime/self.player.duration;
    
    NSString *lrc = [self.lrcParser lrcByTime:self.player.currentTime];
    if (lrc.length <= 0) {
        return;
        // NSLog(@"%f %@", _player.currentTime, lrc);
    }
    self.lrcLabel.text = [self.lrcParser lrcByTime:self.player.currentTime];
    
    [self refreshArtwork];
}

// 锁屏下图片
// 在锁屏界面显示歌曲信息(实时换图片MPMediaItemArtwork可以达到实时换歌词的目的（先这样处理，目前没有找到其他解决方法）
- (void)refreshArtwork {
    if (_currentAudioItem.image) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
        // NSLog(@"refreshArtwork内存地址：%p", dict); // 打印结果显示这个内存地址不断的在变化
        
        // MPMediaItemArtwork *artwork = [dict objectForKey:MPMediaItemPropertyArtwork];
        UIImage *image = [ZZArtworkHelper artworkImageWithOriginImage:_currentAudioItem.image text:_lrcLabel.text];
        MPMediaItemArtwork *newArtwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:newArtwork forKey:MPMediaItemPropertyArtwork];
        
        // [dict setObject:_lrcParser.title forKey:MPMediaItemPropertyTitle]; // 歌曲名
        // NSLog(@"Now: %@", [dict objectForKey:MPMediaItemPropertyTitle]);
        
        [dict setObject:_lrcParser.title forKey:MPMediaItemPropertyTitle];                    // 歌曲名
        [dict setObject:_lrcParser.author forKey:MPMediaItemPropertyArtist];                  // 歌首，艺术家
        [dict setObject:_lrcParser.albume forKey:MPMediaItemPropertyAlbumTitle];              // 专辑名
        [dict setObject:@(self.player.duration) forKey:MPMediaItemPropertyPlaybackDuration];  // 时间
        [dict setObject:@(self.player.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; // 进度
        // 锁屏状态下进度条
        /**
         NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
         [dict setObject:[NSNumber numberWithDouble:self.player.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
         [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
         */
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

// 上一首
- (IBAction)previousSong:(UIButton *)button {
    NSInteger index = [self.audioList indexOfObject:_currentAudioItem];
    if (index <= 0) {
        // NSLog(@"已是第一首");
        return;
    } else {
        _currentAudioItem = [self.audioList objectAtIndex:--index];
        [self prepareAndPlay];
    }
}

// 下一首
- (IBAction)nextSong:(id)sender {
    NSInteger index = [self.audioList indexOfObject:_currentAudioItem];
    if (index >= self.audioList.count-1) {
        // NSLog(@"已是最后一首");
        return;
    } else {
        _currentAudioItem = [self.audioList objectAtIndex:++index];
        [self prepareAndPlay];
    }
}

- (void)prepareAndPlay {
    [self prepare];
    [self play:nil];
}

// 解决定时器的内存问题
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate], _timer = nil;
    // [self resignFirstResponder];
}

// 后台播放信息显示
- (void)configNowPlayingInfoCenter {
    // NSLog(@"%@ title: %@", NSStringFromSelector(_cmd), _lrcParser.title);
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) { // 类MPNowPlayingInfoCenter是否存在，因为这个类是5.0之后出现的
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        /* 备注：下面这几个设置最好判断下是否为空，比如假设_lrcParser.title为空，会crash */
        [dict setObject:_lrcParser.title forKey:MPMediaItemPropertyTitle]; // 歌曲名
        [dict setObject:_lrcParser.author forKey:MPMediaItemPropertyArtist];  // 歌首，艺术家
        [dict setObject:_lrcParser.albume forKey:MPMediaItemPropertyAlbumTitle]; // 专辑名
        [dict setObject:@(self.player.duration) forKey:MPMediaItemPropertyPlaybackDuration];  // 时间
        
        // MPMediaItem *item = [[MPMediaItem alloc] init];
        // item.title =
        /**
         MPNowPlayingInfoCenter 用于播放APP中正在播放的媒体信息.
         播放的信息会显示在锁屏页面和多任务管理页面.如果用户是用airplay播放的话 会自动投射到相应的设备上.
         From apple: https://developer.apple.com/library/ios/documentation/MediaPlayer/Reference/MPNowPlayingInfoCenter_Class/index.html
         Use a now playing info center to set now-playing information for media being played by your app.
         */
        
        UIImage *image = _currentAudioItem.image ? [ZZArtworkHelper artworkImageWithOriginImage:_currentAudioItem.image text:_lrcParser.title] : [UIImage imageNamed:@"placeholder"];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        
        // NSLog(@"configuration内存地址: %p", dict);
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause: { // 暂停
                [self pause:nil];
            }
                break;
            case UIEventSubtypeRemoteControlPlay: { // 播放
                [self play:nil];
            }
                break;
            case UIEventSubtypeRemoteControlNextTrack: { // 下一首
                [self nextSong:nil];
            }
                break;
            case UIEventSubtypeRemoteControlPreviousTrack: { // 上一首
                [self previousSong:nil];
            }
                break;
            default:
                break;
        }
    }
}

// 此句代码若不写，remoteControlReceivedWithEvent得不到调用
- (BOOL)canBecomeFirstResponder {
    return YES;
}

/**
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}
 
 当然也不一定是在viewcontroller中，也可以是在applicationDidEnterBackground:方法中开始接受远程控制，applicationDidBecomeActive:中结束接受远程控制
*/

#pragma mark - 播放模式
// 顺序播放模式
- (IBAction)setOrderModel:(id)sender {
    self.playType = ZZLocalAudioPlayTypeOrder;
}

// 循环播放模式
- (IBAction)setCycleModel:(id)sender {
    self.playType = ZZLocalAudioPlayTypeCycle;
}

// 单曲循环模式
- (IBAction)setSingleCycleModel:(id)sender {
    self.playType = ZZLocalAudioPlayTypeSingleCycle;
}

#pragma mark - <AVAudioPlayerDelegate>
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) { // if flag is no, it means the system decode audio data fail
        switch (self.playType) {
            case ZZLocalAudioPlayTypeOrder: {      // 顺序播放
                [self nextSong:nil];
                break;
            }
            case ZZLocalAudioPlayTypeCycle: {      // 循环播放
                if ([self.audioList indexOfObject:_currentAudioItem] >= self.audioList.count-1) {
                    _currentAudioItem = self.audioList[0];
                    [self prepareAndPlay];
                }
                break;
            }
            case ZZLocalAudioPlayTypeSingleCycle: { // 单曲循环
                [self prepareAndPlay];
                break;
            }
            default:
                break;
        }
    }
}

@end
