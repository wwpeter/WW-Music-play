//
//  ReadViewController.m
//  First·简
//
//  Created by yearwen on 15-6-12.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "ReadViewController.h"
#import "AFNetworking.h"

@interface ReadViewController ()<UIWebViewDelegate>
{
    //AFHTTPRequestOperationManager * _manager;
    NSString * _html;
    UIWebView * _webView;
}
@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //   self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatHttpRequest];    
}



-(void)creatTableView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
    _webView.delegate = self;
    [_webView loadHTMLString:_html baseURL:nil];
    _webView.backgroundColor  =[UIColor colorWithRed:158/255 green:189/255 blue:125/255 alpha:1];
  //  [_webView setBackgroundColor:[UIColor colorWithRed:158/255 green:189/255 blue:125/255 alpha:1]];
    [self.view addSubview:_webView];
}

-(void)creatHttpRequest{
    _html = @"";
    NSString * strUrl = [self.webViewUrl substringFromIndex:17];
//    NSString * body = [NSString stringWithFormat:@"contentid=%@&client=2",strUrl];
    
    NSDictionary *body = @{@"contentid":strUrl,@"client":@(2)};
     __weak typeof(self) weakSelf = self;
    [_manager POST:@"http://api2.pianke.me/article/info" parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *data =dict[@"data"];
            _html = data[@"html"];
        }
        [weakSelf creatTableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString * srt = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '85%'";
    [_webView stringByEvaluatingJavaScriptFromString:srt];
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=320;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
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
