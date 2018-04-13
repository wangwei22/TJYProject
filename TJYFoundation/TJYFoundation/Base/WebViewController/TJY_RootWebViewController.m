//
//  TJY_RootWebViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/12.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_RootWebViewController.h"

@interface TJY_RootWebViewController ()

@end

@implementation TJY_RootWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)updateNavigationItems{
    if (_isShowCloseBtn) {
        if (self.webView.canGoBack) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            self.titleView.shutBtn.hidden = false;
            [[titleView.shutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else{
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.titleView.shutBtn.hidden = YES;
        }
    }
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
