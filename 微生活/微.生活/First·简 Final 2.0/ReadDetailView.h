//
//  ReadDetailView.h
//  First·简
//
//  Created by yearwen on 15-6-15.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface ReadDetailView : UIViewController
{
    AFHTTPRequestOperationManager *_manager;
}
@property(nonatomic,copy)NSString * webViewUrl;
@end
