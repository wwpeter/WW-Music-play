//
//  ReadBaseController.h
//  First·简
//
//  Created by qianfeng01 on 15-6-13.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "MainBaseController.h"
#import "ReadDetailModel.h"

@interface ReadBaseController : MainBaseController
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,copy)NSString * chinnal;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * specilType;
@end
