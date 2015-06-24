//
//  PortalAnimation.m
//  转场动画
//
//  Created by zhangjiang on 15/6/23.
//  Copyright (c) 2015年 张江. All rights reserved.
//

#import "PortalAnimation.h"
#define ZOOM_SCALE 0.8
@implementation PortalAnimation
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //拿到相关的视图层次
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //拿到对应的view
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if(self.type == AnimationTypePresent){
        //添加一个toView的快照到视图容器中
        UIView *toViewSnapShot = [toView resizableSnapshotViewFromRect:toView.frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        CATransform3D scale = CATransform3DIdentity;
        toViewSnapShot.layer.transform = CATransform3DScale(scale, ZOOM_SCALE, ZOOM_SCALE, 1);
        [containerView addSubview:toViewSnapShot];
        [containerView sendSubviewToBack:toViewSnapShot];
        
        //fromView的两个半视图--左
        CGRect leftSnapShotRegion = CGRectMake(0, 0, fromView.frame.size.width*0.5, fromView.frame.size.height);
        UIView *leftHandView = [fromView resizableSnapshotViewFromRect:leftSnapShotRegion afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        leftHandView.frame = leftSnapShotRegion;
        [containerView addSubview:leftHandView];
        
        //fromView的两个半视图--右
        CGRect rightSnapShotRegion = CGRectMake(fromView.frame.size.width*0.5, 0, fromView.frame.size.width*0.5, fromView.frame.size.height);
        UIView *rightHandView = [fromView resizableSnapshotViewFromRect:rightSnapShotRegion afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        rightHandView.frame = rightSnapShotRegion;
        [containerView addSubview:rightHandView];
        
        //从当前视图中移除fromView
        [fromView removeFromSuperview];
        
        //添加动画
        [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //打开门的动画
            leftHandView.frame = CGRectOffset(leftHandView.frame, -leftHandView.frame.size.width, 0);
            rightHandView.frame = CGRectOffset(rightHandView.frame, rightHandView.frame.size.width, 0);
            //放大toView
            toViewSnapShot.center = toView.center;
            toViewSnapShot.frame = toView.frame;
        } completion:^(BOOL finished) {
            //删除所有的临时view
            BOOL isCancelled = [transitionContext transitionWasCancelled];
            if (isCancelled) {
                [containerView addSubview:fromView];
                [self removeOtherViews:fromView];
            }else{
                [containerView addSubview:toView];
//                [self removeOtherViews:fromView];
//                [self removeOtherViews:toView];
                toView.frame = containerView.bounds;
            }
//            [containerView addSubview:fromView];
//            NSLog(@"所有的view--%@",containerView.subviews);
            //通知完成
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
        }];
    }else if (self.type == AnimationTypeDismiss){
        //添加from-view视图到容器中
        [containerView addSubview:fromView];
        //添加to-view到视图容器中
        toView.frame = CGRectOffset(toView.frame, toView.frame.size.width, 0);
        [containerView addSubview:toView];
        
        //创建两个半视图 ---左
        CGRect leftSnapShotRegion = CGRectMake(0, 0, toView.frame.size.width*0.5, toView.frame.size.height);
        UIView *leftHandView = [toView resizableSnapshotViewFromRect:leftSnapShotRegion afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        leftHandView.frame = leftSnapShotRegion;
        leftHandView.frame = CGRectOffset(leftHandView.frame, -leftHandView.frame.size.width, 0);
        [containerView addSubview:leftHandView];
        
        //---右
        CGRect rightSnapShotRegion = CGRectMake(toView.frame.size.width*0.5, 0, toView.frame.size.width*0.5, toView.frame.size.height);
        UIView *rightHandView = [toView resizableSnapshotViewFromRect:rightSnapShotRegion afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        rightHandView.frame = rightSnapShotRegion;
        rightHandView.frame = CGRectOffset(rightHandView.frame, rightHandView.frame.size.width, 0);
        [containerView addSubview:rightHandView];
        
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             // to-view关闭门
                             leftHandView.frame = CGRectOffset(leftHandView.frame, leftHandView.frame.size.width, 0);
                             rightHandView.frame = CGRectOffset(rightHandView.frame,  -rightHandView.frame.size.width, 0);
                             
                             // 放大fromView
                             CATransform3D scale = CATransform3DIdentity;
                             fromView.layer.transform = CATransform3DScale(scale, ZOOM_SCALE, ZOOM_SCALE, 1);
                             
                             
                         } completion:^(BOOL finished) {
                             
                             // 移除所有的临时窗口
                             if ([transitionContext transitionWasCancelled]) {
                                 [self removeOtherViews:fromView];
                             } else {
                                 [self removeOtherViews:toView];
                                 toView.frame = containerView.bounds;
                             }
                             
                             //通知上下文调用结束
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
        
    }
}
// 根据当前的视图，删除suou
- (void)removeOtherViews:(UIView*)viewToKeep {
    UIView *containerView = viewToKeep.superview;
    for (UIView *view in containerView.subviews) {
        if (view != viewToKeep) {
            [view removeFromSuperview];
        }
    }
}
@end
