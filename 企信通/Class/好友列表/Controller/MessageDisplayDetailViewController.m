//
//  MessageDisplayDetailViewController.m
//  企信通
//
//  Created by 林柏参 on 14/8/5.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import "MessageDisplayDetailViewController.h"

@interface MessageDisplayDetailViewController ()<UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate>
{
    // 查询结果控制器
    NSFetchedResultsController *_fetchResultsController;
    
}

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inpuerVerticalSpace;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *leftDefaultImage;

@end

@implementation MessageDisplayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 绑定数据
    [self dataBinding];
    
    self.navigationItem.title = _bareName;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(killLeft)];
}

-(void)killLeft
{
    [_textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 绑定数据
- (void)dataBinding
{
    // 1. 数据库的上下文
    NSManagedObjectContext *context = xmppDelegate.xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext;
    
    // 2. 定义查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    // 3. 定义排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    [request setSortDescriptors:@[sort]];
    
    // 4. 需要过滤查询条件，谓词，过滤当前对话双发的聊天记录，将“lisi”的聊天内容取出来
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", _bareJID.bare];
    [request setPredicate:predicate];
    
    // 5. 实例化查询结果控制器
    _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    // 设置代理，接收到数据变化时，刷新表格
    _fetchResultsController.delegate = self;
    
    // 6. 执行查询
    NSError *error = nil;
    if (![_fetchResultsController performFetch:&error]) {
        DDLogError(@"localizedDescription-------%@", error.localizedDescription);
    }else{
         [self scrollToTableBottom];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 回车发送消息
    // 1. 检查是否有内容
    NSString *str = [textField text];
    
    if (str.length > 0) {
        // 2. 实例化一个XMPPMessage（XML一个节点），发送出去即可
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:_bareJID];
        
        [message addBody:str];
        
        [xmppDelegate.xmppStream sendElement:message];
    }
    return YES;
}

#pragma mark - 滚动到表格的末尾
- (void)scrollToTableBottom
{
    // 让表格滚动到末尾
    id <NSFetchedResultsSectionInfo> info = _fetchResultsController.sections[0];
    // 所有记录行数
    NSInteger count = [info numberOfObjects];
    // 判断是否有数据
    if (count <= 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count-1 inSection:0];
    
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

#pragma mark - 查询结果控制器代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [_tableView reloadData];
    
    [self scrollToTableBottom];
}

/**
 *  键盘即将显示的时候会调用
 */
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:time animations:^{
        _inpuerVerticalSpace.constant = rect.size.height;
        
    }completion:^(BOOL finished) {
        [self scrollToTableBottom];
    }];
}

/**
 *  键盘退出的时候会调用
 */
-(void)keyboardWillHide:(NSNotification *)note
{
    CGFloat time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:time animations:^{
        _inpuerVerticalSpace.constant = 0;
    }];
}

/**
 *  点语言的时候退出键盘
 */
- (IBAction)leftDefaultImage:(UIButton *)sender {
    _inpuerVerticalSpace.constant = 0;
    [_textField resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = _fetchResultsController.sections[section];
    
    return [info numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 取消息记录
    XMPPMessageArchiving_Message_CoreDataObject *message = [_fetchResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = message.body;
    
    return cell;
}

#pragma mark 跳转到底部
- (void)jumpBottom {
//    CGFloat offSetY =[_tableView contentSize].height - _tableView.frame.size.height;
//    CGPoint offSet = CGPointMake(0, offSetY);
//    [_tableView setContentOffset:offSet animated:YES];
    NSInteger count = [self.tableView numberOfRowsInSection:0];
    if (count) {
//        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

@end
