//
//  ViewController.m
//  AudioDemo
//
//  Created by 刘威振 on 16/1/5.
//  Copyright © 2016年 LiuWeiZhen. All rights reserved.
//

#import "ViewController.h"
#import "LocalAudioViewController.h"
#import "RemoteAudioViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.
    self.dataArray = [NSMutableArray arrayWithObjects:@"本地音频", @"远程音频", nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.rowHeight = 44.0f;
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self pushViewController:[LocalAudioViewController class]];
            break;
        case 1:
            [self pushViewController:[RemoteAudioViewController class]];
            break;
        default:
            break;
    }
}

- (void)pushViewController:(Class)cls {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass(cls) bundle:nil];
    UIViewController *controller = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
