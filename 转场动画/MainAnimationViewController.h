//
//  MainAnimationViewController.h
//  转场动画
//
//  Created by zhangjiang on 15/5/27.
//  Copyright (c) 2015年 张江. All rights reserved.
//

#import <UIKit/UIKit.h>
//使用不带前缀的约束
#define MAS_SHORTHAND
//使用带前缀的约束mas_
#define MAS_SHORTHAND_GLOBALS
@interface MainAnimationViewController : UIViewController<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>

@end
