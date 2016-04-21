//
//  SettingViewController.m
//  First·简
//
//  Created by yearwen on 15/6/25.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingAboutUsView.h"
#import "ErrorAndAdvice.h"

@interface SettingViewController ()
{
    UILabel * _label;

}

@property(nonatomic,strong)NSMutableArray *selfDataArr1;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selfDataArr1  = [[NSMutableArray alloc]init];
    [self initDataArr];
}
-(void)initDataArr{
    NSArray * arr1 =@[@"清除缓存"];
    NSArray * arr2 =@[@"关于我们",@"当前版本:1.0"];
    [self.selfDataArr1 addObject:arr1];
    [self.selfDataArr1 addObject:arr2];

        [self creatTableView];
   // self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"通用设置";
    }
    return @"基本信息";

}


#pragma mark  - 实现协议的方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.selfDataArr1[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString * cellID = @"cell";
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text  = self.selfDataArr1[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Yuppy SC" size:18];
    cell.backgroundColor = [UIColor colorWithRed:220/255.0 green:231/255.0 blue:219/255.0 alpha:1.0];
    if (indexPath.section==0&indexPath.row==1) {
       //CGRectMake(kScreenSize.width-100, 10, 100, 20)];
      
    
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 60;
}


-(CGFloat)getCaheSize{
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    NSString * myCachePath = [NSHomeDirectory() stringByAppendingString:@"微.生活/Caches"];
    NSDirectoryEnumerator * enumerator = [[NSFileManager defaultManager]enumeratorAtPath:myCachePath];
    __block  NSUInteger count = 0;
    for (NSString * fileName in enumerator) {
        NSString * path = [myCachePath stringByAppendingString:fileName];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        count += fileDict.fileSize;//自定义所有缓存大小
    }
    // 得到是字节  转化为M
    CGFloat totalSize = ((CGFloat)imageCacheSize+count)/1024/1024;
    return totalSize;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //0分区
        switch (indexPath.row) {
            case 0://清除缓存
            {
                UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"总共有%.2fM缓存",[self getCaheSize]] preferredStyle:UIAlertControllerStyleActionSheet];
                //增加按钮
                [sheet addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    //删除
                    //删除两部分
                    //1.删除 sd 图片缓存
                    //先清除内存中的图片缓存
                    [[SDImageCache sharedImageCache] clearMemory] ;
                    //清除磁盘的缓存
                    [[SDImageCache sharedImageCache] clearDisk];
                    //2.删除自己缓存
                    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"微·生活/Caches"];
                    [[NSFileManager defaultManager] removeItemAtPath:myCachePath error:nil];
                }]];
                [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    //取消
                }]];
                //跳转
                _label.text = @"";
                [self.tableView reloadData];
                [self presentViewController:sheet animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                SettingAboutUsView * us = [[SettingAboutUsView alloc]init];
                [self.navigationController pushViewController:us animated:YES];
            }
                break;
            case 1:
            {

                
            }
                break;
            case 2:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
