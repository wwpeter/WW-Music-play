//
//  ChipFellingsCell.h
//  First·简
//
//  Created by yearwen on 15/6/16.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChipFellingsModels.h"
@interface ChipFellingsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)  UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;
-(void)shwoDataWithModel:(ChipFellingsModels *)model;
@end
