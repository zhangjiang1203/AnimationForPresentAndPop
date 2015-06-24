//
//  ScaleAnimation.m
//  转场动画
//
//  Created by zhangjiang on 15/5/29.
//  Copyright (c) 2015年 张江. All rights reserved.
//

#import "ScaleAnimation.h"

@implementation ScaleAnimation
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.40;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //拿到相关的视图层次
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViweController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.type == AnimationTypePresent) {
        toViweController.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        [containerView insertSubview:toViweController.view aboveSubview:fromViewController.view];
        //添加动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViweController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else{
        //将to视图插入到from视图的底部
        [containerView insertSubview:toViweController.view belowSubview:fromViewController.view];
        
        //放大from视图直到他消失
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}
@end
