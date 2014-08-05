//
//  MessageDisplayDetailViewController.h
//  企信通
//
//  Created by 林柏参 on 14/8/5.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QXTAppDelegate.h"

@interface MessageDisplayDetailViewController : UIViewController
// 聊天的好友JID
@property (nonatomic, strong) XMPPJID *bareJID;

- (void)jumpBottom;

@end
