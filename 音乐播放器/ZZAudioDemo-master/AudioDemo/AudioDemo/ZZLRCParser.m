//
//  ZZLRCParser.m
//  ZZLRCParser
//
//  Created by 刘威振 on 1/4/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import "ZZLRCParser.h"

NSString *const kTitle   = @"ti";
NSString *const kAuthor  = @"ar";
NSString *const kAlbume  = @"al";
NSString *const kEditor  = @"by";
NSString *const kVersion = @"ve";

@implementation ZZLrcItem

- (BOOL)descByTime:(ZZLrcItem *)item {
    return self.time > item.time;
}

- (void)show {
    printf("time: %f --> song: %s\n", self.time, [self.lrc UTF8String]);
}

@end

// --------------------------------------------------

@implementation ZZLRCParser

- (instancetype)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        self.items = [NSMutableArray array];
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if (content == nil) {
            @throw [NSException exceptionWithName:@"读取文件失败" reason:[NSString stringWithFormat:@"请检查文件：%@", filePath] userInfo:nil];
        }
        NSArray *array = [content componentsSeparatedByString:@"\n"];
        for (NSString  *str in array) {
            if (str.length == 0) continue; // @""
            unichar c = [str characterAtIndex:1];
            if (c <= '9' && c >= '0') {
                [self parseTimeString:str]; // 时间歌词
            } else {
                [self parseFileInfo:str];
            }
        }
    }
    return self;
}

// [02:11.27][01:50.22][00:21.95]穿过幽暗地岁月
// [00:06.53]你对自由地向往
- (void)parseTimeString:(NSString *)aStr {
    NSArray *array = [aStr componentsSeparatedByString:@"]"];
    // [02:11.27
    // [01:50.22
    // [00:21.95
    // 穿过幽暗地岁月
    NSString *song = [array lastObject];
    // 遍历的话不取最后一项（最后一项是歌词项）
    for (NSInteger i = 0; i < array.count-1; i++) {
        NSString *timeStr = array[i]; // [02:11.27
        timeStr = [timeStr substringFromIndex:1]; // 02:11.27
        NSArray *arr = [timeStr componentsSeparatedByString:@":"];
        NSString *minute = arr[0];
        NSString *second = arr[1];
        float time = [minute floatValue]*60 + [second floatValue]; // 131.27
        
        ZZLrcItem *item = [[ZZLrcItem alloc] init];
        item.time = time; // 131.27
        item.lrc = song; // 穿过幽暗地岁月
        [_items addObject:item];
    }
    
    // 以时间升序排序
    [_items sortUsingSelector:@selector(descByTime:)];
}

- (void)parseFileInfo:(NSString *)aStr {
    NSString *newStr = aStr;
    newStr = [newStr substringFromIndex:1]; // [ti:蓝莲花] -> ti:蓝莲花]
    newStr = [newStr substringToIndex:newStr.length-1]; // ti:蓝莲花
    NSArray *arr = [newStr componentsSeparatedByString:@":"];
    NSString *type = arr[0]; // ti
    NSString *content = arr[1]; // 蓝莲花
    if ([type isEqualToString:kTitle]) {
        self.title = content;
    } else if ([type isEqualToString:kAuthor]) {
        self.author = content;
    } else if ([type isEqualToString:kAlbume]) {
        self.albume = content;
    } else if ([type isEqualToString:kEditor]) {
        self.author = content;
    } else if ([type isEqualToString:kVersion]) {
        self.version = content;
    }
}

- (NSString *)lrcByTime:(float)time {
    ZZLrcItem *item = [self itemByTime:time];
    return item.lrc;
}

// 找比time稍大的，返回上一条
- (ZZLrcItem *)itemByTime:(float)time {
    NSInteger index = -100;
    for (NSInteger i = 0; i < self.items.count; i++) {
        ZZLrcItem *item = self.items[i];
        if (item.time > time) { // 找到了比time大一点的项
            index = i - 1;
            break;
        }
    }
    
    if (index == -1) { // 播放第一行
        index = 0;
    } else if (index == -100) { // 播放最后一行
        index = _items.count-1;
    }
    
    return _items[index];
}

- (void)show {
    [_items makeObjectsPerformSelector:@selector(show)];
}

/**
 * ZZLrcParser {
 author,
 title,
 ...
 
 NSMutableArray *_items; // 数组里存放的是一个修正的<ZZLrcItem>对象
 }
 */

@end