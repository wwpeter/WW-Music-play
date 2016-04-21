//
//  ZZAudioItem.h
//  AudioDemo
//
//  Created by 刘威振 on 16/1/5.
//  Copyright © 2016年 LiuWeiZhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZZAudioItem : NSObject

@property (nonatomic, copy) NSString *audioPath;
@property (nonatomic, copy) NSString *lrcPath;
@property (nonatomic) UIImage *image;

+ (NSArray *)allAudioItem;

@end
