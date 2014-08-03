//
//  QXTMineTableViewController.m
//  企信通
//
//  Created by 林柏参 on 14/8/2.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import "QXTMineTableViewController.h"
#import "QXTAppDelegate.h"

@interface QXTMineTableViewController ()

@end

@implementation QXTMineTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStyleDone target:self action:@selector(zhuxiao)];
}

- (void)zhuxiao
{
    [xmppDelegate logout];
}


@end
