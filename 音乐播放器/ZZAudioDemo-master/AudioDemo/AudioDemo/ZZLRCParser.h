//
//  ZZLRCParser.h
//  ZZLRCParser
//
//  Created by 刘威振 on 1/4/16.
//  Copyright © 2016 LiuWeiZhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZLrcItem : NSObject

@property (nonatomic) float time;
@property (nonatomic, copy) NSString *lrc;

- (BOOL)descByTime:(ZZLrcItem *)item;
- (void)show;

@end

// --------------------------------------------------

@interface ZZLRCParser : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath;

@property (nonatomic, copy) NSString *title;   // [ti:歌词(歌曲)标题]
@property (nonatomic, copy) NSString *author;  // [ar:歌词作者]
@property (nonatomic, copy) NSString *albume;  // [al:歌曲所在唱片集]
@property (nonatomic, copy) NSString *editor;  // [by:本LRC文件的创建者]
@property (nonatomic, copy) NSString *version; // [ve:歌曲的版本]

@property (nonatomic) NSMutableArray *items;   // 数组里存放的是一个个ZZLrcItem对象

// 给出来时间，我们就知道应该播放哪句歌词
- (NSString *)lrcByTime:(float)time;

- (void)show;

@end
