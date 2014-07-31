//
//  BaseTabBar.h
//  企信通
//
//  Created by 林柏参 on 14/8/1.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTabBar;

@protocol BaseTabBarDelegate <NSObject>

@optional
- (void)tabBar:(BaseTabBar *)tabBar didSelectedButtonFrom:(NSUInteger)from to:(NSUInteger)to;

@end

@interface BaseTabBar : UIView
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<BaseTabBarDelegate> delegate;

@end
