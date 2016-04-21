//
//  ErrorAndAdvice.m
//  First·简
//
//  Created by yearwen on 15/6/27.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#import "ErrorAndAdvice.h"

@interface ErrorAndAdvice ()
{
    UITextView * _textFiled1;
    UITextField * _textField;
    
}
@end

@implementation ErrorAndAdvice

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    
}
-(void)creatTableView{
    _textFiled1 = [[UITextView alloc]initWithFrame:CGRectMake(20, 84, kScreenSize.width-40, kScreenSize.height/2-84)];
    _textFiled1.layer.masksToBounds = YES;
    _textFiled1.layer.cornerRadius = 5.0;
    _textFiled1.backgroundColor = [UIColor whiteColor];
    _textFiled1.textAlignment = NSTextAlignmentLeft;
  //  _textFiled1.placeholder =@"请在这里写下您的建议与您发现的错误,我们会尽快回复!";
    _textFiled1.font =[UIFont systemFontOfSize:14];
    _textFiled1.text = @"请在这里写下您的建议与您发现的错误,我们会尽快回复!";
    [self.view addSubview:_textFiled1];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, kScreenSize.height/2+40, kScreenSize.width-40, 30)];
    _textField.placeholder = @"请输入邮箱以便我们联系你(选填)";
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 5.0;
    _textField.backgroundColor =[UIColor whiteColor];
    _textField.borderStyle =UITextBorderStyleNone;
    _textField.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_textField];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textFiled1 resignFirstResponder];
    [_textField resignFirstResponder];

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
