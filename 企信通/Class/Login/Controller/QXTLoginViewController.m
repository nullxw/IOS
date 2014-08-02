//
//  QXTLoginViewController.m
//  企信通
//
//  Created by 林柏参 on 14/8/2.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import "QXTLoginViewController.h"
#import "QXTAppDelegate.h"

// extern关键字用于定义常量，而常量本身的内容是在其他位置定义的
// 在OC的开发中，官方针对字符串常量是建议使用extern NSString的方式定义的
extern NSString * const kXMPPLoginUserNameKey;
extern NSString * const kXMPPLoginPasswordKey;
extern NSString * const kXMPPLoginHostNameKey;

@interface QXTLoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *regeist;
@property (strong, nonatomic) IBOutlet UIButton *login;

@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *hostNameText;

@end



@implementation QXTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置UI
    [self setupUi];
}

#pragma maek - 设置UI
-(void)setupUi
{
    [_regeist setBackgroundImage:[UIImage resizedImageWithName:@"LoginwhiteBtn"] forState:UIControlStateNormal];
    [_regeist setBackgroundImage:[UIImage resizedImageWithName:@"LoginwhiteBtn_Hl"] forState:UIControlStateHighlighted];
    
    [_login setBackgroundImage:[UIImage resizedImageWithName:@"LoginGreenBigBtn"] forState:UIControlStateNormal];
    [_login setBackgroundImage:[UIImage resizedImageWithName:@"LoginGreenBigBtn_Hl"] forState:UIControlStateHighlighted];
    
    // 3. 从系统偏好读取用户已经保存的信息设置UI
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _usernameText.text = [defaults stringForKey:kXMPPLoginUserNameKey];
    _passwordText.text = [defaults stringForKey:kXMPPLoginPasswordKey];
    _hostNameText.text = [defaults stringForKey:kXMPPLoginHostNameKey];
    
    if (_usernameText.text.length == 0) {
        [_usernameText becomeFirstResponder];
    } else {
        [_passwordText becomeFirstResponder];
    }
}

/**
 *  注册
 */
- (IBAction)regeist:(id)sender {
    
}

/**
 *  登录
 */
- (IBAction)login:(UIButton *)sender {
    
    //表单提交前的验证
    if (_usernameText.text.length <= 0 || _passwordText.text.length <= 0 || _hostNameText.text.length <= 0) {
        [tooles MsgBox:@"亲 用户名或密码不能为空哦"];
        return;
    }
    
    // 1. 获取用户输入内容
    NSString *userName = _usernameText.text;
    NSString *password = _passwordText.text;
    NSString *hostName = _hostNameText.text;
    
    // 2. 系统偏好，用来存储常用的个人信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:userName forKey:kXMPPLoginUserNameKey];
    [defaults setObject:password forKey:kXMPPLoginPasswordKey];
    [defaults setObject:hostName forKey:kXMPPLoginHostNameKey];
    
    [defaults synchronize];
    
    // 3. 获取AppDelegate
    // 代理如何知道是注册还是登录
    xmppDelegate.isRegisterUser = sender.tag;
    
    /**
     连接到主机的错误情况
     
     1> 连接不到服务器
     2> 用户名或者密码错误
     */
    [xmppDelegate connectOnFailed:^(kLoginErrorType type) {
        NSString *msg = nil;
        if (type == kLoginLogonError) {
            msg = @"用户名或者密码错误";
        } else if (type == kLoginNotConnection) {
            msg = @"无法连接到服务器";
        } else if (type == kLoginRegisterError) {
            msg = @"用户名重复，无法注册";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        if (type == kLoginLogonError) {
            [_passwordText becomeFirstResponder];
        } else if (type == kLoginNotConnection) {
            [_hostNameText becomeFirstResponder];
        } else {
            [_usernameText becomeFirstResponder];
        }
    }];

}

/**
 *  点击空白处退出键盘
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
