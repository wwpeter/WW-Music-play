//
//  ContainerViewController.h
//  ContainerDemo
//
//  Created by qianfeng on 15/3/3.
//  Copyright (c) 2015年 WeiZhenLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;

- (id)initWithViewControllers:(NSArray *)viewControllers;

@end
