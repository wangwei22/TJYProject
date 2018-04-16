//
//  TJY_BaseViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/9.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_BaseViewController.h"

@interface TJY_BaseViewController ()

@end

@implementation TJY_BaseViewController
@synthesize titleView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:0xf6f6f6];
    titleView = [[NavTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, MyNavHeight+STATUSBAR_H)];
      [titleView.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addObserver:self forKeyPath:@"title" options:0 context:NULL];
    if (self.navigationController.viewControllers.count >2) {
          titleView.shutBtn.hidden = false;
     [[titleView.shutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
         [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else{
         titleView.shutBtn.hidden = YES;
    }
    if ( self.navigationController.viewControllers.count>1) {
        titleView.backBtn.hidden = false;
    }else{
        titleView.backBtn.hidden = YES;
    }
//    GMLog("%u---lk",self.navigationController.viewControllers.count);
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
            [self.navigationController popViewControllerAnimated:YES];
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

//取消请求
- (void)cancelRequest
{
    
}
-(void)textFieldPlaceholderColorWithTextField:(UITextField*)textField{
    [textField  setValue:ssRGBHex(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)dealloc{
    [titleView removeObserver:self forKeyPath:@"title"];
    [self  cancelRequest];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
