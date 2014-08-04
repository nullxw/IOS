//
//  MessageDisplayDetailViewController.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-16.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "MessageDisplayViewController.h"
#import "QXTAppDelegate.h"

@interface MessageDisplayDetailViewController : MessageDisplayViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *messageDisplayView;
// 聊天的好友JID
@property (nonatomic, strong) XMPPJID *bareJID;
@end
