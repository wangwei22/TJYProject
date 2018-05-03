//
//  TJY_SignBaseViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/25.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_SignBaseViewController.h"

@interface TJY_SignBaseViewController ()

@end

@implementation TJY_SignBaseViewController
@synthesize titleView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:0xf6f6f6];
    titleView = [[NavTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, MyNavHeight+STATUSBAR_H)];
    [titleView.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [self addObserver:self forKeyPath:@"title" options:0 context:NULL];
    if (self.navigationController.viewControllers.count >3) {
        titleView.shutBtn.hidden = false;
        [[titleView.shutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
              [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else{
        titleView.shutBtn.hidden = YES;
    }
    [self.view insertSubview:titleView atIndex:0];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    titleView.titleLabel.text = self.title;
}

- (void)back:(id)sender {
    if (_backClicked != nil) {
        _backClicked();
    } else {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
//            [self.navigationController popViewControllerAnimated:YES];
            [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super  viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[UIApplication  sharedApplication] .keyWindow endEditing:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super  viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)dealloc{
//    [self removeObserver:self forKeyPath:@"title"];
}


-(NSString *)dateWithTimeIntervalString:(NSString *)string{
    
    NSString * timeStampString = string;
    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"HH:mm:ss"];
    return [objDateformat stringFromDate: date];
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    GMLog("%@---didReceiveMemoryWarning", self.title);
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    //清除所有的内存中图片缓存，不影响正在显示的图片
    [[SDImageCache sharedImageCache] clearMemory];
    //停止正在进行的图片下载操作
    [[SDWebImageManager sharedManager] cancelAll];
}
-(void)textFieldPlaceholderColorWithTextField:(UITextField*)textField{
    [textField  setValue:ssRGBHex(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
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
