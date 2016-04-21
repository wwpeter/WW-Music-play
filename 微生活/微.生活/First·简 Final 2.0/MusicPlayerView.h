//
//  MusicPlayerView.h
//  First·简
//
//  Created by yearwen on 15/6/21.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "MainBaseController.h"

@interface MusicPlayerview : MainBaseController
@property(nonatomic,copy)NSString * musicId;
@property(nonatomic,strong)NSArray * dataArr1;
@property(nonatomic,assign)NSInteger index;
@end
