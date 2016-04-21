//
//  ZZArtworkHelper.m
//  AudioDemo
//
//  Created by 刘威振 on 16/1/6.
//  Copyright © 2016年 LiuWeiZhen. All rights reserved.
//

#import "ZZArtworkHelper.h"
#import "UIImage+ZZHelper.h"

@implementation ZZArtworkHelper

+ (UIImage *)artworkImageWithOriginImage:(UIImage *)anImage text:(NSString *)text {
    CGSize size               = CGSizeMake([[UIScreen mainScreen] bounds].size.width-40, [[UIScreen mainScreen] bounds].size.width-40);
    UIImageView *imageView    = [[UIImageView alloc] initWithImage:[anImage scaleToSize:size]];
    UILabel *textLabel        = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.bounds)-100, CGRectGetWidth(imageView.bounds), 100)];
    textLabel.textColor       = [UIColor yellowColor];
    textLabel.text            = text;
    textLabel.font            = [UIFont systemFontOfSize:18.0];
    textLabel.numberOfLines   = 0;
    textLabel.textAlignment   = NSTextAlignmentCenter;
    textLabel.backgroundColor = [UIColor clearColor];
    [imageView addSubview:textLabel];
    return [UIImage imageWithView:imageView];
}

@end
