//
//  ChipFellingsCell.m
//  First·简
//
//  Created by yearwen on 15/6/16.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "ChipFellingsCell.h"
#import "UIImageView+WebCache.h"
@implementation ChipFellingsCell

- (void)awakeFromNib {    
}

-(void)shwoDataWithModel:(ChipFellingsModels *)model{
    if (self.infoImage.frame.size.height >0) {
        self.infoImage.frame =CGRectZero;
    }
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed: @"about"]];
    self.headImage.layer.masksToBounds =YES;
    self.headImage.layer.cornerRadius = 15;
    self.unameLabel.text = model.uname;
    self.unameLabel.textColor = [UIColor colorWithRed:73/255.0 green:94/255.0 blue:123/255.0 alpha:1];
    self.unameLabel.font = [UIFont fontWithName:@"Yuppy SC" size:17];
    if (model.coverimg_wh.length>0) {
        NSArray * wh = [model.coverimg_wh componentsSeparatedByString:@"*"];
        CGFloat with = [wh[0] doubleValue];
        CGFloat height = [wh[1] doubleValue];
        CGFloat imageH =(kScreenSize.width-20)*height/with;
        self.infoImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 20+36, kScreenSize.width-20, imageH)];
        [self.infoImage sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed: @"3"]];
        self.infoImage.layer.masksToBounds = YES;
        self.infoImage.layer.cornerRadius = 5;
        [self addSubview:self.infoImage];
    }

    self.infoTextLabel.text =model.content;
   // self.infoTextLabel.font = [UIFont fontWithName:@"Yuppy SC" size:17];
    self.timeLabel.text = model.addtime_f;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
