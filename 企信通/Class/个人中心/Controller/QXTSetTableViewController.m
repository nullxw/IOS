//
//  QXTSetTableViewController.m
//  企信通
//
//  Created by 林柏参 on 14/8/3.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import "QXTSetTableViewController.h"

@interface QXTSetTableViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation QXTSetTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    self.title = [_setStr substringToIndex:2];
    _textField.placeholder = [NSString stringWithFormat:@"请输入%@",[_setStr substringToIndex:2]];
    _textField.text = _setLable.text;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(clcikSave)];
    _textField.delegate = self;
    
    [_textField becomeFirstResponder];
}

-(void)clcikSave
{
    _setLable.text = _textField.text;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
@end