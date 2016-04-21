//
//  ZZAudioItem.m
//  AudioDemo
//
//  Created by 刘威振 on 16/1/5.
//  Copyright © 2016年 LiuWeiZhen. All rights reserved.
//

#import "ZZAudioItem.h"

@implementation ZZAudioItem

+ (NSArray *)allAudioItem {
    // [[NSBundle mainBundle] pathsForResourcesOfType:(nullable NSString *) inDirectory:(nullable NSString *)];
    // 音频文件列表，AVAudioPlayer不支持流式音频文件, 如果要操作流式音频文件，要用的AVAudioQueue或第三方比如AudioStreamer, 比如https://github.com/mattgallagher/AudioStreamer
    NSArray *names = @[@"北京北京", @"喜欢你", @"夏洛特烦恼", @"大约在冬季", @"我的歌声里", @"白月光",@"十七岁的雨季",@"单身情歌",@"夜太黑",@"大约在冬季",@"白月光",@"红豆",@"蜀绣",@"谢谢你的爱",@"阴天",@"春天花会开"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < names.count; i++) {
        NSString *name = names[i];
        ZZAudioItem *item = [[ZZAudioItem alloc] init];
        item.audioPath    = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
        item.lrcPath      = [[NSBundle mainBundle] pathForResource:name ofType:@"lrc"];
        item.image        = [UIImage imageNamed:[NSString stringWithFormat:@"test_%ld.jpg", i]];
        [array addObject:item];
    }
    return array;
}

@end
