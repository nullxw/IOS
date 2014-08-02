//
//  QXTAppDelegate.h
//  企信通
//
//  Created by 林柏参 on 14/7/31.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPStream.h"

// 全局AppDelegate代理的宏
#define xmppDelegate    ((QXTAppDelegate *)[[UIApplication sharedApplication] delegate])

typedef enum
{
    kLoginNotConnection = 0,    // 无法连接
    kLoginLogonError,           // 用户名或者密码错误
    kLoginRegisterError,        // 用户注册失败
    
} kLoginErrorType;

// 定义注册登录出错块代码
typedef void(^LoginFailedBlock)(kLoginErrorType type);

@interface QXTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  xmpp 流
 */
@property (strong,nonatomic,readonly) XMPPStream *xmppStream;

/**
 *  注册用户标记
 */
@property (nonatomic, assign) BOOL isRegisterUser;

/**
 *  有登录界面调用，登录到服务器
 */
- (void)connectOnFailed:(LoginFailedBlock)faild;

/**
 *  用户注销
 */
- (void)logout;

@end
