//
//  FadeAnimation.m
//  转场动画
//
//  Created by zhangjiang on 15/5/27.
//  Copyright (c) 2015年 张江. All rights reserved.
//

#import "FadeAnimation.h"

@implementation FadeAnimation
#pragma mark -动画执行时间
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (_fadeDuration != 0.0) {
        return _fadeDuration;
    }
    return 0.4f;
}
#pragma mark -执行的动画
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //获取toVC
    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获取fromVC
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.alpha = 0.0;
        fromVC.view.transform = CGAffineTransformMakeScale(1.03, 1.03);
        toVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}

@end
