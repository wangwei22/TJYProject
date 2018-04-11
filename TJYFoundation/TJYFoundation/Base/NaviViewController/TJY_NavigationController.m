//
//  TJY_NavigationController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/11.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_NavigationController.h"

@interface TJY_NavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
// 记录push标志
@property (nonatomic, getter=isPushing) BOOL pushing;
@end

@implementation TJY_NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 全屏滑动返回
    self.interactivePopGestureRecognizer.enabled = false;
   UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view  addGestureRecognizer:pan];
    pan.delegate = self;
    self.delegate = self;
    GMLog("viewControllers :%ld",self.viewControllers.count);
}
#pragma mark - UIGestureRecognizerDelegate
// 当开始滑动时调用
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 当为根控制器是不让移除当前控制器，非根控制器时允许移除
    GMLog("%ld", self.viewControllers.count);
    BOOL open = self.viewControllers.count > 1;
    return open;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.pushing == YES) {
        return;
    }else{
        self.pushing = YES;
    }
    if (self.viewControllers.count >0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super  pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    
    return [super popToRootViewControllerAnimated:animated];
}
#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.pushing = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
