//
//  UIImageView+YearwenEventBlock.m
//  自定义运行时控件 Demo1
//
//  Created by yearwen on 15-6-4.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "UIImageView+YearwenEventBlock.h"
#import <objc/runtime.h>
@interface UIImage ()

@property(nonatomic,copy)ImageViewBlock myBlock;
@end
@implementation UIImageView (YearwenEventBlock)
- (void)setMyBlock:(ImageViewBlock)myBlock {
    objc_setAssociatedObject(self, "myBlock", myBlock, OBJC_ASSOCIATION_COPY);
}
- (ImageViewBlock)myBlock {
    return objc_getAssociatedObject(self, "myBlock");
}

-(void)addClickEventWithBlock:(ImageViewBlock)block{
    self.userInteractionEnabled = YES;
    self.myBlock = block;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.myBlock) {
        self.myBlock(self);
    }
}


@end
