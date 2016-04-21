//
//  ReadListCell.h
//  First·简
//
//  Created by qianfeng01 on 15-6-13.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadDetailModel.h"
@interface ReadListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverimg;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
-(void)showDataWithModel:(ReadDetailModel *)model;
@end
