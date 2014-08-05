//
//  QXTMessageView.m
//  企信通
//
//  Created by 林柏参 on 14/8/5.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import "QXTMessageView.h"

@implementation QXTMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITextField *textField = [[UITextField alloc]init];
        textField.frame = CGRectMake(30, 2, self.frame.size.width - 60, 40);
        textField.backgroundColor = [UIColor whiteColor];
        [self addSubview:textField];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
