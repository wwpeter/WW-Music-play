//
//  UIImage+ZZHelper.h
//  AudioDemo
//
//  Created by 刘威振 on 16/1/6.
//  Copyright © 2016年 LiuWeiZhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZZHelper)

+ (UIImage *)imageWithView:(UIView *)view;
- (UIImage *)scaleToSize:(CGSize)size;

@end
