//
//  QXTFriendTableViewController.m
//  企信通
//
//  Created by 林柏参 on 14/8/2.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import "QXTFriendTableViewController.h"
#import <CoreData/CoreData.h>
#import "QXTAppDelegate.h"
#import "QXTAddFriendViewController.h"
#import "ChatViewController.h"

@interface QXTFriendTableViewController ()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
    XMPPJID                     *_toRemovedJID;
    XMPPUserCoreDataStorageObject *_user;
}
@end

@implementation QXTFriendTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushFriend)];

    NSManagedObjectContext *context = xmppDelegate.xmppRosterCoreDataStorage.mainThreadManagedObjectContext;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    
    request.sortDescriptors = @[sort];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    _fetchedResultsController.delegate = self;

    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        DDLogError(@"%@", error.localizedDescription);
    }
}

/**
 *  添加好友控制器
 */
-(void)pushFriend
{
    QXTAddFriendViewController *addFriend = [[QXTAddFriendViewController alloc]init];
    [self.navigationController pushViewController:addFriend animated:YES];
}

#pragma mark - 数据源方法
// 分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _fetchedResultsController.sections.count;
}

// 指定分组的内容
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    id <NSFetchedResultsSectionInfo> info = _fetchedResultsController.sections[section];
//    
//    // [info name]对应的是sectionNum的字段内容文本
//    int state = [[info name] intValue];
//
//    NSString *title = nil;
//    switch (state) {
//        case 0:
//            title = @"在线";
//            break;
//        case 1:
//            title = @"离开";
//            break;
//        case 2:
//            title = @"离线";
//            break;
//        default:
//            title = @"未知";
//            break;
//    }
//    
//    return title;
//}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断修改表格的方式，是否为删除
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        // 要找出需要删除的用户jid，需要知道对应的行
        XMPPUserCoreDataStorageObject *user = [_fetchedResultsController objectAtIndexPath:indexPath];
        
        _toRemovedJID = user.jid;
        
        NSString *msg = [NSString stringWithFormat:@"是否确认删除%@?", user.jidStr];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
}

#pragma mark - 查询结果控制器的代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = _fetchedResultsController.sections[section];
    return [info numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // 取用户记录
    XMPPUserCoreDataStorageObject *user = [_fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = user.displayName;
    
    // 显示用户的实际状态
    cell.detailTextLabel.text = user.primaryResource.status;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XMPPUserCoreDataStorageObject *user = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ChatViewController" bundle:nil];
    ChatViewController *chat = [sb instantiateInitialViewController];
    chat.bareJID = user.jid;
    
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        [xmppDelegate.xmppRoster removeUser:_toRemovedJID];
        
        // 注意清理_toRemovedJID
        _toRemovedJID = nil;
        // indexPathForSelectedRow方法对表格的编辑操作无效
        //        [self.tableView indexPathForSelectedRow]
    }
}
@end