//
//  FoldAnimation.m
//  转场动画
//
//  Created by zhangjiang on 15/6/24.
//  Copyright (c) 2015年 张江. All rights reserved.
//

#import "FoldAnimation.h"

@implementation FoldAnimation
-(instancetype)init{
    if (self = [super init]) {
        self.folds = 2;
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    BOOL isPresent;
    //判断运动方向
    if (self.type == AnimationTypeDismiss) {
        isPresent = YES;
    }else{
        isPresent = NO;
    }
    
    
    //拿到相关的视图层次
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //拿到对应的view
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    //移出屏幕
    toView.frame = CGRectOffset(toView.frame, toView.frame.size.width, 0);
    [containerView addSubview:toView];
    //添加一个视角转换
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.005;
    containerView.layer.sublayerTransform = transform;
    CGSize size = toView.frame.size;
    //计算折叠的宽度
    float foldWidth = size.width*0.5 / (float)self.folds;
    
    //保存快照视图到数组中
    NSMutableArray *fromViewFolds = [NSMutableArray new];
    NSMutableArray *toViewFolds = [NSMutableArray new];
    //创建折叠视图
    
    for (int i = 0; i<self.folds; i++) {
        float offset = (float)i*foldWidth*2;
        //左边和右边的褶皱fromView 身份转换alpha值为0.0
        UIView *leftFromViewFold = [self createSnapshotFromView:fromView afterUpdates:NO location:offset left:YES];
        leftFromViewFold.layer.position = CGPointMake(offset, size.height*0.5);
        [fromViewFolds addObject:leftFromViewFold];
        [leftFromViewFold.subviews[1] setAlpha:0.0];
        
        UIView *rightFromViewFold = [self createSnapshotFromView:fromView afterUpdates:NO location:offset+foldWidth left:NO];
        rightFromViewFold.layer.position = CGPointMake(offset+foldWidth*2,size.height*0.5);
        [fromViewFolds addObject:rightFromViewFold];
        [rightFromViewFold.subviews[1] setAlpha:0.0];
        
        //左边和右边的褶皱——toview,在每一个视图都定位在屏幕的边缘,90度转换和1.0 alpha的影子
        UIView *leftToViewFold = [self createSnapshotFromView:toView afterUpdates:YES location:offset left:YES];
        leftToViewFold.layer.position = CGPointMake(isPresent?size.width:0.0, size.height*0.5);
        leftToViewFold.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 1.0,0.0);
        [toViewFolds addObject:leftToViewFold];
        
        UIView *rightToViewFold = [self createSnapshotFromView:toView afterUpdates:YES location:offset+foldWidth left:NO];
        rightToViewFold.layer.position = CGPointMake(isPresent?size.width:0.0,size.height*0.5);
        rightToViewFold.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 1.0, 0.0);
        [toViewFolds addObject:rightToViewFold];
    }
    //将fromview移除屏幕
    fromView.frame = CGRectOffset(fromView.frame, fromView.frame.size.width, 0);
    //创建动画

    [UIView animateWithDuration:duration animations:^{
        //设置每个褶皱的最后状态
        for (int i = 0; i < self.folds; i++) {
            float offset = (float)i * foldWidth*2;
            //左边和右边的褶皱从——fromView,在每一个视图都定位在屏幕的边缘,90度转换和1.0 alpha的影子。
            UIView *leftFromView = fromViewFolds[i*2];
            leftFromView.layer.position = CGPointMake(isPresent?0.0:size.width, size.height*0.5);
            leftFromView.layer.transform = CATransform3DRotate(transform, M_PI_2, 0.0, 1.0, 0.0);
            [leftFromView.subviews[1] setAlpha:1.0];
            
            UIView *rightFromView = fromViewFolds[i*2+1];
            rightFromView.layer.position = CGPointMake(isPresent?0.0:size.width, size.height*0.5);
            rightFromView.layer.transform = CATransform3DRotate(transform, -M_PI_2, 0.0, 1.0, 0.0);
            [rightFromView.subviews[1] setAlpha:1.0];
            
            //左边和右边的褶皱从——toView,在每一个视图都定位在屏幕的边缘,90度转换和1.0 alpha的影子。
            UIView *leftToView = toViewFolds[i*2];
            leftToView.layer.position = CGPointMake(offset, size.height * 0.5);
            leftToView.layer.transform = CATransform3DIdentity;
            [leftToView.subviews[1] setAlpha:0.0];
            
            UIView *rightToView = toViewFolds[i*2+1];
            rightToView.layer.position = CGPointMake(offset + foldWidth * 2, size.height * 0.5);
            rightToView.layer.transform = CATransform3DIdentity;
            [rightToView.subviews[1] setAlpha:0.0];
            
        }
    } completion:^(BOOL finished) {
        //移除快照视图
        for (UIView *view in toViewFolds) {
            [view removeFromSuperview];
        }
        for (UIView *view in fromViewFolds) {
            [view removeFromSuperview];
        }
        //重新保存toview和fromview的位置
        toView.frame = containerView.bounds;
        fromView.frame = containerView.bounds;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

//对formView创建快照视图
-(UIView *)createSnapshotFromView:(UIView*)view afterUpdates:(BOOL)afterUpdates location:(CGFloat)offset left:(BOOL)left{
    CGSize size = view.frame.size;
    UIView *containerView = view.superview;
    float foldWidth = size.width * 0.5 / (float)self.folds;
    
    UIView *snapshotView;
    if (!afterUpdates) {
        //创建一个规律的快照
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        snapshotView = [view resizableSnapshotViewFromRect:snapshotRegion afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    }else{
        //因为某种原因——视图创建快照需要一段时间。这里我们将在另一个视图快照,有相同的背景色,所以快照最初呈现时不会太明显
        snapshotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, foldWidth, size.height)];
        snapshotView.backgroundColor = view.backgroundColor;
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        UIView *snapshotView2 = [view resizableSnapshotViewFromRect:snapshotRegion afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        [snapshotView addSubview:snapshotView2];
        
    }
    //创建一个阴影视图
    UIView *snapshotWithShadowView  = [self addShadowToView:snapshotView reverse:left];
    //添加到容器中
    [containerView addSubview:snapshotWithShadowView];
    //设置锚点到左边或者右边的视图
    snapshotWithShadowView.layer.anchorPoint = CGPointMake(left ? 0.0 : 1.0, 0.5);
    return snapshotWithShadowView;
}

//创建一个阴影视图
-(UIView*)addShadowToView:(UIView*)view reverse:(BOOL)reverse{
    //根据view创建一个一样大小的视图
    UIView *viewWithShadow = [[UIView alloc]initWithFrame:view.frame];
    //创建阴影
    UIView *shadowView = [[UIView alloc]initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:1.0].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, reverse ? 0.2 : 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, reverse ? 0.0 : 1.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];
    //添加原视图到新视图中
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];
    //将阴影视图放在最上边
    [viewWithShadow addSubview:shadowView];
    
    return viewWithShadow;
    
}
@end
