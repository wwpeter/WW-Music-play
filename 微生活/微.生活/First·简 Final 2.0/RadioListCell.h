//
//  RadioListCell.h
//  First·简
//
//  Created by yearwen on 15/6/17.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedioModel.h"
@interface RadioListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coveimg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *autherLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *linsintedCountLabel;
-(void)showDataWithModel:(RedioModel * )model;
@end
