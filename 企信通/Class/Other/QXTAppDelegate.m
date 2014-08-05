//
//  QXTAppDelegate.m
//  企信通
//
//  Created by 林柏参 on 14/7/31.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import "QXTAppDelegate.h"
#import "BaseTabBarViewController.h"
#import "XMPPPresence.h"
#import "QXTLoginViewController.h"

NSString * const kXMPPLoginUserNameKey = @"xmppUserName";
NSString * const kXMPPLoginPasswordKey = @"xmppPassword";
NSString * const kXMPPLoginHostNameKey = @"xmppHostName";

@interface QXTAppDelegate() <XMPPStreamDelegate>
{
    LoginFailedBlock        _failedBlock;
    XMPPReconnect           *_xmppReconnect;
    XMPPvCardCoreDataStorage    *_xmppvCardCoreDataStorage;
}

/**
 *  设置XMPPStream
 */
- (void)setupXmppStream;

/**
 *  连接到服务器
 */
- (void)connect;

/**
 *  断开连接
 */
- (void)disconnect;

/**
 *  用户上线
 */
- (void)goOnline;

/**
 *  用户下线
 */
- (void)goOffline;

@end

@implementation QXTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[QXTLoginViewController alloc]init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    // 设置颜色日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    
    // 1. 实例化XMPPStream
    [self setupXmppStream];
    
    return YES;
}

- (void)connect
{
    // 2. 从系统偏好读取用户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *hostName = [defaults stringForKey:kXMPPLoginHostNameKey];
    NSString *userName = [defaults stringForKey:kXMPPLoginUserNameKey];
    
    // 如果用户名或者主机为空，不再继续
    if (hostName.length <= 0 || userName.length <= 0) {
        _failedBlock = nil;
        
        // 在主线程上更新
        dispatch_async(dispatch_get_main_queue(), ^{
            self.window.rootViewController = [[QXTLoginViewController alloc]init];
            
            if (!_window.isKeyWindow) {
                [_window makeKeyAndVisible];
            }
        });
        
        return;
    }
    
    // 设置XMPPStream的hostName&JID
    _xmppStream.hostName = hostName;
    _xmppStream.myJID = [XMPPJID jidWithUser:userName domain:hostName resource:nil];
    
    // 连接
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        DDLogInfo(@"%@", error.localizedDescription);
    } else {
        DDLogInfo(@"发送连接请求成功");
    }
}

#pragma mark - 注销激活状态
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self disconnect];
}

#pragma mark - 应用程序被激活
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self connect];
}

#pragma mark - 成员方法
#pragma mark 登录&注册
- (void)connectOnFailed:(LoginFailedBlock)faild
{
    // 1. 保存块代码
    _failedBlock = faild;

    if (!_xmppStream.isDisconnected) {
        [_xmppStream disconnect];
    }
    
    // 连接到服务器
    [self connect];
}

-(void)setupMainViewController
{
    _failedBlock = nil;
    
    // 在主线程上更新
    dispatch_async(dispatch_get_main_queue(), ^{
        self.window.rootViewController = [[BaseTabBarViewController alloc]init];
        
        if (!_window.isKeyWindow) {
            [_window makeKeyAndVisible];
        }
    });
    
    
}

#pragma mark 用户注销
- (void)logout
{
    [self disconnect];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.window.rootViewController = [[QXTLoginViewController alloc]init];
        
        if (!_window.isKeyWindow) {
            [_window makeKeyAndVisible];
        }
    });
    
    // 如果用户名或者密码错误，将系统偏好中的内容清除
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    [defaults removeObjectForKey:kXMPPLoginHostNameKey];
    [defaults removeObjectForKey:kXMPPLoginPasswordKey];
    [defaults removeObjectForKey:kXMPPLoginUserNameKey];
    
    [defaults synchronize];
}

