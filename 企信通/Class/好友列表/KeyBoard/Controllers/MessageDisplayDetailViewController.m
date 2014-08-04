//
//  MessageDisplayDetailViewController.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-16.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "MessageDisplayDetailViewController.h"
#import "ZBMessageBubble.h"

@interface MessageDisplayDetailViewController (){
    NSMutableArray *messages;
}

@end

@implementation MessageDisplayDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    
    _messageDisplayView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messages = [[NSMutableArray alloc]initWithCapacity:0];
    
}

- (void)setup
{
    self.messageDisplayView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f,0.0f,320.0f, self.messageToolView.frame.origin.y) style:UITableViewStylePlain];
    [self.view addSubview:self.messageDisplayView];
    self.messageDisplayView.delegate = self;
    self.messageDisplayView.dataSource = self;
}

#pragma mark tableViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messages.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"indentifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    ZBMessage *message = messages[indexPath.row];
    
    UIImageView *messageView = [[[ZBMessageBubble alloc]init] getBubbleViewByMessage:message];
    
    if (iOS7) {
        messageView.frame = CGRectMake(320-CGRectGetWidth(messageView.frame)-40, 68, CGRectGetWidth(messageView.frame), CGRectGetHeight(messageView.frame));
    }else
    {
        messageView.frame = CGRectMake(320-CGRectGetWidth(messageView.frame)-40, 22, CGRectGetWidth(messageView.frame), CGRectGetHeight(messageView.frame));
    }
    
    
    [cell.contentView addSubview:messageView];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)sendMessage:(ZBMessage *)message{
    [messages addObject:message];
    [self.messageDisplayView reloadData];
    [self scrollTableView];
}

- (void)messageViewAnimationWithMessageRect:(CGRect)rect  withMessageInputViewRect:(CGRect)inputViewRect andDuration:(double)duration andState:(ZBMessageViewState)state{
    
    [super messageViewAnimationWithMessageRect:rect withMessageInputViewRect:inputViewRect andDuration:duration andState:state];
    
    self.messageDisplayView.frame = CGRectMake(0.0f,0.0f,320.0f,self.messageToolView.frame.origin.y);
    [self scrollTableView];
}

-(void)scrollTableView
{
    if (messages.count>0)
    {
        [self.messageDisplayView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
