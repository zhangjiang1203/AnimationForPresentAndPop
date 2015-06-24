//
//  FirstAnimationViewController.m
//  转场动画
//
//  Created by zhangjiang on 15/5/27.
//  Copyright (c) 2015年 张江. All rights reserved.
//

#import "FirstAnimationViewController.h"

@interface FirstAnimationViewController ()

@end

@implementation FirstAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    self.nameBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nameBtn.layer.borderWidth = 1.0;
    self.nameBtn.layer.masksToBounds= YES;
    self.nameBtn.layer.cornerRadius = 5;
    NSLog(@"传递过来的值1-----%@",self.nameStr);
    
}
- (IBAction)buttonClick:(UIButton *)sender {
    UIViewController *VC = [[UIViewController alloc]init];
    VC.title = @"跳转视图";
    VC.view.backgroundColor = [UIColor greenColor];
    [self.navigationController pushViewController:VC animated:YES];
    
}

@end
