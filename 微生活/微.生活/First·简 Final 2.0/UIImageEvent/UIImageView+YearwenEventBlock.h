//
//  UIImageView+YearwenEventBlock.h
//  自定义运行时控件 Demo1
//
//  Created by yearwen on 15-6-4.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ImageViewBlock) (UIImageView *imageView);
@interface UIImageView (YearwenEventBlock)
-(void)addClickEventWithBlock:(ImageViewBlock)block;
@end
