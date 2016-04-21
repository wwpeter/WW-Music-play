//
//  ReadListCell.m
//  First·简
//
//  Created by qianfeng01 on 15-6-13.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "ReadListCell.h"
#import "UIImageView+WebCache.h"
@implementation ReadListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showDataWithModel:(ReadDetailModel *)model{
    self.titleLabel.text = model.title;
    self.titleLabel.font = [UIFont fontWithName:@"Yuppy SC" size:17];
    self.contentLabel.text = model.content;
    self.contentLabel.font = [UIFont fontWithName:@"Yuppy SC" size:14];
    [self.coverimg sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed: @"bomimg"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
