//
//  ChatViewController.h
//  企信通
//
//  Created by 林柏参 on 14/8/4.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//  聊天控制器

#import <UIKit/UIKit.h>
#import "QXTAppDelegate.h"

@interface ChatViewController : UIViewController
// 聊天的好友JID
@property (nonatomic, strong) XMPPJID *bareJID;
@end
