//
//  ReadDetailView.m
//  First·简
//
//  Created by yearwen on 15-6-15.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "ReadDetailView.h"

@interface ReadDetailView ()<UIWebViewDelegate>
{
    //AFHTTPRequestOperationManager * _manager;
    NSString * _html;
    UIWebView * _webView;
    BOOL _isLoadingFinish;
}

@end

@implementation ReadDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _manager = [AFHTTPRequestOperationManager manager];
    //响应格式 二进制 不解析
    _manager.responseSerializer  = [AFHTTPResponseSerializer serializer];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatHttpRequest];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame  = CGRectMake(20, 20, 45, 45);
    [button setBackgroundImage:[UIImage imageNamed: @"misc_stop_iphone"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self creatWebView];
    [self.view addSubview:button];
}


-(void)creatWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 65, kScreenSize.width, kScreenSize.height-65)];
      _webView.delegate =self;
    _webView.scalesPageToFit = YES;
  
    //  [_webView loadHTMLString:_html baseURL:nil];
   // _isLoadingFinish = NO;
    
     [_webView setBackgroundColor:[UIColor colorWithRed:158/255 green:189/255 blue:125/255 alpha:1]];
  
}

-(void)btnClick{

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    _webView.scalesPageToFit = YES;

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


-(void)creatHttpRequest{
    _html = @"";
    NSDictionary *body = @{@"contentid":self.webViewUrl,@"client":@(2)};
    __weak typeof(self) weakSelf = self;
    [_manager POST:kViewDetail parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *data =dict[@"data"];
            _html = data[@"html"];
            [_webView loadHTMLString:_html baseURL:nil];
              [ weakSelf.view addSubview:_webView];
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
