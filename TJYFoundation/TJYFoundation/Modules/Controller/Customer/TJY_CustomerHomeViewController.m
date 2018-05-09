//
//  TJY_CustomerHomeViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/7.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_CustomerHomeViewController.h"

@interface TJY_CustomerHomeViewController ()

@end

@implementation TJY_CustomerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView.titleLabel.text = @"客户";
    NSArray  *  viewArray = @[[self.view  viewWithTag:100],[self.view  viewWithTag:101],[self.view  viewWithTag:102],[self.view  viewWithTag:103]];
    [viewArray  enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self  layerCornerRadiusWith:obj];
    }];
}
-(void)layerCornerRadiusWith:(UIView *)view{
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor  lightGrayColor].CGColor;
}
- (IBAction)tapClick:(UIGestureRecognizer *)sender {
    GMLog("click :::%ld",sender.view.tag);
}
- (IBAction)btnClick:(UIButton *)sender {
     GMLog("btn :::%ld",sender.tag);
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
