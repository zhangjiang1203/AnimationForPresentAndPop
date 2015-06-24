# AnimationForPresentAndPop
###视图的转场动画

  `视图中使用了masonry类库进行视图控件的约束，再添加控件的地方使用约束直接控制位置，`

  `demo中一共使用了四种转场动画效果，分别是渐隐，缩放，开关门，折叠四种动画，`
  
  `masonry类库的使用在这不多说，使用转场动画时，遵循demo上的例子即可，`
  
  `值得说明的是这个转场动能只能使用在一层中，即在你实现代理方法的那个视图中有这个视图转场动画，在下一个跳转视图中就没有了`
  
  `可以创建一个baseViewController，在这个里面实现转场动画的协议，其他的视图都集成自这个类就可以在所有的视图中使用转场动画了`
  
  `当然你也可以定义多个转场动画，轮换使用`
  
###下面是使用代码

```
#pragma mark - 跳转开始的动画协议push过去的动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{        
    return _animationBase;
}
```
#pragma mark -pop回来的动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{     
    
    return _animationBase;
    
}

```
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{           
    
     if ([fromVC isKindOfClass:FirstAnimationViewController.class] && ![toVC isEqual:self]) return nil;
    switch (operation) {
        case UINavigationControllerOperationPush:
           _animationBase.type = AnimationTypePresent;
           return _animationBase;
            break;
        case UINavigationControllerOperationPop:
            _animationBase.type = AnimationTypeDismiss;
            return _animationBase;
            break;
    }
    return nil;
}


```
self.navigationController.delegate = self; 
###最后要在遵循导航栏的协议
