//
//  SettingAboutUsView.m
//  First·简
//
//  Created by yearwen on 15/6/27.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "SettingAboutUsView.h"

@interface SettingAboutUsView ()
{
    UILabel * _label1;
    UILabel * _label2;
    UILabel * _label3;
    UILabel * _label4;
    UIImageView * _LogoImage;

}
@end

@implementation SettingAboutUsView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self creatAnimationLabel];
    [self creatAnimation];
}

-(void)creatTableView{
    UIImageView * backImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageNamed:@"start"];
    [self.view addSubview:backImage];
    
    _LogoImage= [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width/2-100, 100, 200, 100)];
    _LogoImage.image = [UIImage imageNamed:@"2"];
    [self.view addSubview:_LogoImage];
}
-(void)creatAnimationLabel{
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width/2-150, kScreenSize.height+10, 300, 20)];
    _label1.text = @"当前版本:v 1.0";
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.font = [UIFont fontWithName:@"Yuppy SC" size:17];
    _label1.textColor = [UIColor whiteColor];
    _label1.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_label1];
    
    _label2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width/2-150, kScreenSize.height+40, 300, 20)];
    _label2.text = @"给我片刻,倾听回声";
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.font =[UIFont fontWithName:@"Yuppy SC" size:17];
    _label2.textColor = [UIColor whiteColor];
    _label2.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_label2];

    
    
    
    _label3 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width/2-150, kScreenSize.height+80, 300, 20)];
    _label3.text = @"选取网络优秀文艺资源";
    _label3.textAlignment = NSTextAlignmentCenter;
    _label3.font =[UIFont fontWithName:@"Yuppy SC" size:17];
    _label3.textColor = [UIColor whiteColor];
    _label3.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_label3];

     _label4 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width/2-150, kScreenSize.height+120, 300, 20)];
    _label4.text = @"文艺清新感受,尽在 微·生活";
    _label4.textAlignment = NSTextAlignmentCenter;
    _label4.font =[UIFont fontWithName:@"Yuppy SC" size:17];
    _label4.textColor = [UIColor whiteColor];
    _label4.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_label4];
}


-(void)creatAnimation{
    [UIView animateWithDuration:5 animations:^{
        
    }];
    
    [UIView animateWithDuration:5 animations:^{
        _label1.frame = CGRectMake(kScreenSize.width/2-150, 200, 300, 300);
     
    }];
  
    [UIView animateWithDuration:5.5 animations:^{
        _label2.frame = CGRectMake(kScreenSize.width/2-150, 240, 300, 300);
    }];
   
    [UIView animateWithDuration:6 animations:^{
        _label3.frame = CGRectMake(kScreenSize.width/2-150, 280, 300, 300);
    }];
    
    [UIView animateWithDuration:6.5 animations:^{
        _label4.frame = CGRectMake(kScreenSize.width/2-150, 320, 300, 300);
    }];
    
}





@end
