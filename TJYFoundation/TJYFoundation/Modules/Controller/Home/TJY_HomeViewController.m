//
//  TJY_HomeViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/9.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_HomeViewController.h"
#import "TJY_ADLaunchVC.h"
#import "TJY_RootWebViewController.h"
@interface TJY_HomeViewController ()

@end

@implementation TJY_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //获取所有启动图片信息数组
    NSArray *launchImagesArr = infoDict[@"UILaunchImages"];
    NSLog(@"launchImagesArr: %@", launchImagesArr);
    GMLog("---infoDict:%@---",infoDict);
    [kNotificationCenter  addObserver:self selector:@selector(pushToAd) name:@"pushToAd" object:nil];
}
-(void)pushToAd{
    TJY_RootWebViewController  * vc = [[TJY_RootWebViewController  alloc] initWithUrl:@"http://www.hao123.com"];
    vc.isShowCloseBtn = YES;
    [self.navigationController  pushViewController:vc animated:YES];
}
- (IBAction)btnClick:(id)sender {
    [self.navigationController  pushViewController:[TJY_BaseViewController new] animated:YES];
//    [self  presentViewController:[TJY_BaseViewController new]  animated:YES completion:nil];
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
