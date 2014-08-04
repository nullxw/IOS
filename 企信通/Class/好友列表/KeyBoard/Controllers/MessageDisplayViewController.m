//
//  MessageDisplayViewController.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-10.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "MessageDisplayViewController.h"
#import "ZBMessageManagerFaceView.h"


@interface MessageDisplayViewController (){
    double animationDuration;
    CGRect keyboardRect;
}

@end

@implementation MessageDisplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardChange:)
                                                name:UIKeyboardDidChangeFrameNotification
                                              object:nil];
}

- (void)dealloc{
    self.messageToolView = nil;
    self.faceView = nil;
    self.shareMenuView = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

#pragma mark -keyboard
- (void)keyboardWillHide:(NSNotification *)notification{
    
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
}

- (void)keyboardWillShow:(NSNotification *)notification{
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration= [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)keyboardChange:(NSNotification *)notification{
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight(self.view.frame)) {
        [self messageViewAnimationWithMessageRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:0.25
                                         andState:ZBMessageViewStateShowNone];
    }
}

#pragma end

#pragma mark - messageView animation
- (void)messageViewAnimationWithMessageRect:(CGRect)rect  withMessageInputViewRect:(CGRect)inputViewRect andDuration:(double)duration andState:(ZBMessageViewState)state{
    
    [UIView animateWithDuration:duration animations:^{
        self.messageToolView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect)-CGRectGetHeight(inputViewRect),CGRectGetWidth(self.view.frame),CGRectGetHeight(inputViewRect));
        
        switch (state) {
            case ZBMessageViewStateShowFace:
            {
                self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect),CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
              
                self.shareMenuView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.shareMenuView.frame));
            }
                break;
            case ZBMessageViewStateShowNone:
            {
                self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.faceView.frame));
                
                self.shareMenuView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.shareMenuView.frame));
            }
                break;
            case ZBMessageViewStateShowShare:
            {
                self.shareMenuView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect),CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
                
                self.faceView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.faceView.frame));
            }
                break;

            default:
                break;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}
#pragma end

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initilzer];
    
    animationDuration = 0.25;
}
#pragma mark - 初始化
- (void)initilzer{
    
    CGFloat inputViewHeight;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7) {
        inputViewHeight = 45.0f;
    }
    else{
        inputViewHeight = 40.0f;
    }
    self.messageToolView = [[ZBMessageInputView alloc]initWithFrame:CGRectMake(0.0f,
                                                                               self.view.frame.size.height - inputViewHeight,self.view.frame.size.width,inputViewHeight)];
    self.messageToolView.delegate = self;
    [self.view addSubview:self.messageToolView];
    
    [self shareFaceView];
    [self shareShareMeun];
    
}

- (void)shareFaceView{
    
    if (!self.faceView)
    {
        self.faceView = [[ZBMessageManagerFaceView alloc]initWithFrame:CGRectMake(0.0f,
                                                                                  CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 196)];
        self.faceView.delegate = self;
        [self.view addSubview:self.faceView];
        
    }
}

