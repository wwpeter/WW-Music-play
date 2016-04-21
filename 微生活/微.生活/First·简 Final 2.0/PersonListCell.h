//
//  PersonListCell.h
//  First·简
//
//  Created by yearwen on 15/6/17.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
@interface PersonListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
-(void)showDataWithModel:(PersonModel *)model;
@end
