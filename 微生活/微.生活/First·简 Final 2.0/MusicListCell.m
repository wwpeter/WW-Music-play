//
//  MusicListCell.m
//  First·简
//
//  Created by yearwen on 15/6/16.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "MusicListCell.h"
#import "UIImageView+WebCache.h"
@implementation MusicListCell

- (void)awakeFromNib {
    self.NameLabel.font = [UIFont fontWithName:@"Yuppy SC" size:18];
    self.NameLabel.textColor = [UIColor colorWithRed:112/255.0 green:104/255.0 blue:25/255.0 alpha:1];
    self.userName.font = [UIFont fontWithName:@"Yuppy SC" size:14];
     self.userName.textColor = [UIColor colorWithRed:112/255.0 green:104/255.0 blue:25/255.0 alpha:1];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 6;
    
}


-(void)showDataWithModel:(MusicDetailModel *)model{
    self.NameLabel.text = model.name;
    
    self.userName.text = model.userName;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.pic_500] placeholderImage:[UIImage imageNamed: @"3"]];
    [self.backGroundView sd_setImageWithURL:[NSURL URLWithString:model.pic_500] placeholderImage:[UIImage imageNamed: @"3"]];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
