//
//  MusicListCell.h
//  First·简
//
//  Created by yearwen on 15/6/16.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicDetailModel.h"
@interface MusicListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backGroundView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;



-(void)showDataWithModel:(MusicDetailModel *)model;
@end
