//
//  BaseTabBar.m
//  企信通
//
//  Created by 林柏参 on 14/8/1.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#define kCount 3

#import "BaseTabBar.h"
#import "BaseTabBarButton.h"

@interface BaseTabBar()

@property (nonatomic,assign) int itemCount;
@property (nonatomic, strong) NSMutableArray *tabBarButtons;
@property (nonatomic, weak) BaseTabBarButton *selectedButton;

@end

@implementation BaseTabBar

- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!iOS7) { // 非iOS7下,设置tabbar的背景
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"tabbar_background"]];
        }
        
        // 添加中间的加号
        //        [self addPustBtn];
    }
    return self;
}

//-(void)addPustBtn
//{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *image = [UIImage imageWithName:@"tabbar_compose_button"];
//    [btn setTitle:@"哈哈" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//
//    [btn setBackgroundImage:image forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
//
//    [btn setImage:[UIImage imageWithName:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageWithName:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
//
//    btn.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
//    btn.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
//    btn.bounds = CGRectMake(0, 0, 49, 49);
//
//    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
//
//    [self addSubview:btn];
//}

//-(void)click
//{
//    NSLog(@"--");
//}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    // 1.创建按钮
    BaseTabBarButton *button = [[BaseTabBarButton alloc] init];
    CGFloat w = self.frame.size.width / kCount;
    CGFloat x = _itemCount * w;
    CGFloat h = self.frame.size.height;
    
    //    if (_itemCount > 1) {
    //        x += w;
    //    }
    
    button.frame = CGRectMake(x,0,w,h);
    
    [self addSubview:button];
    // 添加按钮到数组中
    [self.tabBarButtons addObject:button];
    
    // 2.设置数据
    button.item = item;
    button.tag = _itemCount;
    
    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4.默认选中第0个按钮
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
    _itemCount++;
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(BaseTabBarButton *)button
{
    // 1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}
@end
