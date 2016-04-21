//
//  RadioListCell.m
//  First·简
//
//  Created by yearwen on 15/6/17.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "RadioListCell.h"
#import "UIImageView+WebCache.h"
@implementation RadioListCell

- (void)awakeFromNib {
    self.titleLabel.font = [UIFont fontWithName:@"Yuppy SC" size:18];
    self.autherLabel.font = [UIFont fontWithName:@"Yuppy SC" size:10];
    self.autherLabel.textColor = [UIColor colorWithRed:105/255.0 green:127/255.0 blue:156/255.0 alpha:1];
    self.countLabel.font = [UIFont fontWithName:@"Yuppy SC" size:11];
    self.coveimg.layer.masksToBounds = YES;
    self.coveimg.layer.cornerRadius = 5;
}
-(void)showDataWithModel:(RedioModel *)model{
    self.titleLabel.text = model.title;
    NSString * author = [NSString stringWithFormat:@"by:%@",model.uname];
    self.autherLabel.text = author;
    self.countLabel.text = model.desc;
    self.linsintedCountLabel.text = model.count.stringValue;
    [self.coveimg sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed: @"3"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
