//
//  MainAnimationViewController.m
//  转场动画
//
//  Created by zhangjiang on 15/5/27.
//  Copyright (c) 2015年 张江. All rights reserved.
//

#import "MainAnimationViewController.h"
#import "FirstAnimationViewController.h"
#import "FadeAnimation.h"
#import "ScaleAnimation.h"
#import "PortalAnimation.h"
#import "FoldAnimation.h"
#import "Masonry.h"
#define KViewHeight self.view.frame.size.height
@interface MainAnimationViewController ()
{
    FadeAnimation *_animationFade;
    ScaleAnimation *_animationScale;
    PortalAnimation *_animationPortal;
    FoldAnimation *_animationFold;
    BaseAnimation *_animationBase;
}
@end

@implementation MainAnimationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    //处理导航栏遮挡问题
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏代理
    self.title = @"动画选择";
    self.navigationController.delegate = self;
    _animationFade = [[FadeAnimation alloc]init];
    _animationScale = [[ScaleAnimation alloc]init];
    _animationPortal = [[PortalAnimation alloc]init];
    _animationFold = [[FoldAnimation alloc]init];
    //添加图片
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"1024.jpg"];
    [self.view addSubview: imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.bottom).offset(-100);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width-40, self.view.frame.size.width-40));
    }];
    //添加按钮
    NSArray *titleArr = @[@"第一个",@"第二个",@"第三个",@"第四个"];
    NSArray *colorArr = @[[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor purpleColor]];
    CGFloat btnW = self.view.frame.size.width/4;
    UIButton *lastBtn;
    for (int i = 0; i< 4; i++) {
        UIButton *button = [UIButton new];
        button.tag = i+10;
        button.backgroundColor = colorArr[i];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pushAnimation:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        //添加按钮约束
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.top).offset(@100);
            make.left.mas_equalTo(lastBtn ? (lastBtn.right) : @(0));
            make.height.mas_equalTo(@40);
            make.width.mas_equalTo(btnW);
        }];
        lastBtn = button;
    }
}
#pragma mark -跳转开始
-(void)pushAnimation:(UIButton*)sender{
    NSInteger index = sender.tag - 10;
    switch (index) {
        case 0:
            _animationBase = _animationFade;
            break;
        case 1:
            _animationBase = _animationFold;
            break;
        case 2:
            _animationBase = _animationPortal;
            break;
        case 3:
            _animationBase = _animationScale;
            break;
    }
    FirstAnimationViewController *VC = [[FirstAnimationViewController alloc]initWithNibName:@"FirstAnimationViewController" bundle:nil];
    VC.nameStr = @"我是张江";
    VC.title = @"第一个";
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 跳转开始的动画协议push过去的动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return _animationBase;
}
#pragma mark -pop回来的动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return _animationBase;
    
}

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
#pragma mark -后续实现功能
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
//    if ([animationController isKindOfClass:[FadeAnimation class]]) {
//        FadeAnimation *controller = (FadeAnimation *)animationController;
//        if (controller.isInteractive) return controller;
//        else return nil;
//    } else return nil;
    return nil;
}
@end