- (void)shareShareMeun
{
    if (!self.shareMenuView)
    {
        self.shareMenuView = [[ZBMessageShareMenuView alloc]initWithFrame:CGRectMake(0.0f,
                                                                                     CGRectGetHeight(self.view.frame),
                                                                                     CGRectGetWidth(self.view.frame), 196)];
        [self.view addSubview:self.shareMenuView];
        self.shareMenuView.delegate = self;
        
        
        
        ZBMessageShareMenuItem *sharePicItem = [[ZBMessageShareMenuItem alloc]initWithNormalIconImage:[UIImage imageNamed:@"sharemore_pic_ios7"]
                                                                                                title:@"照片"];
        ZBMessageShareMenuItem *shareVideoItem = [[ZBMessageShareMenuItem alloc]initWithNormalIconImage:[UIImage imageNamed:@"sharemore_video_ios7"]
                                                                                                  title:@"拍摄"];
        ZBMessageShareMenuItem *shareLocItem = [[ZBMessageShareMenuItem alloc]initWithNormalIconImage:[UIImage imageNamed:@"sharemore_location_ios7"]
                                                                                                title:@"位置"];
        ZBMessageShareMenuItem *shareVoipItem = [[ZBMessageShareMenuItem alloc]initWithNormalIconImage:[UIImage imageNamed:@"sharemore_videovoip"]
                                                                                                 title:@"视频聊天"];
        self.shareMenuView.shareMenuItems = [NSArray arrayWithObjects:sharePicItem,shareVideoItem,shareLocItem,shareVoipItem, nil];
        [self.shareMenuView reloadData];
    
    }
}
#pragma mark - ZBMessageInputView Delegate
- (void)didSelectedMultipleMediaAction:(BOOL)changed{
    
    if (changed)
    {
         [self messageViewAnimationWithMessageRect:self.shareMenuView.frame
                          withMessageInputViewRect:self.messageToolView.frame
                                       andDuration:animationDuration
                                          andState:ZBMessageViewStateShowShare];
    }
    else{
         [self messageViewAnimationWithMessageRect:keyboardRect
                          withMessageInputViewRect:self.messageToolView.frame
                                       andDuration:animationDuration
                                          andState:ZBMessageViewStateShowNone];
    }
    
}

- (void)didSendFaceAction:(BOOL)sendFace{
    if (sendFace) {
        [self messageViewAnimationWithMessageRect:self.faceView.frame
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:animationDuration
                                         andState:ZBMessageViewStateShowFace];
    }
    else{
        [self messageViewAnimationWithMessageRect:keyboardRect
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:animationDuration
                                         andState:ZBMessageViewStateShowNone];
    }
}

- (void)didChangeSendVoiceAction:(BOOL)changed{
    if (changed){
        [self messageViewAnimationWithMessageRect:keyboardRect
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:animationDuration
                                         andState:ZBMessageViewStateShowNone];
    }
    else{
        [self messageViewAnimationWithMessageRect:CGRectZero
                         withMessageInputViewRect:self.messageToolView.frame
                                      andDuration:animationDuration
                                         andState:ZBMessageViewStateShowNone];
    }
}

/*
 * 点击输入框代理方法
 */
- (void)inputTextViewWillBeginEditing:(ZBMessageTextView *)messageInputTextView{
    
}

- (void)inputTextViewDidBeginEditing:(ZBMessageTextView *)messageInputTextView
{
    [self messageViewAnimationWithMessageRect:keyboardRect
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:animationDuration
                                     andState:ZBMessageViewStateShowNone];
    
    if (!self.previousTextViewContentHeight)
    {
        self.previousTextViewContentHeight = messageInputTextView.contentSize.height;
    }
}

- (void)inputTextViewDidChange:(ZBMessageTextView *)messageInputTextView
{
    CGFloat maxHeight = [ZBMessageInputView maxHeight];
    CGSize size = [messageInputTextView sizeThatFits:CGSizeMake(CGRectGetWidth(messageInputTextView.frame), maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    // End of textView.contentSize replacement code
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        
        [UIView animateWithDuration:0.01f
                         animations:^{
        
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageToolView.frame;
                             self.messageToolView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             if(!isShrinking) {
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
}
/*
 * 发送信息
 */
- (void)didSendTextAction:(ZBMessageTextView *)messageInputTextView{
    
    ZBMessage *message = [[ZBMessage alloc]initWithText:messageInputTextView.text sender:nil timestamp:[NSDate date]];
    [self sendMessage:message];
    
    [messageInputTextView setText:nil];
    [self inputTextViewDidChange:messageInputTextView];
}

- (void)sendMessage:(ZBMessage *)message{

}


#pragma end

#pragma mark - ZBMessageFaceViewDelegate
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele
{
    self.messageToolView.messageInputTextView.text = [self.messageToolView.messageInputTextView.text stringByAppendingString:faceStr];
    [self inputTextViewDidChange:self.messageToolView.messageInputTextView];
    
}
#pragma end

#pragma mark - ZBMessageShareMenuView Delegate
- (void)didSelecteShareMenuItem:(ZBMessageShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    
}
#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
