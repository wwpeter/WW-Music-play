//
//  PersonListCell.m
//  First·简
//
//  Created by yearwen on 15/6/17.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "PersonListCell.h"
#import "UIImageView+WebCache.h"
@implementation PersonListCell

- (void)awakeFromNib {
        self.titleLabel.font = [UIFont fontWithName:@"Yuppy SC" size:15];
    self.countLabel.font = [UIFont fontWithName:@"Yuppy SC" size:12];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
}

-(void)showDataWithModel:(PersonModel *)model{
    self.titleLabel.text = model.title;
    self.countLabel.text = model.musicVisit;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed: @"3"]];
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