-(void)setupXmppStream
{
    NSAssert(_xmppStream == nil, @"XMPPStream被重复实例化了!");
    
    // 2. 设置代理
    _xmppStream = [[XMPPStream alloc]init];
    
    _xmppReconnect = [[XMPPReconnect alloc] init];
    // 2> 电子名片
    _xmppvCardCoreDataStorage = [[XMPPvCardCoreDataStorage alloc]init];
    _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardCoreDataStorage];
    _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
    _xmppRosterCoreDataStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterCoreDataStorage];
    
   
    _xmppMessageArchivingCoreDataStorage = [[XMPPMessageArchivingCoreDataStorage alloc]init];
    _xmppMessageArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    
    // 3. 激活扩展模块
    [_xmppReconnect activate:_xmppStream];
    [_xmppvCardTempModule activate:_xmppStream];

    [_xmppvCardAvatarModule activate:_xmppStream];
    [_xmppRoster activate:_xmppStream];
    [_xmppMessageArchiving activate:_xmppStream];
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
//    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (void)disconnect
{
    // 通知服务器，我下线了
    [self goOffline];
    
    // 真正的断开连接
    [_xmppStream disconnect];
}

- (void)teardownXmppStream
{
    [_xmppStream removeDelegate:self];

    [_xmppStream disconnect];

    [_xmppReconnect deactivate];
    [_xmppvCardTempModule deactivate];
    [_xmppvCardAvatarModule deactivate];
    [_xmppRoster deactivate];
    [_xmppMessageArchiving deactivate];

    _xmppReconnect = nil;
    
    _xmppvCardAvatarModule = nil;
    _xmppvCardCoreDataStorage = nil;
    _xmppvCardTempModule = nil;
    
    _xmppRosterCoreDataStorage = nil;
    _xmppRoster = nil;
    
    _xmppStream = nil;
    
    _xmppMessageArchiving = nil;
    _xmppMessageArchivingCoreDataStorage = nil;
}


- (void)goOnline
{
    DDLogInfo(@"用户上线");
    
    // 通知服务器用户上线，服务器知道用户上线后，可以根据服务器记录的好友关系，
    // 通知该用户的其他好友，当前用户上线
    XMPPPresence *presence = [XMPPPresence presence];
    DDLogInfo(@"%@", presence);
    
    // 将展现状态发送给服务器
    [_xmppStream sendElement:presence];
}

- (void)goOffline
{
    DDLogInfo(@"用户下线");
    
    // 通知服务器用户下线
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    DDLogInfo(@"%@", presence);
    
    [_xmppStream sendElement:presence];
}

#pragma mark - XMPPStream协议代理方法
#pragma mark 完成连接
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    DDLogInfo(@"连接成功");
    
    // 登录到服务器，将用户密码发送到服务器验证身份
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPLoginPasswordKey];
    
    if (_isRegisterUser) {
        // 注册
        [_xmppStream registerWithPassword:password error:nil];
    } else {
        // 用户登录
        [_xmppStream authenticateWithPassword:password error:nil];
    }
}

#pragma mark 断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    DDLogInfo(@"断开连接 %@", error);
    if (_failedBlock && error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _failedBlock(kLoginNotConnection);
        });
    }
}

#pragma mark 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    [self goOnline];
    [self setupMainViewController];
}

#pragma mark 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    if (_failedBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _failedBlock(kLoginRegisterError);
        });
    }
}

#pragma mark 身份验证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    DDLogInfo(@"身份验证成功!");
    [self goOnline];
    
    // 显示
    [self setupMainViewController];
}

#pragma mark 用户名或者密码错误
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    DDLogInfo(@"用户名或者密码错误");
    
    // 判断出错处理块代码是否定义
    if (_failedBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _failedBlock(kLoginLogonError);
        });
    }
    
    // 如果用户名或者密码错误，将系统偏好中的内容清除
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:kXMPPLoginHostNameKey];
    [defaults removeObjectForKey:kXMPPLoginPasswordKey];
    [defaults removeObjectForKey:kXMPPLoginUserNameKey];
    
    [defaults synchronize];
}

@end
