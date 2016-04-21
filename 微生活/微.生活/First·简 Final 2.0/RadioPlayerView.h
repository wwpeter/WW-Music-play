//
//  RadioPlayerView.h
//  First·简
//
//  Created by yearwen on 15/6/19.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "MainBaseController.h"
#import "PersonModel.h"
@class AudioPlayer;
@interface RadioPlayerView : MainBaseController
@property(nonatomic,strong)PersonModel * model;
@property (assign, nonatomic) float rotationDuration;
@end
