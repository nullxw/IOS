//
//  QXTAddFriendViewController.m
//  企信通
//
//  Created by 林柏参 on 14/8/4.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import "QXTAddFriendViewController.h"
#import "QXTAppDelegate.h"

@interface QXTAddFriendViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *addFriendText;

@end

@implementation QXTAddFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_addFriendText becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addFriend)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *friendText = _addFriendText.text;
    if (friendText.length > 0) {
        [self addFriend];
    }
    
    return YES;
}

-(void)addFriend
{
    // 1. 用户没有输入
    NSString *friendText = _addFriendText.text;
    if (friendText.length == 0) {
        return;
    }
    
    // 2. 用户只输入了用户名 zhangsan => 拼接域名 zhangsan@teacher.local
    // 判断是否包含@字符
    NSRange range = [friendText rangeOfString:@"@"];
    if (NSNotFound == range.location) {
        // 拼接域名，使用当前账号的域名
        NSString *domain = [xmppDelegate.xmppStream.myJID domain];
        friendText = [NSString stringWithFormat:@"%@@%@", friendText, domain];
    }
    
    // 3. 不能添加自己
    if ([xmppDelegate.xmppStream.myJID.bare isEqualToString:friendText]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能添加自己" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    // 4. 如果已经是好友，则无需添加
    // 如果已经添加成好友，好友的信息会记录在本地数据库中
    // 在本地数据库中直接查找该好友是否存在即可
    XMPPJID *jid = [XMPPJID jidWithString:friendText];
    
    if ([xmppDelegate.xmppRosterCoreDataStorage userExistsWithJID:jid xmppStream:xmppDelegate.xmppStream]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该好友已经存在，无需添加" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    // 5. 添加好友操作
    DDLogInfo(@"%@", friendText);
    // 在XMPP中添加好友的方法，叫做：“订阅”，类似于微博中的关注
    // 发送订阅请求给指定的用户
    
    [xmppDelegate.xmppRoster subscribePresenceToUser:jid];
    
    // 6. 显示一个AlertView提示用户
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订阅请求已经发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 返回到上级视图控制器
    [self.navigationController popViewControllerAnimated:YES];
}

@end
