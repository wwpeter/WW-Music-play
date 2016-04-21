//
//  AppDelegate.m
//  First·简
//
//  Created by yearwen on 15-6-11.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "AppDelegate.h"
#import "MainBaseController.h"
#import "ReadController.h"
#import "DDMenuController.h"
#import "LeftController.h"
#import "UMSocial.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initUM];
    [self creatMainBase];
    [self addAniewControllers];
    return YES;
}
-(void)initUM{
    [UMSocialData setAppKey:kUMengKey];

}

-(void)creatMainBase{
    
  //  MainBaseController * base = [[MainBaseController alloc]init];
    ReadController *base = [[ReadController alloc]init];
    base.title = @"微·阅读";
    UINavigationController  * nav=  [[UINavigationController alloc]initWithRootViewController:base];

    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:nav];
    _menuController = rootController;
    
    LeftController *left = [[LeftController alloc]init];
    rootController.leftViewController = left;
  //  rootController.rightViewController = left;
        self.window.rootViewController = rootController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}


//启动default
- (void)addAniewControllers {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"life1"]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    imageView.image = image;
    [self.window addSubview:imageView];
    [UIView animateWithDuration:6 animations:^{
         imageView.alpha = 0.0;//让imageVeiw消失
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
