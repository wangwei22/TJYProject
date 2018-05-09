//
//  TJY_CustomerInputViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/8.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_CustomerInputViewController.h"

@interface TJY_CustomerInputViewController ()

@end

@implementation TJY_CustomerInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView.titleLabel.text = @"编辑客户";
    UIButton  *  btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [btn  setTitle:@"提交" forState:UIControlStateNormal];
    [btn  setTitleColor:ssRGBHex(0x0080ff) forState:UIControlStateNormal];
    [self.titleView  addSubview:btn];
    [btn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(self.titleView);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(80);
    }];
    [[btn  rac_signalForControlEvents:UIControlEventTouchUpInside]  subscribeNext:^(__kindof UIControl * _Nullable x) {
        GMLog(".......");
    }];
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
