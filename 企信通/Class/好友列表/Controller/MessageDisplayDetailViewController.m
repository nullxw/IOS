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

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inpuerVerticalSpace;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *leftDefaultImage;

@end

@implementation MessageDisplayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = xmppDelegate.xmppStream.myJID.bare;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:time animations:^{
        _inpuerVerticalSpace.constant = rect.size.height;
    }];
    
}

-(void)keyboardWillHide:(NSNotification *)note
{
    CGFloat time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
}

/**
 *  点语言的时候退出键盘
 */
- (IBAction)leftDefaultImage:(UIButton *)sender {
    _inpuerVerticalSpace.constant = 0;
    [self.view endEditing:YES];
}

-(void)dealloc
{
    NSLog(@"控制器被销毁了");
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"看什么呢?";
    
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
