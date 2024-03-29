//
//  QXTAppDelegate.h
//  企信通
//
//  Created by 林柏参 on 14/7/31.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//  友情提示:不需要接口 自己搭建个服务器即可运行~ 邮箱:sshare@qq.com 求交流求进步

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"

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
 *  名片
 */

@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;

/**
 *  好友列表
 */
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterCoreDataStorage;

/**
 *  添加好友
 */
@property (nonatomic, strong, readonly) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

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
