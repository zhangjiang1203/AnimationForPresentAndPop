//
//  BaseAnimation.m
//  转场动画
//
//  Created by zhangjiang on 15/5/27.
//  Copyright (c) 2015年 张江. All rights reserved.
//

#import "BaseAnimation.h"

@implementation BaseAnimation

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(NO, @"animateTransition: should be handled by subclass of BaseAnimation");
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

-(void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    NSAssert(NO, @"handlePinch: should be handled by a subclass of BaseAnimation");
}
@end
